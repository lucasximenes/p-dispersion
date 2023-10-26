struct PDInstance #<: AbstractInstance
    mat::Matrix{Float64}
    candidates::Vector{Int64}
    N::Int64
    P::Int64
end
mutable struct Solution
    chosen::Vector{Int64}
    cost::Float64
end

function generateKubyInstance(n::Int64)
    mat = zeros(n,n)
    for i in 1:n
        for j in 1:n
            if i == j
                mat[i,j] = 0
            elseif i < j
                mat[i,j] = rand()
            else
                mat[i,j] = mat[j,i]
            end
        end
    end
    p = floor(Int64, 0.3 * n)
    # candidates = sample(1:n, p, replace=false)
    candidates = collect(1:n)
    return PDInstance(mat, candidates, n, p)
end

function generateErkutInstance(n::Int64)
    ## generate 100 points in r^2 in 100x100 square
    points = rand(2, n) * 100
    ## calculate distance matrix between points
    mat = zeros(n, n)
    for i in 1:n
        for j in 1:n
            mat[i,j] = norm(points[:,i] - points[:,j])
        end
    end
    p = floor(Int64, 0.3 * n)
    # candidates = sample(1:n, p, replace=false)
    candidates = collect(1:n)
    return PDInstance(mat, candidates, n, p)
end
