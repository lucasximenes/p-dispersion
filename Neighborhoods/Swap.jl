mutable struct Swap
    instance::PDInstance
    sol::Solution
end

#=
i is the index of the center that will be swapped
j is the point that will be swapped with the center
=#
function eval(swap::Swap, i::Int64, j::Int64)::Float64
    if swap.sol.chosen[i] == j
        return 0.0
    end
    previous_p = swap.sol.chosen[i]
    swap.sol.chosen[i] = j
    current_cost = swap.sol.cost
    res = current_cost - minimum(swap.instance.mat[comb...] for comb in combinations(swap.sol.chosen, 2))
    swap.sol.chosen[i] = previous_p
    return res
end

function move!(swap::Swap, i::Int64, j::Int64)
    swap.sol.chosen[i] = j
end

function firstImprovement!(swap::Swap)
    for i in 1:swap.instance.P
        for j in 1:swap.instance.N
            if eval(swap, i, j) < 0.0
                move!(swap, i, j)
                firstImprovement!(swap)
                return
            end
        end
    end
end
