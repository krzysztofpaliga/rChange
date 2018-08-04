source("R/rChangeInternals.R")

initBitBayAPI <- function() {
  rChange <- initrChange(baseUrl = "https://bitbay.pl/API")

  bitBayAPI <- list()

  bitBayAPI$shared <- list()

  bitBayAPI$shared$getUrl <- list()
  bitBayAPI$shared$getUrl$public <- function(urlEndpointPart, parameters) {
    url <- paste(rChange$base, urlEndpointPart, "/", parameters$coin, parameters$refCoin, "/", parameters$type, ".json", sep="")
    return (url)
  }

  bitBayAPI$getAll <- function(coin="ETH", refCoin="BTC", type="all") {
    return (rChange$api$generic(urlEndpointPart="/Public", getUrl=bitBayAPI$shared$getUrl$public ))
  }

  bitBayAPI$getTicker <- function(coin="ETH", refCoin="BTC", type="ticker") {
    return (rChange$api$generic(urlEndpointPart="/Public", getUrl=bitBayAPI$shared$getUrl$public ))
  }

  bitBayAPI$getMarket <- function(coin="ETH", refCoin="BTC", type="market") {
    return (rChange$api$generic(urlEndpointPart="/Public", getUrl=bitBayAPI$shared$getUrl$public ))
  }

  bitBayAPI$getOrderbook <- function(coin="ETH", refCoin="BTC", type="orderbook") {
    return (rChange$api$generic(urlEndpointPart="/Public", getUrl=bitBayAPI$shared$getUrl$public ))
  }

  bitBayAPI$getTrades <- function(coin="ETH", refCoin="BTC", type="trades") {
    return (rChange$api$generic(urlEndpointPart="/Public", getUrl=bitBayAPI$shared$getUrl$public ))
  }

  return (bitBayAPI)
}
