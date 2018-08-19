init_CoinGeckoAPI <- function() {
  require(rAPI)
  rAPI <- init_rAPI(baseUrl = "https://api.coingecko.com/api/v3")

  coinGeckoAPI <- list()

  coinGeckoAPI$ping <- function() {
    return (rChange$api$generic(urlEndpointPart = "ping"))
  }
}
