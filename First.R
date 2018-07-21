require("httr")
require("jsonlite")

kucoin.base <- "https://api.kucoin.com"

kucoin.endpoints <- list()
kucoin.endpoints.listCoins <- list(name = "listCoins", urlPart = "/v1/market/open/coins")
kucoin.endpoints.listTradingMarkets <- list(name = "listTradingMarkets", urlPart = "/v1/open/markets")
kucoin.endpoints.listTradingSymbolsTick <- list(name = "listTradingSymbolsTick", urlPart = "/v1/market/open/symbols", params = list(market = "BTC"))

kucoin.shared <- list()

kucoin.shared.getCallingFunctionsName <- function(level = 1) {
  return (gsub(".*\\.", "", sys.calls()[[sys.nframe()-level]]))
}

kucoin.shared.getCallingFunctionsParameters <- function(level = 1) {
  parameters <- as.list(parent.frame(n = level))
  return (parameters)
}

kucoin.shared$genericNoParams <- function() {
  endpointsName <- kucoin.shared.getCallingFunctionsName()  
  return (kucoin.api(endpointName = endpointsName))
}

kucoin.shared$genericWithParams <- function() {
  endpointsName <- kucoin.shared.getCallingFunctionsName(level = 2)
  parameters <- kucoin.shared.getCallingFunctionsParameters(level = 2)
  parametersUrlPart <- kucoin.shared$getParametersUrlPart(parameters)
  return (kucoin.api(endpointName = endpointsName, parametersUrlPart = parametersUrlPart))
}

kucoin.shared$getUrl <- function(endpointName) {
  endpoint = get(paste("kucoin.endpoints.", endpointName, sep=""))
  endpointUrlPart <- get("urlPart", endpoint)
  return (paste(kucoin.base, endpointUrlPart, sep=""))
}

kucoin.shared$getParametersUrlPart <- function(parameters) {
    parametersUrlPart <- "?"
    parameterNames <- names(parameters)
    for (i in 1:length(parameterNames)) {
      sep <- ""
      if (i > 1) {
        sep <- ","
      }
      parameterName = parameterNames[i]
      parameterValue = get(parameterName, parameters)
      parametersUrlPart <- paste(parametersUrlPart, sep, parameterName, "=", parameterValue, sep="")
    }
    return (parametersUrlPart)
}

kucoin.api <- list()
kucoin.api <- function(endpointName, parametersUrlPart = "") {
  requestUrl <- paste(kucoin.shared$getUrl(endpointName), parametersUrlPart, sep="")
  message(paste("GET", requestUrl))
  response.raw <- GET(requestUrl)
  response.content.raw <- content(response.raw, "text")
  response.content.parsed <- fromJSON(response.content.raw, flatten = TRUE)
  return(response.content.parsed)  
}

kucoin.api.listCoins <- kucoin.shared$genericNoParams

kucoin.api.listTradingSymbolsTick <- function(market = "BTC") {
  return (kucoin.shared$genericWithParams())
}
hh <- kucoin.api.listTradingSymbolsTick(market = "ETH")
gg <- kucoin.api.listCoins()

