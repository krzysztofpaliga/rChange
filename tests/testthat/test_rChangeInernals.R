context("rChange internals")
source("../../R/rChangeInternals.R")

test_that("rChange remembers the base url it was initialized with", {
  baseUrl <- "http://api.ccexchange.com/public"
  rChange <- initrChange(baseUrl = baseUrl)
  expect_equal(rChange$base, baseUrl)
})

test_that("rChange$shared$getCallingFunctionsName, returns the name of the calling function", {
  rChange <- initrChange(baseUrl = "")
  testFunctionName <- function() {
    returnedFunctionName <- rChange$shared$getCallingFunctionsName()
    expect_equal(returnedFunctionName, "testFunctionName")
  }
  testFunctionName()
})
