using Parameters

export InputParams, NetworkParams, ModelParams

@with_kw mutable struct NetworkParams
    # Number of nodes in the graph
    num_agents::Union{Int64,Vector{Int64}}
    # A function which generates the graph
    # See https://juliagraphs.org/Graphs.jl/dev/core_functions/simplegraphs_generators/
    graph_generator::Function
    # arguments which will be passed to graph_generator
    graph_args::Tuple
end

@with_kw mutable struct ModelParams
    # Probability that a given node is infected
    infection_chance::Union{Float64,Vector{Float64}}
    # Probability that at least one node stochastically becomes infected during a time-step
    spontaneous_infection_chance::Union{Float64,Vector{Float64}}
    # The maximum magnitude of a stochastic update of the q-values
    stoch_update::Union{Float64,Vector{Float64}}
    # Time that an agent remains in the I state
    sickness_time::Union{Int64,Vector{Int64}}
    # Time that an agent remains in the R state
    immunity_time::Union{Int64,Vector{Int64}}
    # probability that an agent updates the q-values based on their own experience
    # TODO: rename
    r::Union{Float64,Vector{Float64}}
    # Parameter controlling by how much are we moving towards the other person,
    # even if the person has a lower payoff.
    β::Union{Float64,Vector{Float64}}
    # The minimum distance between two vectors of q-values that is needed for the 
    # agents to listen to each other.
    similarity_threshold::Union{Float64,Vector{Float64}}
    # Minimum value of the q-value for the practice to become active
    action_threshold::Union{Float64,Vector{Float64}}
    # practices and their objective effectiveness and cost
    action_space::Dict{String,NamedTuple{(:q_true, :cost),Tuple{Float64,Float64}}}
end

function Base.getproperty(obj::ModelParams, sym::Symbol)
    if sym === :practices
        return collect(keys(obj.action_space))
    elseif sym === :q_true
        practices = keys(obj.action_space)
        return Dict(key => obj.action_space[key].q_true for key in practices)
    elseif sym === :cost
        practices = keys(obj.action_space)
        return Dict(key => obj.action_space[key].cost for key in practices)
    else
        return getfield(obj, sym)
    end
end

"""
    InputParams

The parameters of the simulation. See the file ./simulation/InputParams.jl for the 
documentation of individual settings. Default values are provided for all settings. 
"""
@with_kw struct InputParams
    network_params::NetworkParams = NetworkParams()
    model_params::ModelParams = ModelParams()
end