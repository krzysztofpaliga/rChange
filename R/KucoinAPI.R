initKucoinAPI <- function() {
  require(rAPI)
  rChange <- init_rAPI(baseUrl = "https://api.kucoin.com")

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

  kucoinAPI$getKlineData <- function (symbol, from, to, type, limit) {
    return (rChange$api$generic(urlEndpointPart = "/v1/open/kline"))
  }

  kucoinAPI$listTradingMarkets <- function () {
    return (rChange$api$generic(urlEndpointPart = "/v1/open/markets"))
  }

  kucoinAPI$getFavouriteSymbols <- function () {
    return (rChange$api$generic(urlEndpointPart = "/v1/market/fav-symbols"))
  }

  kucoinAPI$parameters <- list()
  kucoinAPI$parameters$candleUnit <- list(OneMinute = "1min",
                                          FiveMinutes = "5min",
                                          FifteenMinutes = "15min",
                                          ThirtyMinutes = "30min",
                                          OneHour = "1hour",
                                          EightHours = "8hour",
                                          OneDay = "1day",
                                          OneWeek = "1week")
  return (kucoinAPI)
}

