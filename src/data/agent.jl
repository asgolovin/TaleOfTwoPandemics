using Agents

@enum EpidemicStatus S = 0 I = 1 R = 2

@agent Agent GraphAgent begin
    # Maps the practices to the percieved effectiveness
    knowledge::Dict{String,Float64}
    # Maps the practices to true if the practice is active
    strategy::Dict{String,Bool}
    payoff::Float64
    status::EpidemicStatus
    previous_status::EpidemicStatus
    time_until_state_change::Float64
end