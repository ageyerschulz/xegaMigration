#!/bin/sh
echo "[buildTSPlin105.R: Build 2 configurations.]"
Rscript buildTSPlin105.R

echo "[test-1-run.R: communication=mpi, npid=4, cores/pid=2, migrateEvery=2]"
rm -rf ./test1/
mkdir ./test1
./mpiRun.sh test-1-run.R
echo "[test-1-run.R: finished]"
echo "[test-1-test.R: Analyze results of test-1-run.R]"
Rscript test-1-test.R
echo "[test-1-test.R: finished]"

echo "[test-2-run.R: communication=rds, npid=4, cores/pid=2, migrateEvery=1]"
rm -rf ./test2/
mkdir ./test2
./rdsRun.sh test-2-run.R
echo "[test-2-run.R: finished]"
echo "[test-2-test.R: Analyze results of test-2-run.R]"
Rscript test-2-test.R
echo "[test-2-test.R: finished]"

echo "[test-3-run.R: ... mpi and collect results.]"
rm -rf ./test3/
mkdir ./test3
./mpiRun.sh test-3-run.R
echo "[test-3-run.R: finished]"
echo "[test-3-test.R: Analyze results of test-3-run.R]"
Rscript test-3-test.R
echo "[test-3-test.R: finished]"

echo "[test-4-run.R: ... mpi and collect results.]"
rm -rf ./test4/
mkdir ./test4
./mpiRun.sh test-4-run.R
echo "[test-4-run.R: finished]"
echo "[test-4-test.R: Analyze results of test-4-run.R]"
Rscript test-4-test.R
echo "[test-4-test.R: finished]"

echo "[test-5-run.R: ... rds and collect results.]"
rm -rf ./test5/
mkdir ./test5
./rdsRun.sh test-5-run.R
echo "[test-5-run.R: finished]"
echo "[test-5-test.R: Analyze results of test-5-run.R]"
Rscript test-5-test.R
echo "[test-5-test.R: finished]"

echo "[test-6-run.R: ... rds and collect results.]"
rm -rf ./test6/
mkdir ./test6
./rdsRun.sh test-6-run.R
echo "[test-6-run.R: finished]"
echo "[test-6-test.R: Analyze results of test-6-run.R]"
Rscript test-6-test.R
echo "[test-6-test.R: finished]"

echo "[test-7x-run.R: 3 time orders ... rds and collect results.]"
rm -rf ./test7A/ ./test7B/ ./test7C/
mkdir ./test7A
mkdir ./test7B
mkdir ./test7C
echo "[test-7A-run.R: order 0<1<2<3 ... rds and collect results.]"
./rdsRun.sh test-7A-run.R
echo "[test-7A-run.R: finished]"
echo "[test-7A-test.R: Analyze results of test-7A-run.R]"
Rscript test-7A-test.R
echo "[test-7A-test.R: finished]"
echo "[test-7B-run.R: order 1<2<3<0 ... rds and collect results.]"
./rdsRun.sh test-7B-run.R
echo "[test-7B-run.R: finished]"
echo "[test-7B-test.R: Analyze results of test-7B-run.R]"
Rscript test-7B-test.R
echo "[test-7B-test.R: finished]"
echo "[test-7C-run.R: order 2<1<0<3 ... rds and collect results.]"
./rdsRun.sh test-7C-run.R
echo "[test-7C-run.R: finished]"
echo "[test-7C-test.R: Analyze results of test-7C-run.R]"
Rscript test-7C-test.R
echo "[test-7C-test.R: finished]"
echo "[test-7x-test.R: finished]"

echo "[test-8x-run.R: 3 time orders ... mpi and collect results.]"
rm -rf ./test8A/ ./test8B/ ./test8C/
mkdir ./test8A
mkdir ./test8B
mkdir ./test8C
echo "[test-8A-run.R: order 0<1<2<3 ... mpi and collect results.]"
./mpiRun.sh test-8A-run.R
echo "[test-8A-run.R: finished]"
echo "[test-8A-test.R: Analyze results of test-8A-run.R]"
Rscript test-8A-test.R
echo "[test-8A-test.R: finished]"
echo "[test-8B-run.R: order 1<2<3<0 ... rds and collect results.]"
./mpiRun.sh test-8B-run.R
echo "[test-8B-run.R: finished]"
echo "[test-8B-test.R: Analyze results of test-8B-run.R]"
Rscript test-8B-test.R
echo "[test-8B-test.R: finished]"
echo "[test-8C-run.R: order 2<1<0<3 ... rds and collect results.]"
./mpiRun.sh test-8C-run.R
echo "[test-8C-run.R: finished]"
echo "[test-8C-test.R: Analyze results of test-8C-run.R]"
Rscript test-8C-test.R
echo "[test-8C-test.R: finished]"
echo "[test-8x-test.R: finished]"

