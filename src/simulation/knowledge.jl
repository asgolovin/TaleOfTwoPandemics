function update_knowledge!(agent, other, model)
  r = model.r

  ΔQsocial = social_update(agent, other, model)
  ΔQlearn = learning_update(agent, model)

  for practice in model.practices
    ΔQ = r * ΔQsocial[practice] + (1 - r) * ΔQlearn[practice]
    agent.knowledge[practice] += ΔQ
    # analytische funktion
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
  Δpayoff = payoff(other, model) - payoff(agent, model)

  # weight the opinion of the other agent depending on the Δpayoff
  weight = fermi(Δpayoff, β, 0)

  for practice in model.practices
    ΔQsocial[practice] = weight * (Qother[practice] - Qagent[practice])
  end

  return ΔQsocial
end

function learning_update(agent, model)
  ΔQlearn = Dict(practice => 0.0 for practice in model.practices)
  direction = sign(payoff(agent, model))
  Qagent = agent.knowledge

  for practice in model.practices
    isactive = agent.strategy[practice] ? 1.0 : 0.0
    ΔQlearn[practice] = direction * isactive * (1 - Qagent[practice]) * 0.5
  end
  return ΔQlearn
end

function fermi(x, β, mean)
  return 1 - 1 / (exp(β * (x - mean)) + 1)
end