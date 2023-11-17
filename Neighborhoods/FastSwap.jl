mutable struct FastSwap
    instance::PDInstance
    sol::Solution
end

function eval(fastSwap::FastSwap)::Vector{Int64}
    worstPair = [0, 0]
    cost = -1.0
    for comb in combinations(fastSwap.sol.chosen, 2)
        if (current_cost = fastSwap.instance.mat[comb...]) > cost
            cost = current_cost
            worstPair = comb
        end
    end
    return worstPair
end

function move!(fastSwap::FastSwap, i::Int64, j::Int64, cost::Float64)
    fastSwap.sol.chosen[i] = j
    diff = minimum(fastSwap.instance.mat[comb...] for comb in combinations(fastSwap.sol.chosen, 2)) - cost
    fastSwap.sol.cost += diff
end

function firstImprovement!(fastSwap::FastSwap)
    worstPair = eval(fastSwap)
    firstIndex = findfirst(x -> x == worstPair[1], fastSwap.sol.chosen)
    i = 1
    while i == firstIndex || fastSwap.instance.PreProcessing[worstPair[1], i] in fastSwap.sol.chosen
        i += 1
    end
    move!(fastSwap, firstIndex, fastSwap.instance.PreProcessing[worstPair[1], i], fastSwap.sol.cost)
end