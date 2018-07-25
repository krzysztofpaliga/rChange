source("R/KucoinAPI.R")


initKucoin <- function(kucoinAPI) {
  kucoin <- list()

  require(rlist)
  require(reshape2)
  require(anytime)

  kucoin$fetchHistorical <- function(cryptoCurrency = "ETH",
                                     baseCurrency = "BTC",
                                     from = Sys.Date()-1,
                                     to = Sys.Date(),
                                     type=kucoinAPI$parameters$candleUnit$OneHour,
                                     limit = 100) {
    fromTs <- ifelse(is.numeric(from), from, as.numeric(as.POSIXct(from)))
    toTs <- ifelse(is.numeric(to), to, as.numeric(as.POSIXct(to)))
    symbol <- paste(cryptoCurrency, "-", baseCurrency, sep="")
    response <- kucoinAPI$getKlineData(symbol = symbol, from = fromTs, to = toTs, type = type, limit = limit)
    return (response)
  }

  kucoin$fetchAllHistorical <- function(cryptoCurrency = "ETH",
                                        baseCurrency = "BTC",
                                        type=kucoinAPI$parameters$candleUnit$OneHour) {
    responseList <- list()
    veryFirstFrame <- kucoin$fetchHistorical(cryptoCurrency = cryptoCurrency,
                                             baseCurrency = baseCurrency,
                                             type = type,
                                             limit = 10000,
                                             from = Sys.Date() - 10*365,
                                             to= as.integer(Sys.time()))
    responseList <- list.append(responseList, veryFirstFrame)
    veryFirstFrameData <- veryFirstFrame$content$parsed$data
    nextFrom <- (veryFirstFrameData[nrow(veryFirstFrameData), 1])/1000 + 1
    candleUnitTs <- abs(veryFirstFrameData[1,1] - veryFirstFrameData[2,1])
    while (TRUE) {
      response <- kucoin$fetchHistorical(cryptoCurrency = cryptoCurrency,
                                         baseCurrency = baseCurrency,
                                         type = type,
                                         limit = 10000,
                                         from = nextFrom,
                                         to = as.integer(Sys.time()))
      responseData <- response$content$parsed$data
      if (response$raw$status_code == 200 && length(responseData) > 0)  {
        isLastPointCurrent <- as.integer(Sys.time()) - responseData[nrow(responseData), 1] /1000 < candleUnitTs /1000
        nextFrom <- (responseData[nrow(responseData), 1])/1000 + 1
        responseList <- list.append(responseList, response)
      }
      if (length(responseData) == 0 || isLastPointCurrent) {
        break;
      }
    }
    return (responseList)
  }

  kucoin$getAllHistorical <- function(cryptoCurrency = "ETH",
                                      baseCurrency = "BTC",
                                      type=kucoinAPI$parameters$candleUnit$OneHour) {
    responseList <- kucoin$fetchAllHistorical(cryptoCurrency = cryptoCurrency,
                                              baseCurrency = baseCurrency,
                                              type = type)

    history <- unlist(responseList[1], recursive=FALSE)$content$parsed$data
    for (i in 2:length(responseList)) {
      dataA <- unlist(responseList[i], recursive=FALSE)$content$parsed$data
      history <- rbind(history, dataA)
    }
    date <- anytime(history[,1]/1000)
    high <- history[,3]
    df <- data.frame(date, high)
    df <- df[order(df$date),]
    return (unique(df))
  }

  kucoin$getMarkets <- function() {
    response <- kucoinAPI$listTradingMarkets()

    return (response$content$parsed$data)
  }

  kucoin$getTradedCoinsForMarket <- function (market = "BTC") {
    response  <- kucoinAPI$listTradingSymbolsTick(market = market)
    responseData <- response$content$parsed$data
    tradedCoinList <- responseData$coinType

    return (tradedCoinList)
  }

  return (kucoin)
}
