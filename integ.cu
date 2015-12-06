// Contributors: Drake, Wesley. Hemann
# include <thrust/host_vector.h>
# include <thrust/device_vector.h>
# include <thrust/generate.h>
# include <thrust/sort.h>
# include <thrust/copy.h>
# include <algorithm>
# include <cstdlib>
# include <thrust/sequence.h>
# include <thrust/extrema.h>
# include <ctime>

struct x_axis
{
float step;

__host__ __device__
x_axis( float  var)
{
        step = var;
};


 __host__ __device__
float operator()( int  x) {

        return ((float)x)*step;

};
};

// This is the functor that acts as the integrable function
struct square
{
  __host__ __device__
float operator()(float x){return x*x;};
};

template<typename T, typename U, typename V>
void generate_x_axis (T start, U end, V step){

thrust::sequence(start,end,0,step);
}

// This function finds the background area of the integrable function based on user input
template<typename T, typename U, typename V>
float Background_Height(T input_start, U input_end, V output_start){
thrust::transform(input_start,input_end,output_start,square());
int max = thrust::max_element(input_start,input_end);
int min = thrust::min_element(input_start,input_end);

if ( max > -min){
        return 2*max;
}
 else{ return 2*min;}
};

// This functor generates random values within a range
struct  gen{

        int modulus_factor;
        int sign;
__host__ __device__
gen(int range,int parity){

// This allows the range of the value outputted by the functor to change depending on instantiation
        srand(time(NULL));
        modulus_factor = range;
        sign = parity;

}

__host__ __device__
float operator()(){

// creates random float
if ( sign  == 0 ){

        return  -(float)(rand() % (modulus_factor - 1)) + (float)((rand() % 1000)/1000);

}else{

        return (float)(rand() % (modulus_factor -1)) + (float)((rand() % 1000)/1000);
}
};
};



// Generate vector of x-values of dots within a range
template <typename T>
T generate_values(int size, int range, int sign){
// Initialize vector
        thrust::device_vect<float> x (size);
// Instantiate the generating functor
        gen op(range,sign);
// Fill Vector
        thust::generate(x.begin(),x.end(),op());
// Reurn vector
        return x;

};

template <typename T>
float comp( int x_range, float  y_range, int detail, int size){

int loopcount = 0;
int total_dots = 0;
int under_curve = 0;

while ( loopcount <= detail){


T y_vect = generate_values(size,y_range,rand()%2);

T curve  = generate_values(size,x_range,1);

thrust::transform(curve.begin(),curve.end(),curve.begin(),square());

thrust::transform(y_vect.begin(),y_vect.end(),curve.begin(),curve.end(),y_vect.begin(),thrust::less<float>());

int result = thrust::reduce(y_vect.begin(),y_vect.end(),0,thrust::plus<int>();

under_curve = under_curve + result;

loopcount ++:

total_dots = total_dots + size;

}

return (float)(under_curve/total_dots):

};






int main(void)
{

srand(time(0));

int size;
int layer_size;
int detail;
float step;
float background_area;
float area_under_curve;


printf("Input the size,x, of the interval [0,x]:\n");
scanf("%d",&size);
printf("Input the step size for the x-axis:\n");
scanf("%f",&step);
printf("input the size of the random clusters");
scanf("%d",&layer_size);
printf("Input the number of random clusters to be evaluated");
scanf("%d",%detail);


thrust::device_vector<int> d_vec(size);

thrust::sequence(d_vec.begin(),d_vec.end(),1);






// Returns height of backgrond square.
background_area = Background_Height(d_vec.begin(),d_vec.end(),size) * size;
//
area_under_curve = background_area * comp(size, Background_Height(d_vec.begin(),d_vec.end(),size), detail, layer_size);

printf("The approximated area under the curve is %f ", area_under_curve);


return 0;
}
