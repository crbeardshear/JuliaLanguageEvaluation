function start()

if nprocs()<4
  addprocs(3)
end
A = Array{Int64}(10000000);
A = ones(A, Int64);
B = Array{Int64}(4);
indices = collect(1:4);
@everywhere include("helpers.jl");

#first scatter, gather of maxvals through shared array
y = @time map(x-> remotecall(testie.cumul_chunk,x,A,B,x,4)  , indices);

#sync to make sure all maxvals are assigned
#call second scatter to do sums 
z = @time map(x -> remotecall( broadcast,x, +, fetch(y[x]) ,sum(B[1:x-1]) ) , indices[2:4]);

w = [fetch(y[1]); fetch(z[1]); fetch(z[2]); fetch(z[3])]
end

@time start()
