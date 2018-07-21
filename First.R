source("KucoinInternals.R")
# Kucoin API Externals
kucoinAPI <- list()

kucoinAPI$listCoins <- function() {
  return (kucoin$api$generic(urlEndpointPart = "/v1/market/open/coins"))
}

kucoinAPI$listTradingSymbolsTick <- function(market = "BTC") {
  return (kucoin$api$generic(urlEndpointPart = "/v1/market/open/symbols"))
}
hh <- kucoinAPI$listTradingSymbolsTick(market = "ETH")
gg <- kucoinAPI$listCoins()

kucoinAPI$recentlyDealOrders <- function (symbol = "KCS-ETH") {
  return (kucoin$api$generic(urlEndpointPart = "/v1/open/deal-orders"))
}
aa <- kucoinAPI$recentlyDealOrders()

kucoinAPI$buyOrderBooks <- function (symbol = "KCS-ETH", limit = 10) {
  return (kucoin$api$generic(urlEndpointPart = "/v1/open/orders-buy"))
}
bb <- kucoinAPI$buyOrderBooks()
