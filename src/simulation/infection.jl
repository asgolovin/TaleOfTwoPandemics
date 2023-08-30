"""
    update_infection_status!(agent, model)

Update the infection status of the agent according to the SIR model. 
"""
function update_infection_status!(agent, other, model)
    agent.time_until_state_change -= 1
    agent.previous_status = agent.status
    status = next_status(agent, other, model)
    agent.status = status

    if agent.status == I && agent.previous_status == S
        agent.time_until_state_change = model.sickness_time
    elseif agent.status == R && agent.previous_status == I
        agent.time_until_state_change = model.immunity_time
    elseif agent.status == S && agent.previous_status == R
        agent.time_until_state_change = Inf
    end

    return agent
end

function next_status(agent, other, model)
    if agent.status == S
        if other.status != I
            return S
        end
        infection_chance = get_infection_chance(agent, other, model)
        if rand() < infection_chance
            return I
        end
        return S
    elseif agent.status == I
        if agent.time_until_state_change > 0
            return I
        end
        return R
    elseif agent.status == R
        if agent.time_until_state_change > 0
            return R
        end
        return S
    end
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