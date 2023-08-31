function update_knowledge!(agent, other, model)
  r = model.r

  ΔQsocial = social_update(agent, other, model)
  ΔQlearn = learning_update(agent, model)

  for practice in model.practices
    ΔQ = r * ΔQsocial[practice] + (1 - r) * ΔQlearn[practice]
    agent.knowledge[practice] += ΔQ
    agent.knowledge[practice] = min(max(agent.knowledge[practice], 0), 1)
  end

  return agent
end

"""

The update to the q-values based on the communication between two agents
"""
function social_update(agent, other, model)
  ΔQsocial = Dict(practice => 0.0 for practice in model.practices)
  Qagent = agent.knowledge
  Qother = other.knowledge

  # check if the agents are similar enough to each other
  dist = distance(agent, other)

  threshold = model.similarity_threshold
  if dist > threshold
    return ΔQsocial
  end

  # if they are similar enough, update the opinion of agent based on the opinion of the 
  # other
  β = model.β
  Δpayoff = other.payoff - agent.payoff

  # weight the opinion of the other agent depending on the Δpayoff
  weight = fermi(Δpayoff, β, 0)

  for practice in model.practices
    ΔQsocial[practice] = weight * (Qother[practice] - Qagent[practice])
  end

  return ΔQsocial
end

function learning_update(agent, model)
  ΔQlearn = Dict(practice => 0.0 for practice in model.practices)
  return ΔQlearn
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

function fermi(x, β, mean)
  return 1 - 1 / (exp(β * (x - mean)) + 1)
end