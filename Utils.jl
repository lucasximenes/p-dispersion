function decoder(vet::Vector{Float64}, instance::PDInstance, rewrite::Bool=false, LS::Bool=false)::Union{Float64, Solution}
    sorted_indices = sortperm(vet)
    cost = minimum(instance.mat[comb...] for comb in combinations(sorted_indices[1:instance.P], 2))
    return LS ? Solution(sorted_indices[1:instance.P], cost) : cost
end

function buildChromosome(instance::PDInstance, sol::Solution)::Vector{Float64}
    vet = rand(instance.N)
    for p in sol.chosen
        vet[p] = 0.0
    end
    return vet
end
