
#initial function to be integrated 
function f(x::Float64)
    return exp(-0.5*x^2)/sqrt(2*pi)
end

#the following functions all have the same conditions given below 
#they use different methods such as for loops, map, reduce, etc. 

#returns the integral of an input function from a to b 
#inputs:
#f   - fucntion to be integrated 
#a   - begining point of integral (Float64)
#b   - ending point of integral  (Float64)
#N   - number of integration steps (Int)
function for_integrate(fn, a::Float64, b::Float64, N = 100)
    dx = (b-a)/N; 
    my_sum = 0.5*fn(a); 
    for i in 1:N-1
        x = a+i*dx;
        my_sum += fn(x);
    end
    my_sum += 0.5*fn(b)
    my_sum *= dx;
    
    return my_sum; 
end

function map_and_reduce_integrate(fn, a, b, N = 100)
    dx = (b-a)/N; 
    x = [a+i*dx for i in 1:N-1];
    mapped = map(f,x); 
    my_sum = reduce(+,mapped); 
    my_sum += 0.5*(f(a)+f(b)); 
    my_sum *= dx
    return my_sum
end 

function mapreduce_integrate(fn, a, b, N = 100)
    dx = (b-a)/N; 
    x = [a+i*dx for i in 1:N-1];
    my_sum = mapreduce(f,+,x); 
    my_sum += 0.5*(f(a)+f(b)); 
    my_sum *= dx
    return my_sum; 
end 

#test the integrators are accurate 
alpha = 1.0; 
for_int = for_integrate(f,-alpha,alpha); 
mar_int = map_and_reduce_integrate(f,-alpha,alpha); 
mr_int = mapreduce_integrate(f,-alpha,alpha); 

real_int = erf(1.0/sqrt(2)); 

@assert((for_int-real_int)<1e-5)
@assert((mar_int-real_int)<1e-5)
@assert((mr_int-real_int)<1e-5)

for_time_4 = @elapsed(for_integrate(f,0.,1.,10000)); 
for_time_8 = @elapsed(for_integrate(f,0.,1.,100000000)); 

mar_time_4 = @elapsed(map_and_reduce_integrate(f,0.,1.,10000)); 
mar_time_8 = @elapsed(map_and_reduce_integrate(f,0.,1.,100000000)); 

mr_time_4 = @elapsed(mapreduce_integrate(f,0.,1.,10000)); 
mr_time_8 = @elapsed(mapreduce_integrate(f,0.,1.,100000000)); 

println("The time from the for loops for 10^4 is: ",for_time_4," and for 10^8: ",for_time_8);
println("The time for the map and then reduce function for 10^4 is: ",mar_time_4," and for 10^8: ", mar_time_8);  
println("The time for mapreduce for 10^4 is ",mr_time_4," and for 10^8 is ",mr_time_8); 


