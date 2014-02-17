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
#Profile.init(1000000, 0.0008); 

@profile (for j in 1:2; integrate_leapfrog_student(initial_state,dt,duration); end); 
student_data = copy(Profile.fetch()); 
Profile.clear();

@profile (for k in 1:50; optimized_integrate_leapfrog!(initial_state,dt,duration);end); 
#Profile.print(cols=200); 
optimized_data = copy(Profile.fetch()); 
Profile.clear();  

Profile.print(STDOUT,optimized_data,cols=200); 

@profile (for i in 1:50; integrate_leapfrog!(initial_state,dt,duration);end); 
prof_data = copy(Profile.fetch());

initial_state = set_initial_state!();

student_time = @elapsed integrate_leapfrog_student(initial_state,dt,duration); 
prof_time = @elapsed integrate_leapfrog!(initial_state,dt,duration); 
initial_state = set_initial_state!(); 

optimized_time = @elapsed optimized_integrate_leapfrog!(initial_state,dt,duration); 

fpp = open("terminal_prof_profile.txt","w");
Profile.print(fpp,prof_data,cols=200); 
close(fpp); 

fps = open("terminal_student_profile.txt","w"); 
Profile.print(fps,student_data,cols=200); 
close(fps); 

fpo = open("terminal_optimized_profile.txt","w"); 
Profile.print(fpo,optimized_data,cols=200); 
close(fpo);

#Profile.print(STDOUT,optimized_data,cols=200); 
println("The prof's program runs ",student_time/prof_time,"x faster than the students"); 
println("The optimized function runs ",prof_time/optimized_time,"x faster than the prof integrator"); 






