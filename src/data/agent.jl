using Agents

@enum EpidemicStatus S = 0 I = 1

@agent Agent NoSpaceAgent begin
    evaluation::Dict # maps states and actions to payoffs
    strategy::Dict{Int64,Float64}
    status::EpidemicStatus
    payoff::Float64
end

