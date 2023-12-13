struct PDInstance #<: AbstractInstance
    mat::Matrix{Float64}
    N::Int64
    P::Int64
    PreProcessing::Matrix{Int64}
end
mutable struct Solution
    chosen::Vector{Int64}
    cost::Float64
end

function readInstance(filename::String)
    f = open(filename)
    data = readline(f)
    firstLine = split(data, " ")
    if length(firstLine) == 1
        n = parse(Int64, firstLine[1])
        p = ceil(Int64, n / 10)
    else
        n, p = parse.(Int64, firstLine)
    end
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

    preProcess = zeros(Int64, n, p)
    ## fill preProcess with the p closest points to each point
    for i in 1:n
        preProcess[i, :] = sortperm(mat[i, :], rev=true)[1:p]
    end

    return PDInstance(mat, n, p, preProcess)
end

function readPalubeckisInstance(filename::String)
end

function evaluate(instance::PDInstance, chosen::Vector{Int64})
    return minimum(instance.mat[comb...] for comb in combinations(chosen, 2))
end