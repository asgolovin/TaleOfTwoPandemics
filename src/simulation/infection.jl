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
    threshold = 0.7
    agent.strategy = Dict()
    for action in keys(model.action_space)
        agent.strategy[action] = false
        if agent.knowledge[agent.status][action] >= threshold
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
        if rand() >= infection_chance
            infect_single_agent!(other, model)
        end
    end
    if other.status == I && agent.status == S #agent2 is infected 
        if rand() >= infection_chance # wert wird durch strategies modifiziert
            infect_single_agent!(agent, model)
        end
    end
    return agent, other
end

function get_infection_chance(agent, other, model)
   return 0.2
end

function infect_single_agent!(agent, model)
    agent.status = I
    agent.previous_status = S
    agent.time_until_state_change = rand(1:10) 
    return agent
end

function recover_single_agent!(agent, model)
    agent.status = R
    agent.previous_status = I
    agent.time_until_state_change = rand(1:15)
    return agent
end

function end_recovery_immunity!(agent, model)
    agent.status = S
    agent.previous_status = R
    agent.time_until_state_change = 0
    return agent
end