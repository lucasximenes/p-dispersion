using Random, Gurobi, JuMP, StatsBase, MathOptInterface

include("Instance.jl")
include("Model.jl")
include("Exact.jl")

function main()
    Random.seed!(19)
    instance = generateKubyInstance(10)
    # @show instance
    println(solveModel(instance))
    println(solveExact(instance))
    # return sol
    return
end

main()