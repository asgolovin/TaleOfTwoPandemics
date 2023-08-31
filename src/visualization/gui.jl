using Graphs
using Agents
using GLMakie
using GraphMakie
using ColorTypes
using Statistics

export gui

function agent_marker(agents)
    for agent in agents
        if agent.status == S
            return :circle
        elseif agent.status == I
            return :star6
        else
            return :rect
        end
    end
end

# function agent_color(agents)
#     for agent in agents
#         if agent.status == S
#             return :green
#         elseif agent.status == I
#             return :red
#         elseif agent.status == R
#             return :blue
#         end
#     end
#     return RGB(0, 0, 0)
# end

function agent_color(agents)
    practice = "handwashing"
    for agent in agents
        if agent.strategy[practice]
            return :green
        else
            return :red
        end
    end
    return RGB(0, 0, 0)
end

function agent_size(agents)
    practice = "handwashing"
    for agent in agents
        return 7 + agent.knowledge[practice] * 40
    end
end

function edge_color(model)
    w = []
    for e in edges(model.space.graph)
        agent1 = model[e.src]
        agent2 = model[e.dst]
        if distance(agent1, agent2) > model.similarity_threshold
            push!(w, :lightgray)
        else
            push!(w, :black)
        end
    end
    return w
end

function gui(model)

    num_infected(a) = a.status == I

    adata = Tuple{Function,Function}[]
    alabels = []

    push!(adata, (num_infected, count))
    push!(alabels, "# infected")

    for practice in model.practices
        eval(quote
            $(Symbol(practice))(a) = a.knowledge[$practice]
        end)

        push!(alabels, practice)
        push!(adata, (eval(Symbol(practice)), mean))
    end

    params = Dict(
        :infection_chance => 0.1:0.1:1.0
    )

    graphplotkwargs = (
        layout=GraphMakie.Shell(), # node positions
        arrow_show=false, # hide directions of graph edges
        edge_color=edge_color, # change edge colors and widths with own functions
        edge_width=1,
        edge_plottype=:linesegments, # needed for tapered edge widths
    )

    fig, abmobs = abmexploration(model;
        (agent_step!)=agent_step!, ac=agent_color, as=agent_size, am=agent_marker, params, graphplotkwargs,
        adata, alabels)

    return fig
end