context("[live] CoinGeckoAPI")
setwd("../../../../")
source("R/CoinGeckoAPI.R")


coinGeckoAPI <- init_CoinGeckoAPI()

test_that("can initialize CoinGeckoAPI properly", {
  expect_equal(class(coinGeckoAPI), "list")
})
