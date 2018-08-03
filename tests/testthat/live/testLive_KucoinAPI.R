context("[live] KucoinAPI")
setwd("../../../")
source("R/Kucoin.R")

kucoinAPI <- initKucoinAPI()

test_that("kucoinAPI$getKlineData is 800 for all candle unit types", {
  for (type in kucoinAPI$parameters$candleUnit) {
    if (!(type == kucoinAPI$parameters$candleUnit$OneWeek ||  type == kucoinAPI$parameters$candleUnit$OneDay)) {

    response <- kucoinAPI$getKlineData(symbol = "ETH-BTC",
                                       from = as.numeric(as.POSIXct(Sys.Date()-3650)),
                                       to = as.numeric(as.POSIXct(Sys.Date())),
                                       limit = 10000,
                                       type= type)
    expect_equal(nrow(response$content$parsed$data), 800)
    }
  }
})

test_that("Kucoin$getFavouriteSymbols returns a status code 200", {
  response <- kucoinAPI$getFavouriteSymbols()
  expect_equal(response$raw$status_code, 200)
})

test_that("KucoinAPI$getFavouriteSymbols returns succes true", {
  response <- kucoinAPI$getFavouriteSymbols()
  expect_equal(response$content$parsed$success, TRUE)
})
