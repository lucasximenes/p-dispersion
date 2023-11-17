function solveExact(instance::PDInstance)::Tuple{Float64, Bool}

    distances = [(instance.mat[i,j], i, j) for i in 1:instance.N, j in 1:instance.N if i < j]

    sort!(distances, by=x->x[1])

    lo = instance.P - 1
    hi = length(distances) - instance.P - 1

    lb = 0.0
    ub = Inf

    initTime = time()
    while lo < hi && time() - initTime < 120

        println("Time elapsed: $(time() - initTime) seconds")
        mid = lo + (hi - lo + 1) ÷ 2

        if setPacking(distances[1:mid], instance.N, instance.P)
            println("Lower bound: $(distances[mid][1])")
            lb = distances[mid][1]
            lo = mid
        else
            println("Upper bound: $(distances[mid][1])")
            ub = distances[mid][1]
            hi = mid - 1
        end
    end

    if time() - initTime > 120
        println("Time elapsed: $(time() - initTime) seconds")
        println("Lower bound: $lb")
        println("Upper bound: $ub")
        return lb, false
    end


    aux = setPacking(distances[1:lo], instance.N, instance.P, true)

    if aux != false
        ps = [i for i in 1:instance.N if abs(aux[i] - 1.0) < 1e-4]
        cost = minimum(instance.mat[i, j] for i in ps for j in ps if i < j)

        return cost, true
    else
        return lb, false
    end

end


function setPacking(indices, N, P, final = false)
    m = Model(Gurobi.Optimizer)
    set_silent(m)
    set_time_limit_sec(m, 120)
    @variable(m, x[1:N], Bin)
    @constraint(m, sum(x) == P)
    @constraint(m, [i = 1:length(indices)], x[indices[i][2]] + x[indices[i][3]] <= 1)
    optimize!(m)

    if termination_status(m) == MOI.OPTIMAL
        return final ? value.(x) : true 
    else
        return false
    end
end