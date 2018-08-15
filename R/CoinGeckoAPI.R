source("R/rChangeInternals.R")

initCoinGeckoAPI <- function() {
  rChange <- initrChange(baseUrl = "https://api.coingecko.com/api/v3")

  coinGeckoAPI <- list()

  coinGeckoAPI$ping <- function() {
    return (rChange$api$generic(urlEndpointPart = "ping"))
  }
}
