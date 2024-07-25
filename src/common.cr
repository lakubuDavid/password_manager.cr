def to_slice(arr)
  Slice.new(arr.size) {|i| arr[i]}
end
