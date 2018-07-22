source("R/KucoinAPI.R")

initKucoin <- function(kucoinAPI) {
  Kucoin <- list()

  Kucoin$fetchHistorical <- function(cryptoCurrency = "ETH",
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

  return (Kucoin)
}
