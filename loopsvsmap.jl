
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

function map_and_reduce(fn, a, b, N = 100)
    dx = (b-a)/N; 
    x = [a+i*dx for i in 0:N];
    mapped = map(f,x); 
    my_sum = reduce(+,mapped); 
    my_sum = my_sum - 0.5*mapped[1] - 0.5*mapped[N+1]; 
    my_sum *= dx
    return my_sum; 
end 
