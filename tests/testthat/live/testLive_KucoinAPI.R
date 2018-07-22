context("[live] KucoinAPI")
setwd("../../../")
source("R/Kucoin.R")

kucoinAPI <- initKucoinAPI()

test_that("kucoinApi$getKlineData is 800 for all candle unit types", {
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
