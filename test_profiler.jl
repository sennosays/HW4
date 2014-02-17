include("HW4_leapfrog_student.jl")
include("HW4_leapfrog.jl")
include("optimized_HW4_leapfrog.jl")

function set_initial_state!()
    return [1.,0.,0.,1.];
end 

initial_state = set_initial_state!(); 
n_orbits = 25; 
duration = n_orbits*2*pi; 
dt = 0.01; 

integrate_leapfrog_student(initial_state,dt,duration);
integrate_leapfrog!(initial_state,dt,duration); 

initial_state = set_initial_state!(); 

@profile (for k in 1:50; optimized_integrate_leapfrog!(initial_state,dt,duration);end); 
optimized_data = Profile.fetch(); 
Profile.clear();  

fpo = open("terminal_optimized_profile.txt","w"); 
Profile.print(fpo,optimized_data,cols=200); 
close(fpo);

