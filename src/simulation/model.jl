using Random
using Graphs

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
    sickness_time = mparams.sickness_time
    immunity_time = mparams.immunity_time
    r = mparams.r
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
        :r => r,
        :infection_chance => infection_chance,
        :sickness_time => sickness_time,
        :immunity_time => immunity_time,
    )

    model = ABM(Agent, space; properties)

    # create agents
    agents = []
    for i in 1:num_agents
        knowledge = Dict(practice => rand() for practice in practices)
        strategy = Dict(practice => knowledge[practice] > 0.5 for practice in practices)
        payoff = 1 + sum([cost[practice] * strategy[practice] for practice in practices])

        new_agent = Agent(i, i, knowledge, strategy, payoff, S, S, Inf64)
        add_agent!(new_agent, i, model)
        push!(agents, new_agent)
    end

    # infect agents
    for (_, agent) in model.agents
        if rand() < infection_chance
            agent.status = I
            agent.time_until_state_change = model.sickness_time
            agent.payoff -= 1
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
    #update_knowledge!(agent, other, model)

    # update behavior
    #update_strategy!(agent, model)

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