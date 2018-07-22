context("[live] Kucoin")
setwd("../../../")
source("R/Kucoin.R")

test_that("can initialize Kucoin properly", {
  kucoinAPI <- initKucoinAPI()
  kucoin <- initKucoin(kucoinAPI = kucoinAPI)
  expect_equal(class(kucoin), "list")
})

test_that("Kucoin$fetchHistorical with default parameter returns status code 200", {
  kucoinAPI <- initKucoinAPI()
  kucoin <- initKucoin(kucoinAPI = kucoinAPI)
  response <- kucoin$fetchHistorical()
  expect_equal(response$raw$status_code, 200)
})

