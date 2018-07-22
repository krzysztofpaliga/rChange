source("R/KucoinAPI.R")

initKucoin <- function(kucoinAPI) {
  Kucoin <- list()

  Kucoin$fetchHistorical <- function(cryptoCurrency = "ETH", baseCurrency = "BTC", from = Sys.Date()-1, to = Sys.Date()) {
    fromTs <- as.numeric(as.POSIXct(from))
    toTs <- as.numeric(as.POSIXct(to))
    symbol <- paste(cryptoCurrency, "-", baseCurrency, sep="")
    response <- kucoinAPI$getKlineData(symbol = symbol, from = fromTs, to = toTs)
    return (response)
  }

  return (Kucoin)
}
