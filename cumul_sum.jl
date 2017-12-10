function start(N)

num_cores = Sys.CPU_CORES;

if nprocs()<num_cores
  addprocs(num_cores-1)
end
A = Array{Int64}(N);
A = rand(1:32,N);
B = Array{Int64}(num_cores);
C = Array{Array{Int64}}(num_cores);
@everywhere include("helpers.jl");

@time begin
@sync for idx = 1:num_cores
    @async C[idx] = remotecall_fetch(helpers.cumul_chunk,idx,A,B,idx,num_cores);
end

@sync for idx = 2:num_cores
    @async C[idx] = remotecall_fetch( broadcast,idx, +, C[idx] ,sum(B[1:idx-1]) );
end

#println(C);

w = collect(Iterators.flatten(C));
end

end

#@time start()
start(parse(Int64,ARGS[1]))
