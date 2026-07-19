library(testthat)
library(xegaMigration)

test_that("AdaptID OK",
 {
 lF<-list()
 lF$slowestTime<-function(){5}
 lF$Generations<-function() {100}
 lF$avgTime<-function() {2.5}
 expect_equal(adaptId(lF), lF$Generations())
 }
)

test_that("AdaptSlowest OK",
 {
 lF<-list()
 lF$slowestTime<-function(){5}
 lF$Generations<-function() {100}
 lF$avgTime<-function() {2.5}
 expect_equal(adaptSlowest(lF), 200)
 }
)

test_that("AdaptSlowest OK",
 {
 lF<-list()
 lF$slowestTime<-function(){5}
 lF$Generations<-function() {100}
 lF$avgTime<-function() {5.5}
 expect_equal(adaptSlowest(lF), 100)
 }
)
