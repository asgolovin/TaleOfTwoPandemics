using Random
using SimpleGraphs
export initialize_model

"""
    initialize_model(; kwargs)

Create the model from keyword arguments (`kwargs`). 
"""
function initialize_model(; num_agents=100)
    model = ABM(Agent, ContinuousSpace((100, 100)); properties=Dict(:graph => SimpleGraph(num_agents)))

    # create agents

    agents = []
    for i in 1:num_agents
        new_agent = Agent(i, (0.0, 0.0), (0.0, 0.0), Dict(), Dict{Int64,Float64}(), S, 0.0, 0)
        add_agent!(new_agent, model)
        push!(agents, new_agent)
    end

    # initialize graph
    # create connections between agents
    for person in agents
        n_contacts = rand(1:10)
        for i in (1:n_contacts)
            contact = rand(model.agents)
            add_edge!(model.graph, person, contact)
        end
    end

  

    # initialize q-tables
    # infect agents


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
    other = rand(get_edges(model.graph, agent))

    return other
end