LIBS=-lgtest -lpthread

install:integ.cu test.cu
	nvcc -o integral integ.cu
	nvcc -o gtest_test test.cu $(LIBS)
test:gtest_test
	srun ./gtest_test
run:integral
	srun ./integral
