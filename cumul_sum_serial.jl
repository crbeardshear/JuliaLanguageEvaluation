function start(N)
#doesn't improve performance by much
A = Array{Int64}{N}
B = Array{Int64}{N}
A = rand(1:32,N)
@time B = cumsum(A)
end

println("Compile time:")
start(10)

println("only algorithm time: ")
start(parse(Int64,ARGS[1]))

println("algorithm + setup time")
@time start(parse(Int64,ARGS[1]))
