using Random, Gurobi, JuMP, StatsBase, LinearAlgebra, Combinatorics

include("Instance.jl")
include("Model.jl")
include("Exact.jl")
include("Neighborhoods/Swap.jl")
include("Utils.jl")
include("Heuristics.jl")

function main()
    instance = readInstance("Instances/MDG-a/MDG-a_10_100_m10.txt")
    sol = semiGreedyDeletion(instance)
    @show sol
    println(evaluate(instance, sol.chosen))
    @time @show sol = solveExact(instance)
    println(evaluate(instance, sol.chosen))
    return
end

main()