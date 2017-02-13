# Complete all of the following functions using code blocks, and the data 
# structure specified in the section heading comment

#### Array Functions

# Takes an array of integers and returns a new array containing
# only the even entries in the input array 
# (Note: there are a lot of different ways to do this)
def evens(arr) 
    a = [] # Could also be a = Array.new

    arr.each {|x|
        if x % 2 == 0 then a << x end
    }

    return a

    # This could also be done like this
    # arr.select! {|x| x % 2 == 0} <-- note here what the exclamation point does
    # return arr

    # or like this
    # arr.delete_if {|x| x % 2 != 0}
    # return arr
end

# Takes an array and returns an array with all occurences of old
# replaced with rep (Note: there are A LOT of different ways to do this too)
def replace_all(arr, old, rep)

    #works on 2.4, not 1.9, don't know when it changed
    #arr.each_index {|i|
        #if arr[i] == old then arr[i] == rep end
    #}

    a = []

    arr.each {|x|
        if x != old then a << x else a << rep end
    }

    return a
end

# Takes a sorted array and a value and inserts the value in sorted order
def insert_sorted(arr, val)
    arr.each_index {|i|
        if arr[i] > val then 
            (arr.size-1).downto(i) {|j|
                arr[j+1] = arr[j]
            }

            arr[i] = val
            
            return arr
        end
    }

    arr << val

    return arr
end

# Takes two arrays and returns an array with elements from the two input 
# arrays alternating. Cuts off any trailing values if the two input arrays
# are of different length
def cut_combine(arr1, arr2)
    a = []

    arr1.each_index {|i|
        if i < arr2.size then
            a << arr1[i]
            a << arr2[i]
        end
    }

    a
end


#### Hash Functions

# Takes a hash and returns an array containing each key in the hash multiplied
# by its value
#
# Ex: mult_vals({1=>2,4=>4}) => [2,16]
def mult_vals(hash)
    a = []

    hash.each {|k,v|
        a << (k * v)
    }

    # This could also be
    # hash.map{|k,v| k * v}

    a
end

# Takes a string and outputs a hash with each unique word
# as a key, and the number of times it occurs as the value
#
# Bonus: modify the skeleton to use regular expressions instead of split
def freq(str)
    arr = str.split(" ")    # splits the string, by spaces, into an array
    
    # Method 1
    hash = {}

    arr.each {|x|
        if hash[x] then
            hash[x] = hash[x] + 1
        else
            hash[x] = 1
        end
    }

    # Method 2
    #
    # Default value allows us to avoid that conditional
    #
    # hash = Hash.new(0)
    #
    # arr.each {|x|
    #     hash[x] = hash[x] + 1
    # }
    #

    arr
end

# Takes an array of integers and returns the x^n, where x is the
# most frequently occuring number in the array and n is the number
# of times it occurs
def freq_power(arr)
    hash = Hash.new(0)

    arr.each {|x|
        hash[x] = hash[x] + 1
    }

    # Sorting a hash returns an array, so we have to access
    # the value we want. We also need to reverse sort on the
    # second value of each array
    a = hash.sort {|a,b| b[1] - a[1]}
    a[0][0] ** a[0][1]
end


#### Regular Expressions

# Takes a string and returns true if the string represents a decimal
# and false otherwise
# Valid examples: “+1.0”, “+1”, “-124.124”, “1”, “-1”
# Invalid examples: “1,000.0”, “1.1.1”
def is_decimal(str)
    return (str =~ /^(-|\+)?\d+(\.\d+)?$/)
end

# Takes a string and returns an array of all valid decimal numbers
# in the string
def find_all_decimals(str)
    # This has nested capture groups.  outermost is what we want and
    # that will appear first
    a = str.scan(/((-|\+)?\d+(\.\d+)?)/)

    a.map {|x| x[0]}
end

# Takes a string that is a comma delineated list of names, and returns
# an array with all of the names from the input that are formatted correctly
# Names must start with a capital letter, have all other letters be lowercase,
# and include no extraneous characters.
# Ex: check_names("Damien,aDam,0Daniel,Jake,GREG") => ["Damien","Jake"]
def check_names(str)
    a = []

    str.split(",").each {|x|
        if x =~ /^[A-Z][a-z]*$/ then a << x end
    }

    a
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
# You MUST use a hash.
def reachable(graph, v1, v2)
    hash = Hash.new {|h,k| h[k] = Array.new }

    graph.each {|x|
        hash[x[0]] << x[1]
    }

    visited = []
    queue = []

    queue = hash[v1]

    while queue.size > 0 do
        v = queue.shift

        if v == v2 then return true end

        visited << v
        hash[v].each {|x|
            if !visited.include?(x) && !queue.include?(x) then
                queue << x
            end
        }
    end

    return false
end
