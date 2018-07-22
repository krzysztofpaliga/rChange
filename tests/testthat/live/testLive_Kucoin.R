context("[live] Kucoin")
setwd("../../../")
source("R/Kucoin.R")

kucoinAPI <- initKucoinAPI()
kucoin <- initKucoin(kucoinAPI = kucoinAPI)

test_that("can initialize Kucoin properly", {
  expect_equal(class(kucoin), "list")
})

test_that("Kucoin$fetchHistorical with default parameter returns status code 200", {
  response <- kucoin$fetchHistorical()
  expect_equal(response$raw$status_code, 200)
})

test_that("",{})
