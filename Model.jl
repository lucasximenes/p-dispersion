function solve(instance::PDInstance)
    p = instance.P
    C = length(instance.candidates)
    mat = instance.mat
    bigM = maximum(mat)
        
    m = Model(Gurobi.Optimizer)
    set_time_limit_sec(m, 30.0)

    @variable(m, x[1:C], Bin)
    @variable(m, d >= 0)

    @constraint(m, sum(x) == p)
    @constraint(m, [i = 1:C, j = 1:C ; i != j], d <= bigM*(2 - x[i] - x[j]) + mat[instance.candidates[i], instance.candidates[j]])

    @objective(m, Max, d)

    optimize!(m)

    chosen = findall(value.(x) .> 0.5)
    cost = objective_value(m)

    return Solution(chosen, cost)
end