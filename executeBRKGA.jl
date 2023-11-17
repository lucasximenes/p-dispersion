using CSV, DataFrames

include("BRKGA.jl")

function executeTests()
    df = DataFrame(Instance=String[], Result=Float64[], Time=Float64[])
    for file in readdir("Instances/test/")
        println("====================================")
        println("|| Executing $file ||")
        println("====================================")
        val, time = main("Instances/test/$file")
        push!(df, [file, val, time])
    end
    CSV.write("resultsBRKGA.csv", df)
end

executeTests()