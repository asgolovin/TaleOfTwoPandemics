using Random
using SimpleGraphs
export initialize_model

"""
    initialize_model(; kwargs)

Create the model from keyword arguments (`kwargs`). 
"""
function initialize_model(; num_agents=100)
    model = ABM(Agent, graph)

    # create agents
    # initialize q-tables
    # infect agents
    agents = []
    for i in range num_agents
        new_agent = Agent(i, model)
        add_agent!(new_agent, model)
        agents.append(new_agent)
    end

    # initialize graph
    # create connections between agents
    graph = UndirectedGraph()

    model = nothing
    model = ABM(Agent, graph)

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
    other = nothing

    return other
end