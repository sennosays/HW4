include("HW4_leapfrog.jl")
# Input/Output: state = [x,y,vx,vy], an array of two 2-d positions and velocities for a test particle
# Input: dt is the fixed time step 
# Input: duration is the total 
function optimized_integrate_leapfrog!(state::Vector{Float64}, dt::Float64, duration::Float64; max_num_log::Integer = 100000)
  @assert(length(state)==4) 
  @assert(dt>0.0)
  @assert(duration>0.0)
  
  # Preallocate array to hold data log (including  initial state)
  nsteps = iceil(duration/dt);
  nskip = (nsteps<max_num_log) ? 1 : iceil(nsteps/(max_num_log-1))
  num_log = iceil(nsteps/nskip)+1   
  log = Array(Float64,(num_log,length(state)));

  # Pre-allocate and pre-compute derivaties
  derivs = Array(Float64,4);  
  update_derivs!(state,derivs);

  # Log initial state 
  log_pos = 1
  log[log_pos,:] = deepcopy(state) 

  n = 0
  t = 0.0
  while t<duration
    # ensure don't integrate for more than duration
    dt_tmp = (t+dt<=duration) ? dt : duration-t;

	# advance system by one time step
    advance_leapfrog!(state,derivs,dt_tmp, derivs_current=true)
    t = t + dt_tmp
    n = n + 1

    if (n%nskip==0) # Log data
	   log_pos += 1
   	   @assert( log_pos<=length(log) )
	   #@assert( length(log[log_pos,:])==length(state) )
	   #log[log_pos,:] = deepcopy(state) 
	   log[log_pos,:] = copy(state)
	end
  end
  return log
end
