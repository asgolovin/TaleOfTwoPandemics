"""
    update_health!(agent, model)

Update any health parameters which do not depend on other agents.

(if the agent was infected, it becomes healthy again)
"""
function update_health!(agent, model)
    if agent.status == I
        if agent.time_until_state_change > 1
            agent.time_until_state_change -= 1
        else
            recover_single_agent!(agent, model)
        end
    elseif agent.status == R
        if agent.time_until_state_change > 1
            agent.time_until_state_change -= 1
        else
            end_recovery_immunity!(agent, model)
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
    for practice in model.practices
        agent.strategy[practice] = false
        if agent.knowledge[agent.status][practice] >= threshold || rand() >= epsilon
            agent.strategy[practice] = true
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

    for practice in model.practices
        effectiveness = model.q_true[practice]
        if agent.strategy[practice]
            agent1_modifier -= effectiveness
        end
        if other.strategy[practice]
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
    agent.time_until_state_change = model.sickness_time
    return agent
end

function recover_single_agent!(agent, model)
    agent.status = R
    agent.previous_status = I
    agent.time_until_state_change = model.immunity_time
    return agent
end

function end_recovery_immunity!(agent, model)
    agent.status = S
    agent.previous_status = R
    agent.time_until_state_change = 0
    return agent
end