# Complete all of the following functions using code blocks, and the data 
# structure specified in the section heading comment

#### Array Functions

# Takes an array of integers and returns a new array containing
# only the even entries in the input array 
# (Note: there are a lot of different ways to do this)
def evens(arr) 

end

# Takes an array and returns an array with all occurences of old
# replaced with rep (Note: there are A LOT of different ways to do this too)
def replace_all(arr, old, rep)

end

# Takes a sorted array and a value and inserts the value in sorted order
def insert_sorted(arr, val)

end

# Takes two arrays and returns an array with elements from the two input 
# arrays alternating. Cuts off any trailing values if the two input arrays
# are of different length
def cut_combine(arr1, arr2)

end


#### Hash Functions

# Takes a hash and returns an array containing each key in the hash multiplied 
# by its value
#
# Ex: mult_vals({1=>2,4=>4}) => [2,16]
def mult_vals(hash)

end

# Takes a string and outputs a hash with each unique word
# as a key, and the number of times it occurs as the value
#
# Bonus: modify the skeleton to use regular expressions instead of split
def freq(str)
    arr = str.split(" ")    # splits the string, by spaces, into an array

end

# Takes an array of integers and returns the x^n, where x is the
# most frequently occuring number in the array and n is the number
# of times it occurs
def freq_power(arr)

end


#### Regular Expressions

# Takes a string and returns true if the string represents a decimal
# and false otherwise
# Valid examples: “+1.0”, “+1”, “-124.124”, “1”, “-1”
# Invalid examples: “1,000.0”, “1.1.1”
def is_decimal(str)

end

# Takes a string and returns an array of all valid decimal numbers
# in the string
def find_all_decimals(str)

end

# Takes a string that is a comma delineated list of names, and returns
# an array with all of the names from the input that are formatted correctly
# Names must start with a capital letter, have all other letters be lowercase,
# and include no extraneous characters.
# Ex: check_names("Damien,aDam,0Daniel,Jake,GREG") => ["Damien","Jake"]
def check_names(str)

end

#### Challenge Problem

# For the following function, a two element array [x, y] can be
# treated as an graph edge, from x to y. So a graph defined as
# [[1,2],[2,3],[4,3],[4,1]] would look like this:
#
#       4 -> 3
#(down) |    | (up)
#       1 -> 2  
#
# and reachable([[1,2],[2,3],[4,3],[4,1]], 1, 2) would return true
# but reachable([[1,2],[2,3],[4,3],[4,1]], 1, 4) would return false
#
# Takes a list of edges and two vertices, a and b, and returns
# a boolean indicating whether there is a path between a and b.
def reachable(graph, v1, v2)

end
