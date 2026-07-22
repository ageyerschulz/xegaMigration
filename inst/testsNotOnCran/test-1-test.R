
library(testthat)

path<-"./test1/"
pat<-"*\\.rds"
fns<-list.files(path, pattern=pat)
pat2<-"xegaResult"
files<-fns[grepl(pat2, fns)]

test_that("Do we have 4 Result files?",
{
expect_equal(4, length(files))
}
)

results<-list()
popsizes<-rep(0, length(files))
for (i in (1:length(files)))
{ results[[i]]<-readRDS(file.path(path,files[[i]]))
df<-as.data.frame(results[[i]]$popStat)
v<-df$max
popsizes[i]<-length(v)
test_that(paste0("Improvement in island ", i, "?"), 
{
expect_lt(v[1], v[length(v)])
}
)
}

test_that("All islands same number of generations?",
{
expect_identical(TRUE, all(popsizes==popsizes))
}
)

