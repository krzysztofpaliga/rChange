require("httr")
require("jsonlite")

initRChange <- function(baseUrl) {
  # RChange Base
  RChange <- list()
  RChange$base <- baseUrl
  
  #RChange.endpoints.listTradingMarkets <- list(name = "listTradingMarkets", urlPart = "/v1/open/markets")
  
  # RChange Shared
  RChange$shared <- list()
  
  RChange$shared$getCallingFunctionsName <- function(level = 1) {
    return (gsub(".*\\.", "", sys.calls()[[sys.nframe()-level]]))
  }
  
  RChange$shared$getCallingFunctionsParameters <- function(level = 1) {
    parameters <- as.list(parent.frame(n = level))
    return (parameters)
  }
  
  RChange$shared$getUrl <- function(urlEndpointPart, parameters = NULL) {
    urlParametersPart <- RChange$shared$getParametersUrlPart(parameters)
    return (paste(RChange$base, urlEndpointPart, urlParametersPart, sep=""))
  }
  
  RChange$shared$getParametersUrlPart <- function(parameters = NULL) {
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
  
  # RChange API Internals
  RChange$api <- list()
  
  RChange$api$generic <- function(urlEndpointPart) {
    parameters <- RChange$shared$getCallingFunctionsParameters(level = 2)
    url <- RChange$shared$getUrl(urlEndpointPart = urlEndpointPart, parameters = parameters)
    return (RChange$api$request(url = url))
  }
  
  RChange$api$request <- function(url) {
    message(paste("GET", url))
    response.raw <- GET(url)
    response.content.raw <- content(response.raw, "text")
    response.content.parsed <- fromJSON(response.content.raw, flatten = TRUE)
    return(response.content.parsed)  
  }
  
  return (RChange)
}
