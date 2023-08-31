using Random
using Graphs
using DrWatson

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
    practices = mparams.practices
    q_true = mparams.q_true
    cost = mparams.cost

    # initialize the graph
    graph = graph_generator(graph_args...)
    space = GraphSpace(graph)

    properties = Dict(
        :num_agents => num_agents,
        :practices => practices,
        :q_true => q_true,
        :cost => cost,
        struct2dict(mparams)...,
    )

    model = ABM(Agent, space; properties)

    # create agents
    agents = []
    for i in 1:num_agents
        knowledge = Dict(practice => rand() for practice in practices)
        strategy = Dict(practice => false for practice in practices)
        new_agent = Agent(i, i, knowledge, strategy, S, S, Inf64)
        update_strategy!(new_agent, model)

        add_agent!(new_agent, i, model)
        push!(agents, new_agent)
    end

    # infect agents
    for (_, agent) in model.agents
        if rand() < infection_chance
            agent.status = I
            agent.time_until_state_change = model.sickness_time
        end
    end
    return model
end

"""
    agent_step!(agent, model)

Evolve the agent one step in time.
"""
function agent_step!(agent, model)
    # choose a neighboring agent
    other = choose_contact(agent, model)

    # infection propagation
    update_infection_status!(agent, other, model)

    # update the percieved value of policies
    update_knowledge!(agent, other, model)

    # update behavior
    update_strategy!(agent, model)

    return agent
end

"""
    choose_contact(agent, model)

Select the other agent from the network with whom the interaction (opinion exchange and infection) takes place. 
"""
function choose_contact(agent, model)
    neighborlist = neighbors(model.space.graph, agent.id)
    neighbor_index = rand(neighborlist)
    return model.agents[neighbor_index]
end

function payoff(agent, model)
    cost = model.cost
    practices = model.practices
    result = 1 + sum([cost[practice] * agent.strategy[practice] for practice in practices])

    # penalty for becomming sick in the previous round
    if agent.status == I
        result -= 2
    end

    return result
end