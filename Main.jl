using Random, Gurobi, JuMP, StatsBase, LinearAlgebra, Combinatorics

include("Instance.jl")
include("Model.jl")
include("Exact.jl")
include("Neighborhoods/Swap.jl")
include("Utils.jl")

function main()
    Random.seed!(10)
    instance = generateErkutInstance(200)
    # @show instance
    # sol = decoder(rand(instance.N), instance, false, true)
    # @show sol
    # swap = Swap(instance, sol)
    # firstImprovement!(swap)
    # @show swap.sol
    # @time solveModel(instance)
    @time @show solveExact(instance)
    # return sol
    return
end

main()