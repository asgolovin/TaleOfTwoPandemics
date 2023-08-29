using Agents

@enum EpidemicStatus S = 0 I = 1

@agent Agent GraphAgent begin
    knowledge::Dict # maps states and actions to payoffs
    strategy::Dict{String,Bool}
    status::EpidemicStatus
    previous_status::EpidemicStatus
    payoff::Float64
    time_until_recovery::Int64
end

