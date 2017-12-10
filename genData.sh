for i in 10 100 1000 10000 100000 1000000 10000000
do
	mpi=`mpiexec -np 4 ./cumsum $i 0`
	~/Downloads/julia/bin/julia cumul_sum.jl $i | cut -d" " -f3 | sed "s/^/$i\t$mpi\t/g" >> output.txt
done
echo done
