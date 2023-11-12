struct PDInstance <: AbstractInstance
    mat::Matrix{Float64}
    N::Int64
    P::Int64
end
mutable struct Solution
    chosen::Vector{Int64}
    cost::Float64
end

function readInstance(filename::String)
    f = open(filename)
    data = readline(f)
    n, p = parse.(Int64, split(data, " "))
    mat = zeros(n, n)
    for line in eachline(f)
        data = split(line, " ")
        if length(data) == 2
            break
        end
        i, j, d = parse(Int64, data[1]) + 1, parse(Int64, data[2]) + 1, parse(Float64, data[3])
        mat[i, j] = d
        mat[j, i] = d
    end
    close(f)
    return PDInstance(mat, n, p)
end

function readPalubeckisInstance(filename::String)
end

function evaluate(instance::PDInstance, chosen::Vector{Int64})
    return minimum(instance.mat[comb...] for comb in combinations(chosen, 2))
end