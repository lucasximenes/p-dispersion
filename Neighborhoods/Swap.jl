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
    res = minimum(swap.instance.mat[comb...] for comb in combinations(swap.sol.chosen, 2)) - current_cost
    swap.sol.chosen[i] = previous_p
    return res
end

function move!(swap::Swap, i::Int64, j::Int64, diff::Float64)
    swap.sol.chosen[i] = j
    swap.sol.cost += diff
end

function firstImprovement!(swap::Swap)
    for i in 1:swap.instance.P
        for j in 1:swap.instance.N
            if (diff = eval(swap, i, j)) > 0.0
                move!(swap, i, j, diff)
                return
            end
        end
    end
end

function bestImprovement!(swap::Swap)
    best_diff = 0.0
    best_move = (0, 0)
    for i in 1:swap.instance.P
        for j in 1:swap.instance.N
            if (diff = eval(swap, i, j)) < best_diff
                best_diff = diff
                best_move = (i, j)
            end
        end
    end
    move!(swap, best_move[1], best_move[2], best_diff)
    return
end