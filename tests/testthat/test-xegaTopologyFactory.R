library(testthat)
library(xegaMigration)

test_that("ringTop OK",
 {
 lF<-list()
 lF$npid<-function() {5}
 for ( i in 0:lF$npid())
 { lF$pid<-function() {i}
 expect_identical(((lF$pid()+1) %% lF$npid()), ringTop(lF))
 }
}
)

test_that("ring2Top OK",
 {
 lF<-list()
 lF$npid<-function() {5}
 for ( i in 0:lF$npid())
 { lF$pid<-function() {i}
 expect_identical(((lF$pid()+1) %% lF$npid()), ring2Top(lF)[1])
 expect_identical(((lF$pid()-1) %% lF$npid()), ring2Top(lF)[2])
 }
}
)

test_that("torus2DTop OK",
 {
 lF<-list()
 lF$torusX<-function() {3}
 lF$torusY<-function() {3}
 lF$pid<-function() {0} # node 0
 v<-torus2DTop(lF)
 expect_identical(1, v[1])
 expect_identical(2, v[2])
 expect_identical(3, v[3])
 expect_identical(6, v[4])
 lF$pid<-function() {1} # node 1
 v<-torus2DTop(lF)
 expect_identical(2, v[1])
 expect_identical(0, v[2])
 expect_identical(4, v[3])
 expect_identical(7, v[4])
 lF$pid<-function() {2} # node 2
 v<-torus2DTop(lF)
 expect_identical(0, v[1])
 expect_identical(1, v[2])
 expect_identical(5, v[3])
 expect_identical(8, v[4])
 lF$pid<-function() {4} # node 4
 v<-torus2DTop(lF)
 expect_identical(5, v[1])
 expect_identical(3, v[2])
 expect_identical(7, v[3])
 expect_identical(1, v[4])
 lF$pid<-function() {8} # node 8
 v<-torus2DTop(lF)
 expect_identical(6, v[1])
 expect_identical(7, v[2])
 expect_identical(2, v[3])
 expect_identical(5, v[4])
 }
)

test_that("rndTop OK",
 {
 lF<-list()
 lF$npid<-function() {5}
 lF$nrecv<-function() {1}
 for ( i in 0:lF$npid())
 { lF$pid<-function() {i}
 expect_failure(expect_identical(i, rndTop(lF)))
 }
}
)

test_that("rndTop OK",
 {
 lF<-list()
 lF$npid<-function() {5}
 lF$nrecv<-function() {2}
 for ( i in 0:lF$npid())
 { lF$pid<-function() {i}
   v<-rndTop(lF)
 expect_failure(expect_identical(i, v[1]))
 expect_failure(expect_identical(i, v[2]))
 }
}
)

test_that("gPetersen OK",
 {
 lF<-list()
 lF$GPn<-function() {5}
 lF$GPk<-function() {2}
 lF$npid<-function() {10} # 10 nodes 
# outer
 lF$pid<-function() {0} # node 0
 v<-gPetersenTop(lF)    # prev, next, spoke
 expect_equal(4, v[1])
 expect_equal(1, v[2])
 expect_equal(5, v[3])
 lF$pid<-function() {1} # node 1
 v<-gPetersenTop(lF)    # prev, next, spoke
 expect_equal(0, v[1])
 expect_equal(2, v[2])
 expect_equal(6, v[3])
 lF$pid<-function() {2} # node 2
 v<-gPetersenTop(lF)    # prev, next, spoke
 expect_equal(1, v[1])
 expect_equal(3, v[2])
 expect_equal(7, v[3])
 lF$pid<-function() {3} # node 3
 v<-gPetersenTop(lF)    # prev, next, spoke
 expect_equal(2, v[1])
 expect_equal(4, v[2])
 expect_equal(8, v[3])
 lF$pid<-function() {4} # node 3
 v<-gPetersenTop(lF)    # prev, next, spoke
 expect_equal(3, v[1])
 expect_equal(0, v[2])
 expect_equal(9, v[3])
# inner
 lF$pid<-function() {5} # node 5
 v<-gPetersenTop(lF)
 expect_equal(8, v[1])
 expect_equal(7, v[2])
 expect_equal(0, v[3])
 lF$pid<-function() {6} # node 5
 v<-gPetersenTop(lF)
 expect_equal(9, v[1])
 expect_equal(8, v[2])
 expect_equal(1, v[3])
 lF$pid<-function() {7} # node 5
 v<-gPetersenTop(lF)
 expect_equal(5, v[1])
 expect_equal(9, v[2])
 expect_equal(2, v[3])
 lF$pid<-function() {8} # node 5
 v<-gPetersenTop(lF)
 expect_equal(6, v[1])
 expect_equal(5, v[2])
 expect_equal(3, v[3])
 lF$pid<-function() {9} # node 5
 v<-gPetersenTop(lF)
 expect_equal(7, v[1])
 expect_equal(6, v[2])
 expect_equal(4, v[3])
 }
)
