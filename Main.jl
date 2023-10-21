using Random, Gurobi, JuMP, StatsBase

include("Instance.jl")
include("Model.jl")
include("Exact.jl")

function main()
    instance = generateKubyInstance(100)
    # @show instance
    # println(solveModel(instance))
    println(solveExact(instance))
    # return sol
    return
end

main()