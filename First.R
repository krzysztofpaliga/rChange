require("httr")
require("jsonlite")

kucoin.base <- "https://api.kucoin.com"

kucoin.endpoints.listTradingMarkets <- list(name = "listTradingMarkets", urlPart = "/v1/open/markets")

kucoin.shared <- list()

kucoin.shared$getCallingFunctionsName <- function(level = 1) {
  return (gsub(".*\\.", "", sys.calls()[[sys.nframe()-level]]))
}

kucoin.shared$getCallingFunctionsParameters <- function(level = 1) {
  parameters <- as.list(parent.frame(n = level))
  return (parameters)
}
kucoin.api <- list()

kucoin.api$generic <- function(urlEndpointPart) {
  parameters <- kucoin.shared$getCallingFunctionsParameters(level = 2)
  url <- kucoin.shared$getUrl(urlEndpointPart = urlEndpointPart, parameters = parameters)
  return (kucoin.api$request(url = url))
}
kucoin.shared$getUrl <- function(urlEndpointPart, parameters = NULL) {
  urlParametersPart <- kucoin.shared$getParametersUrlPart(parameters)
  return (paste(kucoin.base, urlEndpointPart, urlParametersPart, sep=""))
}

kucoin.shared$getParametersUrlPart <- function(parameters = NULL) {
    if (is.null(parameters) || length(parameters) == 0) {
      return ("")
    }
    parametersUrlPart <- "?"
    parameterNames <- names(parameters)
    for (i in 1:length(parameterNames)) {
      sep <- ""
      if (i > 1) {
        sep <- "&"
      }
      parameterName = parameterNames[i]
      parameterValue = get(parameterName, parameters)
      parametersUrlPart <- paste(parametersUrlPart, sep, parameterName, "=", parameterValue, sep="")
    }
    return (parametersUrlPart)
}

kucoin.api$request <- function(url) {
  message(paste("GET", url))
  response.raw <- GET(url)
  response.content.raw <- content(response.raw, "text")
  response.content.parsed <- fromJSON(response.content.raw, flatten = TRUE)
  return(response.content.parsed)  
}

kucoin.api.listCoins <- function() {
  return (kucoin.api$generic(urlEndpointPart = "/v1/market/open/coins"))
}

kucoin.api.listTradingSymbolsTick <- function(market = "BTC") {
  return (kucoin.api$generic(urlEndpointPart = "/v1/market/open/symbols"))
}
hh <- kucoin.api.listTradingSymbolsTick(market = "ETH")
gg <- kucoin.api.listCoins()

kucoin.api.recentlyDealOrders <- function (symbol = "KCS-ETH") {
  return (kucoin.api$generic(urlEndpointPart = "/v1/open/deal-orders"))
}
aa <- kucoin.api.recentlyDealOrders()

kucoin.api.buyOrderBooks <- function (symbol = "KCS-ETH", limit = 10) {
  return (kucoin.api$generic(urlEndpointPart = "/v1/open/orders-buy"))
}
bb <- kucoin.api.buyOrderBooks()
