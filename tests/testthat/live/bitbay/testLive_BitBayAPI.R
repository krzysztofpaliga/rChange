context("[live] BitBayAPI")
setwd("../../../../")
source("R/bitbay/BitBayAPI.R")

bitBayAPI <- initBitBayAPI()

test_that("can initialize BitBayAPI properly", {
  expect_equal(class(bitBayAPI), "list")
})

test_that("bitBayAPI$getAll with default parameters returns a status code 200", {
  response <- bitBayAPI$getAll()
  expect_equal(response$raw$status_code, 200)
})

test_that("bitBayAPI$getTicker with default parameters returns a status code 200", {
  response <- bitBayAPI$getTicker()
  expect_equal(response$raw$status_code, 200)
})

test_that("bitBayAPI$getMarket with default parameters returns a status code 200", {
  response <- bitBayAPI$getMarket()
  expect_equal(response$raw$status_code, 200)
})

test_that("bitBayAPI$getOrderbook with default parameters returns a status code 200", {
  response <- bitBayAPI$getOrderbook()
  expect_equal(response$raw$status_code, 200)
})

test_that("bitBayAPI$getTrades with default parameters returns a status code 200", {
  response <- bitBayAPI$getTrades()
  expect_equal(response$raw$status_code, 200)
})
