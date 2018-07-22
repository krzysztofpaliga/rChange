source("R/rChangeInternals.R")

initKucoinAPI <- function() {
  rChange <- initrChange(baseUrl = "https://api.kucoin.com")

  kucoinAPI <- list()

  kucoinAPI$listCoins <- function() {
    return (rChange$api$generic(urlEndpointPart = "/v1/market/open/coins"))
  }

  kucoinAPI$listTradingSymbolsTick <- function(market = "BTC") {
    return (rChange$api$generic(urlEndpointPart = "/v1/market/open/symbols"))
  }

  kucoinAPI$recentlyDealOrders <- function (symbol = "KCS-ETH") {
    return (rChange$api$generic(urlEndpointPart = "/v1/open/deal-orders"))
  }

  kucoinAPI$buyOrderBooks <- function (symbol = "KCS-ETH", limit = 10) {
    return (rChange$api$generic(urlEndpointPart = "/v1/open/orders-buy"))
  }

  kucoinAPI$getKlineData <- function (symbol, from, to) {
    return (rChange$api$generic(urlEndpointPart = "/v1/open/kline"))
  }

  return (kucoinAPI)
}

