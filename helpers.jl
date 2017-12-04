module helpers
	export cumul_chunk
	function cumul_chunk(array, max_array, node_number, num_nodes)
	   len = length(array);
	   per_node = floor(Int, len / num_nodes);
	   if node_number < num_nodes
	       v = view(array, (node_number - 1)*per_node + 1: per_node*node_number )
	   else
	       v = view(array, (node_number - 1)*per_node + 1:len)
	   end   
	   a = accumulate(+, v)
	   max_array[node_number] = maximum(a)
	   a
	end

end
