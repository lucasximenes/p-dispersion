using Random, Gurobi, JuMP, StatsBase, LinearAlgebra, Combinatorics, CSV, DataFrames

include("Instance.jl")
include("Model.jl")
include("Exact.jl")
include("Neighborhoods/Swap.jl")
include("Utils.jl")
include("Heuristics.jl")

function main()
    instance = readInstance("Instances/test/MDG-c_2_n3000_m300.txt")
    @time @show sol = semiGreedyDeletion(instance)
    return
end

function executeTests()
    df = DataFrame(Instance=String[], Result=Float64[], Time=Float64[], Exact=Bool[])
    for file in readdir("Instances/test/")
        println("====================================")
        println("|| Executing $file ||")
        println("====================================")
        instance = readInstance("Instances/test/$file")
        time = @elapsed val, exact = solveExact(instance)
        push!(df, [file, val, time, exact])
    end
    CSV.write("resultsExact.csv", df)
end

executeTests()