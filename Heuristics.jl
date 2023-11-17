function semiGreedyDeletion(instance::PDInstance)
    vet = [(i, j, instance.mat[i, j]) for i in 1:instance.N for j in i + 1:instance.N]
    sort!(vet, by = x -> x[3])
    chosen = collect(1:instance.N)
    corr = 1
    cost = 0
    while length(chosen) > instance.P
        i, j, cost = vet[corr]
        if i in chosen && j in chosen
            rand() < 0.5 ? deleteat!(chosen, findfirst(isequal(i), chosen)) : deleteat!(chosen, findfirst(isequal(j), chosen))
        end
        corr += 1
    end

    cost = evaluate(instance, chosen)
    return Solution(chosen, cost)
end