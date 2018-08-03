source("R/KucoinAPI.R")


initKucoin <- function(kucoinAPI) {
  kucoin <- list()
  kucoin$dataHistoricalCSV <- "dataHistorical.csv"

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
                                        type=kucoinAPI$parameters$candleUnit$OneHour,
                                        from = -1) {
    responseList <- list()
    if (from == -1) {
      initialFrom <- Sys.Date() - 10*365
    } else {
      initialFrom <- from
    }
    veryFirstFrame <- kucoin$fetchHistorical(cryptoCurrency = cryptoCurrency,
                                             baseCurrency = baseCurrency,
                                             type = type,
                                             limit = 10000,
                                             from = initialFrom,
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
                                      type=kucoinAPI$parameters$candleUnit$OneHour,
                                      from = -1) {
    responseList <- kucoin$fetchAllHistorical(cryptoCurrency = cryptoCurrency,
                                              baseCurrency = baseCurrency,
                                              type = type,
                                              from = from)

    history <- unlist(responseList[1], recursive=FALSE)$content$parsed$data
    for (i in 2:length(responseList)) {
      dataA <- unlist(responseList[i], recursive=FALSE)$content$parsed$data
      history <- rbind(history, dataA)
    }
    date <- anytime(history[,1]/1000)
    high <- history[,3]
    df <- data.frame(date, high)
    df <- df[order(df$date),]
    df <- unique(df)

    return (df)
  }

  kucoin$getAllCoinsHistorical <- function(market = "BTC",
                                           load = TRUE,
                                           save = TRUE,
                                           addNewest = TRUE,
                                           type = kucoinAPI$parameters$candleUnit$OneHour) {
    allCoinsHistory <- list()
    if (load) {
      fileExists <- file.exists(kucoin$dataHistoricalCSV)
      if (fileExists) {
        allCoinsHistory <- read.csv(kucoin$dataHistoricalCSV, stringsAsFactors = FALSE)[,-1]
      } else {
        allCoinsHistory <- list()
      }
      if (length(allCoinsHistory) == 0 || addNewest) {
        marketCoinList <- kucoin$getTradedCoinsForMarket(market = market)
        for (coin in marketCoinList) {
          if((!is.element(coin, allCoinsHistory$cc) && addNewest) || !fileExists ) {
            coinData <- kucoin$getAllHistorical(cryptoCurrency = coin,
                                                baseCurrency = market,
                                                type = type)
            coinData[["cc"]] <- coin

            allCoinsHistory <- rbind(allCoinsHistory, coinData)
          } else {
            if (addNewest) {
              #TODO: calculate from on the basis of difference between consecutive date entries (delta ts)
              from <- as.Date(as.POSIXct(max(allCoinsHistory[allCoinsHistory$cc == coin,]$date))) - 2
              missingData <- kucoin$getAllHistorical(cryptoCurrency = coin,
                                                     baseCurrency = market,
                                                     type = type,
                                                     from = from)
              missingData[["cc"]] <- coin
              allCoinsHistory <- unique(rbind(allCoinsHistory, missingData))
            }
          }
        }
      }
    } else {
      for (coin in marketCoinList) {
        coinData <- kucoin$getAllHistorical(cryptoCurrency = coin,
                                        baseCurrency = market,
                                        type = type)
        coinData[["cc"]] <- coin

        allCoinsHistory <- rbind(allCoinsHistory, coinData)
      }
    }

    if (save) {
      write.csv(allCoinsHistory, kucoin$dataHistoricalCSV)
    }
    return (allCoinsHistory)
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
