"""
    update_health!(agent, model)

Update any health parameters which do not depend on other agents.

(if the agent was infected, it becomes healthy again)
"""
function update_health!(agent, model)

    return agent
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

    return agent, other
end