using CSV, DataFrames

include("BRKGA.jl")

function executeTests()
    nSeeds = 5
    nConfs = 4
    nParams = 4
    nPopulations = 4
    pops = [0.1 0.3 0.7 1]
    eliteMut = [
        0.15 0.15
        0.15 0.3
        0.3 0.15
        0.3 0.3
    ]
    confs = zeros(Float64, nSeeds * nConfs * nPopulations, nParams)

    line = 1
    for i in 1:nSeeds
        for j in 1:nConfs
            for k in 1:nPopulations
                confs[line, :] = [i, pops[k], eliteMut[j, 1], eliteMut[j, 2]]
                line += 1
            end
        end
    end

    df = DataFrame(Instance=String[], Result=Float64[], Time=Float64[], Config=Int64[])
    for file in readdir("Instances/test/")
        println("====================================")
        println("|| Executing $file ||")
        println("====================================")
        instance = readInstance("Instances/test/$file")
        for i in axes(confs, 1)
            val, time = main("Instances/test/$file", convert(Int64, confs[i, 1]), max(ceil(Int64, instance.N * confs[i, 2]), 50), confs[i, 3], confs[i, 4], instance)
            push!(df, [file, val, time, i])
        end
    end
    CSV.write("resultsBRKGA.csv", df)
end

executeTests()