function update_knowledge!(agent, model)
  # we evaluate how we are doing based on: previous status, current status and chosen strategies 
  rl_learn_factor = 0.3

  if agent.status == I && agent.previous_status == S
    # we punsih all actions that were true (multiply with less than 1)
    modifier = 1 - rl_learn_factor

  elseif agent.status == S
    # we reward all actions that were true (multiply with more than one)
    modifier = 1 + rl_learn_factor
  else
    modifier = 1 # we learn nothing while sick?
  end

  for (key, value) in agent.strategy
    if value == true
      cost_modifier = 1 - model.action_costs[key]
      new_q_value = max(0, agent.knowledge[agent.status][key] * modifier * cost_modifier)
      agent.knowledge[agent.status][key] = min(new_q_value, 1)
    end
  end

  return agent
end

function propagate_knowledge!(agent, other, model)
  influence_strength = 0.3
  repulsion_threshold = 10000 # no repulsion
  minimum_difference = 0.3
  total_diff = 0

  for (state, action_space) in agent.knowledge
    other_action_space = other.knowledge[state]
    total_diff += sum(abs(action_space[a] - other_action_space[a]) for a in keys(action_space))
  end

  # Apply opinion dynamics using SJT rules based on the total difference
  if total_diff < t && total_diff > minimum_difference
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
  elseif total_diff > t
    for (state, action_space) in agent.knowledge
      other_action_space = other.knowledge[state]
      for (action, value) in agent.knowledge[state]
        other_value = other_action_space[action]
        diff = abs(value - other_value)
        if diff < repulsion_threshold
          agent.knowledge[state][action] += (influence_strength * (value - other_value))
          other.knowledge[state][action] += (influence_strength * (other_value - value))
        end
      end
    end
  end
  return agent, other
end