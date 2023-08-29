using Random
using SimpleGraphs
export initialize_model

"""
    initialize_model(; kwargs)

Create the model from keyword arguments (`kwargs`). 
"""
function initialize_model(; num_agents=100)
    model = ABM(Agent, ContinuousSpace((100, 100)); properties=Dict(:graph => SimpleGraph(num_agents),:action_space => Dict()))

    #  initialize actions and objective usefulness 
    model.action_space["Garlic"] = 0.2
    model.action_space["Isolation"] = 0.9
    model.action_space["Praying"] = 0.0
    model.action_space["Blood Transfusion"] = -0.3
    model.action_space["Washing Hands"] = 0.7

    # create agents
    agents = []
    for i in 1:num_agents
        new_agent = Agent(i, (0.0, 0.0), (0.0, 0.0), Dict(), Dict(), S, S, 0.0, 0)
        
         # initialize q-tables
         new_agent.knowledge = Dict()
         new_agent.knowledge[S] = Dict()
         new_agent.knowledge[I] = Dict()
         for action in keys(model.action_space)
             new_agent.knowledge[S][action] = rand()
             new_agent.knowledge[I][action] = rand()
         end

        add_agent!(new_agent, model)
        push!(agents, new_agent)
    end

    for person in agents
        # initialize graph
        # create connections between agents
        n_contacts = rand(1:10)
        for i in (1:n_contacts)
            contact = rand(agents)
            add_edge!(model.graph, (person.id, contact.id))
        end
    end

    # infect agents
    n_infected = max(1, 0.1*num_agents)
    for i in (1:n_infected)
        infect_single_agent!(model.agents[rand(1:num_agents)], model)
    end
    return model
end

"""
    agent_step!(agent, model)

Evolve the agent one step in time.
"""
function agent_step!(agent, model)
    # do any health updates which depend on time
    update_health!(agent, model)

    # update the percieved value of policies
    update_evaluation!(agent, model)

    # update behavior
    update_strategy!(agent, model)

    # knowledge propagation
    # choose other agent
    other = choose_contact(agent, model)
    propagate_knowledge!(agent, other, model)

    # infection propagation
    propagate_infection!(agent, other, model)

    return agent
end

"""
    choose_contact(agent, model)

Select the other agent from the network with whom the interaction (opinion exchange and infection) takes place. 
"""
function choose_contact(agent, model)
    other = rand(1:model.num_agents)
    return model.agents[other]
    
end