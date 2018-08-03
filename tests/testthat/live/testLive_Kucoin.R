context("[live] Kucoin")
setwd("../../../")
source("R/Kucoin.R")

kucoinAPI <- initKucoinAPI()
kucoin <- initKucoin(kucoinAPI = kucoinAPI)

test_that("can initialize Kucoin properly", {
  expect_equal(class(kucoin), "list")
})

test_that("Kucoin$fetchHistorical with default parameters returns status code 200", {
  response <- kucoin$fetchHistorical()
  expect_equal(response$raw$status_code, 200)
})

test_that("Kucoin$fetchHistorical with default parameters response data has internally tha same difference between data points", {
  response <- kucoin$fetchHistorical()
  firstTsDifference <- response$content$parsed$data[1,1] - response$content$parsed$data[2,1]
  for (i in 2:nrow(response$content$parsed$data)-1) {
    currentTsDifference <- response$content$parsed$data[i, 1] - response$content$parsed$data[i+1, 1]
    expect_equal(firstTsDifference, currentTsDifference)
  }
})

test_that("Kucoin$fetchHistorical with super old from and todays to returns 800 data points", {
  response <-kucoin$fetchHistorical(from = Sys.Date()-15*365, to = Sys.Date(), limit = 10000)
  expect_equal(nrow(response$content$parsed$data), 800)
})

test_that("Kucoin$fetchAllHistorical with default parameters returns status code 200 and responseList row length is greater 2", {
  responseList <- kucoin$fetchAllHistorical()
  for (response in responseList) {
    expect_equal(response$raw$status_code, 200)
  }
  expect_gt(length(responseList), 1)
})


test_that("Kucoin$fetchAllHistorical with default parameters doesnt drop data between partial requests", {
  responseList <- kucoin$fetchAllHistorical()
  firstFrameData <- unlist(responseList[1], recursive=FALSE)$content$parsed$data
  firstFrameInternalTsDifference <- firstFrameData[1,1] - firstFrameData[2,1]
  for (i in 1:(length(responseList)-1)) {
    aFrameData <- unlist(responseList[i], recursive=FALSE)$content$parsed$data
    bFrameData <- unlist(responseList[i+1], recursive=FALSE)$content$parsed$data
    currentTsDifferenceBetweenFrames <- aFrameData[nrow(aFrameData),1] - bFrameData[1,1]
    expect_equal(firstFrameInternalTsDifference, currentTsDifferenceBetweenFrames)
  }
})

test_that("Kucoin$getAllHistorical with default parameters returns a list with more than 2400 rows", {
  historical <- kucoin$getAllHistorical()
  expect_gt(nrow(historical), 2400)
})

test_that("Kucoin$getMarkets returns a list longer than 2", {
  marketList <- kucoin$getMarkets()
  expect_gt(length(marketList), 2)
})

test_that("Kucoin$getTradedCoinsForMarket with default parameters returns a list longer than 100", {
  coinList <- kucoin$getTradedCoins()
  expect_gt(length(coinList), 100)
})


