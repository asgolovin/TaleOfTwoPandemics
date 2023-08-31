using TaleOfTwoPandemics
using Sobol
using Agents
using Statistics
using LinearAlgebra

input_file = "../input/default.jl"

include(input_file)
trials = 150
steps = 400

s = SobolSeq(8)
param_names = ["infection_chance","sickness_time","spontaneous_infection_chance",
"immunity_time", "r", "β",
"similarity_threshold", "action_threshold"]
param_ranges = Dict()

for name in param_names
    param_ranges[name] = []
end

goal_points = [20, 40, 30, 60, 80, 40, 20, 10, 40, 20, 15]
time_points = range(start = 1, stop = steps, length= length(goal_points))
time_points = Int.(round.(collect(time_points)))
print(time_points)

# todo: make number of points variable!
results = Dict()
for combo in (0:trials)
    results[combo] = Dict()
    x = next!(s)
    i = 1
    for name in param_names
        if name == "immunity_time" || name == "sickness_time"
            val = Int(round(10 * x[i]))
        elseif name == "spontaneous_infection_chance"
            val = x[i] * 0.1
        else 
            val = x[i]
        end
        results[combo][name] = val
        setproperty!(params.model_params, Symbol(name), val)
        i += 1
    end
    results[combo]["n_infected"] = []
    my_model = initialize_model(params)
    for i in (1:steps)
        step!(my_model, TaleOfTwoPandemics.agent_step!)
        if in(i, time_points)
            n_infected = 0
            for (id, p) in my_model.agents
              n_infected += TaleOfTwoPandemics.get_status(p, my_model)
            end
            push!(results[combo]["n_infected"], n_infected )
        end        
    end
    println("performed experiment ", combo, " of ", trials )
end

result_evaluated = Dict()
best_index = 0
global best_diff = 10000000000
for (entry, data) in results
    list = data["n_infected"] - goal_points
    res2 = norm(data["n_infected"] - goal_points)
    res = abs(median(list))

    if  <=(res, best_diff)
        global best_diff = res
        global best_index = entry
    end
    result_evaluated[entry] = [res, list]
end

println(best_index)
println(best_diff)
println(results[best_index])