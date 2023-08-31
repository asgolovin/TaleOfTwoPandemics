using Agents

@enum EpidemicStatus S = 0 I = 1 R = 2

@agent Agent GraphAgent begin
    # Maps the practices to the percieved effectiveness
    knowledge::Dict{String,Float64}
    # Maps the practices to true if the practice is active
    strategy::Dict{String,Bool}
    status::EpidemicStatus
    previous_status::EpidemicStatus
    time_until_state_change::Float64
end

function distance(agent, other)
    dist = 0.0
    for practice in keys(agent.knowledge)
        dist += (agent.knowledge[practice] - other.knowledge[practice])^2
    end
    return sqrt(dist)
end

function Base.show(io::IO, ::MIME"text/plain", agent::Agent)
    status = agent.status
    practices = collect(keys(agent.knowledge))
    id = agent.id
    println(io, "Agent #$id")
    println(io, "status: $(agent.status)")
    println(io, "policies:")
    for practice in practices
        isactive = agent.strategy[practice] ? "active" : "inactive"
        println(io, "  $practice => $(round(agent.knowledge[practice]; digits=2)) ($isactive)")
    end
end

function get_status(agent, model)
    if agent.status == I
        return 1
    else    
        return 0
    end
end