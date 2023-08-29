using Random
using Graphs
using StatsBase

export initialize_model

"""
    initialize_model(; kwargs)

Create the model from keyword arguments (`kwargs`). 
"""
function initialize_model(params::InputParams)
    nparams = params.network_params
    mparams = params.model_params

    num_agents = nparams.num_agents
    graph_generator = nparams.graph_generator
    graph_args = nparams.graph_args

    infection_chance = mparams.infection_chance
    r = mparams.r
    action_space = mparams.action_space

    # initialize the graph
    graph = graph_generator(graph_args...)

    space = GraphSpace(graph)

    properties = Dict(
        :num_agents => num_agents,
        :action_space => action_space,
        :r => r,
        :infection_chance => infection_chance,
    )

    model = ABM(Agent, space; properties)

    # create agents
    agents = []
    for i in 1:num_agents
        new_agent = Agent(i, i, Dict(), Dict(), S, S, 0.0, 0)

        # initialize q-tables
        new_agent.knowledge = Dict()
        new_agent.knowledge[S] = Dict()
        new_agent.knowledge[I] = Dict()
        new_agent.knowledge[R] = Dict()
        for action in keys(model.action_space)
            new_agent.knowledge[S][action] = rand()
            new_agent.knowledge[I][action] = rand()
            new_agent.knowledge[R][action] = new_agent.knowledge[S][action]
        end
        add_agent!(new_agent, i, model)
        push!(agents, new_agent)
    end

    # infect agents
    for i in (1:num_agents)
        if rand() < infection_chance
            infect_single_agent!(model.agents[i], model)
        end
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
    #propagate_knowledge!(agent, other, model)

    # infection propagation
    propagate_infection!(agent, other, model)

    return agent
end

"""
    choose_contact(agent, model)

Select the other agent from the network with whom the interaction (opinion exchange and infection) takes place. 
"""
function choose_contact(agent, model)
    neighborlist = neighbors(model.space.graph, agent.id)
    random_neighbor_index = rand(1:length(neighborlist))
    contact = neighborlist[random_neighbor_index]
    return model.agents[contact]
end