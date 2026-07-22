
library(testthat)

path<-"./test10/"
pat<-"*\\.rds"
fns<-list.files(path, pattern=pat)
pat2<-"xegaIResult"
files<-fns[grepl(pat2, fns)]


test_that("Do we have 1 xegaIResult file?",
{
expect_equal(1, length(files))
}
)

results<-readRDS(file.path(path,files[[1]]))



results<-readRDS(file.path(path,files[[1]]))

test_that("xegaIResult file: Three elements?",
{
expect_equal(3, length(results))
}
)

test_that("xegaIResult file: Return code 0?",
{
expect_equal(0, results$rc)
}
)


test_that("xegaIResult file: 10 results?",
{
expect_equal(10, length(results$results))
}
)

popsizes<-rep(0, length(results$results))
phenotypeValue<-rep(0, length(results$results))

for (i in (1:length(results$results)))
{
df<-as.data.frame(results$results[[i]]$popStat)
v<-df$max
popsizes[i]<-length(v)
phenotypeValue[i]<-results$results[[i]]$solution$phenotypeValue
test_that(paste0("Improvement in island ", i, "?"),
{
expect_lt(v[1],  v[length(v)])
}
)
}

test_that("All islands same number of generations?",
{
expect_identical(TRUE, all(popsizes[1]==popsizes))
}
)

cat("phenotypeValue\n")
print(phenotypeValue)

test_that("All islands converged to the same phenotypeValue?",
{
expect_identical(TRUE, all(phenotypeValue[1]==phenotypeValue))
}
)


