LIBS=-lgtest -lpthread

install:integ.cu
	nvcc -o integral integ.cu
test:test.cu integ.cu
	nvcc -o test test.cu $(LIBS)
run:integral
	./integral
