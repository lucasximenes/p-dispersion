using Random, Gurobi, JuMP, StatsBase, MathOptInterface, LinearAlgebra

include("Instance.jl")
include("Model.jl")
include("Exact.jl")

function main()
    Random.seed!(19)
    # instance = generateKubyInstance(150)
    instance = generateErkutInstance(700)
    # @show instance
    # println(solveModel(instance))
    @time solveExact(instance)
    # return sol
    return
end

main()