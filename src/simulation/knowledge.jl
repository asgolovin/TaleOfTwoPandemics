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
  influence_strength = 0.3
  repulsion_threshold = 10000 # no repulsion
  total_diff = 0 
  
  for (state, action_space) in agent.knowledge
    other_action_space = other.knowledge[state]
    total_diff += sum(abs(action_space[a] - other_action_space[a]) for a in keys(action_space))
  end

  # Apply opinion dynamics using SJT rules based on the total difference
  if total_diff < t
    for (state, action_space) in agent.knowledge
      other_action_space = other.knowledge[state]
      for (action, value) in agent.knowledge[state]
        other_value = other_action_space[action]
        diff = abs(value - other_value)
        if diff < repulsion_threshold
          agent.knowledge[state][action] += (influence_strength * (other_value - value))
          other.knowledge[state][action] += (influence_strength * (value - other_value))
        end
      end
    end
  end
  return agent, other
end