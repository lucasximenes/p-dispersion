function test(ARGS)
    params = ARGS
    i = 1
    for param in params
        if param == "-i"
            break
        end
        i += 1
    end

    instance = params[i + 1]
    elite = params[i + 3]
    mutants = params[i + 5]
    pop = params[i + 7]

    println("Instance: $instance || elite: $elite || mutants: $mutants || pop: $pop")
end

test(ARGS)