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
    fromTs <- as.numeric(as.POSIXct(from))
    toTs <- as.numeric(as.POSIXct(to))
    symbol <- paste(cryptoCurrency, "-", baseCurrency, sep="")
    response <- kucoinAPI$getKlineData(symbol = symbol, from = fromTs, to = toTs, type = type, limit = limit)
    return (response)
  }

  kucoin$fetchAllHistorical <- function(cryptoCurrency = "ETH",
                                        baseCurrency = "BTC",
                                        type=kucoinAPI$parameters$candleUnit$OneHour) {
    i <- 1
    responseList <- list()
    while (TRUE) {
      from = Sys.Date()-(i*100)
      to = from + 100
      response <- kucoin$fetchHistorical(from = from, to = to)
      if (response$raw$status_code == 200 && length(response$content$parsed$data) > 0)  {
        responseList <- list.append(responseList, response)
      } else {
        break;
      }
      i <- i+1
    }
    return (responseList)
  }

  return (kucoin)
}
