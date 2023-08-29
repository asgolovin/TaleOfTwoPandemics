function update_evaluation!(agent, model)
  # we evaluate how we are doing based on: previous status, current status and chosen strategies 

  if agent.status == I && agent.previous_status == S
    # we punsih all actions that were true (multiply with less than 1)
    modifier = 0.7


  elseif agent.status == S
    # we reward all actions that were true (multiply with more than one)
    modifier = 1.3
  else 
    modifier = 1 # we learn nothing while sick?
  end

  for (key, value) in agent.strategy
    if value == true
        agent.knowledge[agent.status][key] *= modifier  
    end
   end

    return agent
end

function propagate_knowledge!(agent, other, model)

    return agent, other
end