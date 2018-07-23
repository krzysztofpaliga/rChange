source("R/KucoinAPI.R")
require(rlist)

initKucoin <- function(kucoinAPI) {
  kucoin <- list()

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
    nextFrom <- veryFirstFrameData[nrow(veryFirstFrameData), 1] + 1
    candleUnitTs <- abs(veryFirstFrameData[1,1] - veryFirstFrameData[2,1])
    while (TRUE) {
      response <- kucoin$fetchHistorical(cryptoCurrency = cryptoCurrency,
                                         baseCurrency = baseCurrency,
                                         type = type,
                                         limit = 10000,
                                         from = nextFrom,
                                         to = as.integer(Sys.time()))
      responseData <- response$content$parsed$data
      isLastPointCurrent <- as.integer(Sys.time()) - responseData[nrow(responseData), 1] /1000 < candleUnitTs
      nextFrom <- responseData[nrow(responseData), 1] + 1
      if (response$raw$status_code == 200 && !isLastPointCurrent)  {
        responseList <- list.append(responseList, response)
      } else {
        break;
      }
    }
    return (responseList)
  }

  kucoin$getAllHistorical <- function(cryptoCurrency = "ETH",
                                      baseCurrency = "BTC",
                                      type=kucoinAPI$parameters$candleUnit$OneHour) {
    cryptoCurrency = "ETH"
    baseCurrency = "BTC"
    type=kucoinAPI$parameters$candleUnit$OneHour
    responseList <- kucoin$fetchAllHistorical(cryptoCurrency = cryptoCurrency,
                                              baseCurrency = baseCurrency,
                                              type = type)

    history <- unlist(responseList[1], recursive=FALSE)$content$parsed$data
    for (i in 2:length(responseList)) {
      dataA <- unlist(responseList[i], recursive=FALSE)$content$parsed$data
      history <- rbind(history, data)
    }
    return (history)
  }

  return (kucoin)
}
