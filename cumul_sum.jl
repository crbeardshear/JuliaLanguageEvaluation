function start(N)

num_cores = Sys.CPU_CORES;

if nprocs()<num_cores
  addprocs(num_cores-1)
end
  
A = SharedArray{Int64}(N);
A = rand(1:32, N);
B = SharedArray{Int64}(num_cores);
C = Array{Array{Int64}}(num_cores);
 
@everywhere function cumul_chunk(array, max_array, node_number)
	   a = accumulate(+, array)
	   max_array[node_number] = maximum(a)
	   a
end

len = length(A);
per_node = floor(Int, len / num_cores);

@sync for idx = 1:num_cores
    @async C[idx] = remotecall_fetch(cumul_chunk,idx,A[(idx - 1)*per_node + 1: per_node*idx],B,idx);	
end

@sync for idx = 2:num_cores
    @async C[idx] = remotecall_fetch( broadcast,idx, +, C[idx] ,sum(B[1:idx-1]) );	
end


w = collect(Iterators.flatten(C));

end

start(10)

@time A = start(parse(Int64,ARGS[1]))
println(A)
