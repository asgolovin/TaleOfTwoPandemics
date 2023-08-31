using TaleOfTwoPandemics
using Sobol
using Agents
using Statistics

input_file = "../input/default.jl"

include(input_file)
trials = 100
steps = 1000

s = SobolSeq(7)
param_names = ["infection_chance","sickness_time",
"immunity_time", "r", "β",
"similarity_threshold", "action_threshold"]
param_ranges = Dict()

for name in param_names
    param_ranges[name] = []
end

start_point = 2
middle_point = Int(round(steps/2))
end_point = steps - 2 

# todo: make number of points variable!
results = Dict()
for combo in (0:trials)
    results[combo] = Dict()
    x = next!(s)
    i = 1
    for name in param_names
        if name == "immunity_time" || name == "sickness_time"
            val = Int(round(10 * x[i]))
        else 
            val = x[i]
        end
        results[combo][name] = val
        setproperty!(params.model_params, Symbol(name), val)
        i += 1
    end
    results[combo]["n_infected"] = []
    my_model = initialize_model(params)
    print("Model initialized")
    for i in (1:steps)
        step!(my_model, TaleOfTwoPandemics.agent_step!)
        if i == start_point || i == middle_point || i == end_point
            n_infected = 0
            for (id, p) in my_model.agents
              n_infected += TaleOfTwoPandemics.get_status(p, my_model)
            end
            push!(results[combo]["n_infected"], n_infected )
        end        
    end
    print("performed one experiment")
end

target_start = 50
target_middle = 200
target_end = 70

result_evaluated = Dict()
best_index = 0
global best_diff = 10000000000
for (entry, data) in results
    p1 = abs(data["n_infected"][1] - target_start)
    p2 = abs(data["n_infected"][2] - target_middle)
    p3 = abs(data["n_infected"][3] - end_point)
    list = [p1, p2, p3]
    res = mean(list)
    if  <=(res, best_diff)
        global best_diff = res
        global best_index = entry
    end
    result_evaluated[entry] = [res, list]
end

print(best_index)
print(best_diff)
print(results[best_index])


    

 
