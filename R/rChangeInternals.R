initrChange <- function(baseUrl) {

  require("httr")
  require("jsonlite")

  # rChange Base
  rChange <- list()
  rChange$base <- baseUrl

  #rChange.endpoints.listTradingMarkets <- list(name = "listTradingMarkets", urlPart = "/v1/open/markets")

  # rChange Shared
  rChange$shared <- list()

  rChange$shared$getCallingFunctionsName <- function(level = 1) {
    return (gsub(".*\\.", "", sys.calls()[[sys.nframe()-level]]))
  }

  rChange$shared$getCallingFunctionsParameters <- function(level = 1) {
    parameters <- as.list(parent.frame(n = level))
    return (parameters)
  }

  rChange$shared$getUrl <- function(urlEndpointPart, parameters = NULL) {
    urlParametersPart <- rChange$shared$getParametersUrlPart(parameters)
    return (paste(rChange$base, urlEndpointPart, urlParametersPart, sep=""))
  }

  rChange$shared$getParametersUrlPart <- function(parameters = NULL) {
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

  # rChange API Internals
  rChange$api <- list()

  rChange$api$generic <- function(urlEndpointPart) {
    parameters <- rChange$shared$getCallingFunctionsParameters(level = 2)
    url <- rChange$shared$getUrl(urlEndpointPart = urlEndpointPart, parameters = parameters)
    return (rChange$api$request(url = url))
  }

  rChange$api$request <- function(url) {
    #cat(paste("GET", url))
    message(paste("GET", url))
    url <- "https://api.kucoin.com/v1/open/kline?symbol=WAN-BTC&from=1531922401&to=1532441272&type=1hour&limit=10000"
    response <- list()
    response$raw <- GET(url)
    retrySleepTime <- 1
    while (retrySleepTime < 10) {
      if (response$raw != 200) {
        Sys.sleep(retrySleepTime)
        response$raw <- GET(url)
        retrySleepTime <- retrySleepTime + 1
      } else {
        break
      }
    }
    response$content <- list()
    response$content$raw <- content(response$raw, "text")
    response$content$parsed <- fromJSON(response$content$raw, flatten = TRUE)
    return(response)
  }

  return (rChange)
}
