"""
    update_health!(agent, model)

Update any health parameters which do not depend on other agents.

(if the agent was infected, it becomes healthy again)
"""
function update_health!(agent, model)
    if agent.status == 1
        if agent.time_until_recovery > 1
            agent.time_until_recovery -= 1
        else
            agent.time_until_recovery = 0
            agent.status = 0
        end
    end
    return agent
    end
end

"""
    update_strategy!(agent, model)

Change the percieved effectiveness of polices.
"""
function update_strategy!(agent, model)

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
            other.status = I
            other.time_until_recovery = 8
        end
    end
    if other.status == I && agent.status == S #agent2 is infected 
        if rand() >= infection_chance # wert wird durch strategies modifiziert
            agent.status = I
            agent.time_until_recovery = 8
        end
    end
    return agent, other
end

function get_infection_chance(agent, other, model)
   return 0.3
end

function infect_single_agent!(agent, model)
    agent.status = I
    agent.days_until_recovery = 8 
    return agent
end