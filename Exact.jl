mutable struct ExactSolver
    instance::PDInstance
    distances::Vector{Tuple{Float64, Int64, Int64}}
    model::Model
end

function init!(instance::PDInstance)::ExactSolver
    distances = [(instance.mat[i,j], i, j) for i in 1:instance.N, j in 1:instance.N if i < j]
    sort!(distances, by=x->x[1])

    m = Model(Gurobi.Optimizer)
    set_silent(m)
    @variable(m, x[1:instance.N], Bin)
    @constraint(m, sum(x) == instance.P)
    @constraint(m, [i = 1:instance.P - 2], x[distances[i][2]] + x[distances[i][3]] <= 1)

    return ExactSolver(instance, distances, m)
end

function solveExact(instance::PDInstance)::Solution

    es = init!(instance)

    lo = instance.P - 1
    hi = length(es.distances) - instance.P - 1

    c_lo = lo
    c_hi = hi

    remove_cons = false
    while lo < hi
        println("lo: ", lo, " hi: ", hi, " mid: ", lo + (hi - lo + 1) ÷ 2)
        mid = lo + (hi - lo + 1) ÷ 2
        
        if remove_cons
            adaptModel!(es, mid + 1:c_hi, false)
            remove_cons = false
        else
            adaptModel!(es, c_lo:mid, true)
        end
        
        if solve(es)
            lo = mid
            c_lo = mid + 1
        else
            remove_cons = true
            hi = mid - 1
            c_hi = mid
        end

    end

    if remove_cons
        adaptModel!(es, lo:c_hi, false)
    else
        adaptModel!(es, c_lo:lo, true)
    end

    aux = solve(es, true)

    if aux != false
        ps = [i for i in 1:instance.N if abs(aux[i] - 1.0) < 1e-4]
        cost = minimum(instance.mat[i, j] for i in ps for j in ps if i < j)

        return Solution(ps, cost)
    else
        return Solution([], 0.0)
    end

end

function adaptModel!(es::ExactSolver, indices::UnitRange{Int64}, add::Bool)
    if add
        println("Adicionando intervalo $indices")
        @constraint(es.model, [i = indices], es.model[:x][es.distances[i][2]] + es.model[:x][es.distances[i][3]] <= 1)
    else
        println("Removendo intervalo $indices")
        delete(es.model, all_constraints(es.model, AffExpr, MathOptInterface.LessThan{Float64})[indices])
    end
end

function solve(es::ExactSolver, final::Bool = false)
    optimize!(es.model)

    if termination_status(es.model) == MOI.OPTIMAL
        return final ? value.(es.model[:x]) : true 
    else
        return false
    end
end