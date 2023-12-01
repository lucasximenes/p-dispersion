include("../BRKGA.jl")
params = [ARGS[4], ARGS[5], ARGS[6], ARGS[7], ARGS[8]]
res = runBRKGA(params)
command = `echo $res`
run(command)


