using TimerOutputs

function start(N)

to = TimerOutput()
num_cores = Sys.CPU_CORES;

if nprocs()<num_cores
  addprocs(num_cores-1)
end
#A = SharedArray{Int64}(N);
A = rand(1:32, N);
B = SharedArray{Int64}(num_cores);
#C = Array{Array{Int64}}(num_cores);
@everywhere function cumul_chunk(array, max_array, node_number)
	   a = accumulate(+,array)
	   max_array[node_number] = maximum(a)
	   a
end

len = length(A);
per_node = floor(Int, len / num_cores);

@sync for idx = 1:num_cores
    @timeit to "loop1" @async A[(idx - 1)*per_node + 1: per_node*idx] = remotecall_fetch(cumul_chunk,idx,A[(idx - 1)*per_node + 1: per_node*idx],B,idx);	
end

@sync for idx = 2:num_cores
    @timeit to "loop2" @async A[(idx - 1)*per_node + 1: per_node*idx] = remotecall_fetch( broadcast,idx, +, A[(idx - 1)*per_node + 1: per_node*idx] ,sum(B[1:idx-1]) );	
end

show(to; allocations=false)
A

end

#compile
println("compiling")
start(10)

#run
println("")
println("Only the algorithm time:")
start(parse(Int64,ARGS[1]))

println("")
println("using macro @time")
@time start(parse(Int64,ARGS[1]))

#for 10,000,000, it is faster the second time around.
println("")
println("using macro second")
@time start(parse(Int64,ARGS[1]))
