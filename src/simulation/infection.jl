"""
    update_health!(agent, model)

Update any health parameters which do not depend on other agents.

(if the agent was infected, it becomes healthy again)
"""
function update_health!(agent, model)
    if agent.status == I
        if agent.time_until_recovery > 1
            agent.time_until_recovery -= 1
        else
            agent.time_until_recovery = 0
            agent.status = S
            agent.previous_status = I
        end
    end
    return agent
end

"""
    update_strategy!(agent, model)

Change the percieved effectiveness of polices.
"""
function update_strategy!(agent, model)
    threshold = 0.6
    epsilon = 0.8
    agent.strategy = Dict()
    for action in keys(model.action_space)
        agent.strategy[action] = false
        if agent.knowledge[agent.status][action] >= threshold || rand() >= epsilon
            agent.strategy[action] = true
        end
    end

    return agent
end

"""
    propagate_infection!(agent, other, model)

Propagate the infection between agent and other. 
"""
function propagate_infection!(agent, other, model)
    infection_chance = get_infection_chance(agent, other, model)
    if agent.status == I && other.status == S #Agent1 is infected 
        if rand() < infection_chance
            infect_single_agent!(other, model)
        end
    end
    if other.status == I && agent.status == S #agent2 is infected 
        if rand() < infection_chance # wert wird durch strategies modifiziert
            infect_single_agent!(agent, model)
        end
    end
    return agent, other
end

function get_infection_chance(agent, other, model)
    agent1_modifier = 1
    agent2_modifier = 1

    for (action, effectiveness) in model.action_space
        if agent.strategy[action]
            agent1_modifier -= effectiveness
        end 
        if other.strategy[action]
            agent2_modifier -= effectiveness
        end
    end
    agent1_modifier = max(agent1_modifier, 0)
    agent2_modifier = max(agent2_modifier, 0)
    return model.infection_chance * (agent1_modifier + agent2_modifier)
end

function infect_single_agent!(agent, model)
    agent.status = I
    agent.previous_status = S
    agent.time_until_recovery = 8
    return agent
end