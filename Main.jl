using Random, Gurobi, JuMP, StatsBase

include("Instance.jl")
include("Model.jl")

function main()
    instance = generateKubyInstance(100)
    @show instance
    sol = solve(instance)
    return sol
end

main()