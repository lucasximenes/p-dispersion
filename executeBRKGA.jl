using CSV, DataFrames

include("BRKGA.jl")

## seed 5 0.15 0.3

function executeTests()
    nSeeds = 5
    nConfs = 4
    nParams = 3
    eliteMut = [
        0.15 0.15
        0.15 0.3
        0.3 0.15
        0.3 0.3
    ]
    confs = zeros(Float64, nSeeds * nConfs, nParams)

    line = 1
    for i in 1:nSeeds
        for j in 1:nConfs
            confs[line, :] = [i, eliteMut[j, 1], eliteMut[j, 2]]
            line += 1
        end
    end

    df = DataFrame(Instance=String[], Result=Float64[], Time=Float64[], Config=Int64[])
    for file in readdir("Instances/fit/")
        println("====================================")
        println("|| Executing $file ||")
        println("====================================")
        instance = readInstance("Instances/fit/$file")
        for i in axes(confs, 1)
            val, time = main("Instances/fit/$file", convert(Int64, confs[i, 1]), 50, confs[i, 2], confs[i, 3], instance)
            push!(df, [file, val, time, i])
        end
    end
    CSV.write("resultsBRKGA.csv", df)
end

function obtainBest()
    df = DataFrame(Instance=String[], Result=Float64[], Time=Float64[], LS=Bool[])
    for file in readdir("Instances/test/")
        println("====================================")
        println("|| Executing $file ||")
        println("====================================")
        instance = readInstance("Instances/test/$file")
        for type in [true, false]
            val, time = main("Instances/test/$file", 5, 50, 0.15, 0.3, instance, type)
            push!(df, [file, val, time, type])
        end
    end
    CSV.write("resultsBRKGAfinal.csv", df)
end

obtainBest()