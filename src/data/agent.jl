using Agents

@enum EpidemicStatus S = 0 I = 1

@agent Agent ContinuousAgent{2} begin
    evaluation::Dict # maps states and actions to payoffs
    strategy::Dict{Int64,Float64}
    status::EpidemicStatus
    payoff::Float64
    time_until_recovery::Int64
end

