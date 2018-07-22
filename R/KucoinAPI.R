source("RChangeInternals.R")

initKucoinAPI <- function() {
  RChange <- initRChange(baseUrl = "https://api.kucoin.com")
 
  kucoinAPI <- list()
  
  kucoinAPI$listCoins <- function() {
    return (RChange$api$generic(urlEndpointPart = "/v1/market/open/coins"))
  }
  
  kucoinAPI$listTradingSymbolsTick <- function(market = "BTC") {
    return (RChange$api$generic(urlEndpointPart = "/v1/market/open/symbols"))
  }
  
  kucoinAPI$recentlyDealOrders <- function (symbol = "KCS-ETH") {
    return (RChange$api$generic(urlEndpointPart = "/v1/open/deal-orders"))
  }

  kucoinAPI$buyOrderBooks <- function (symbol = "KCS-ETH", limit = 10) {
    return (RChange$api$generic(urlEndpointPart = "/v1/open/orders-buy"))
  }

  return (kucoinAPI)
}

