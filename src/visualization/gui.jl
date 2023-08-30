using Graphs
using Agents
using GLMakie
using GraphMakie
using ColorTypes
using Statistics

export gui

function agent_color(agents)
    for agent in agents
        return agent.status == I ? :red : :green
    end
    return RGB(0, 0, 0)
end

function gui(model)

    num_infected(a) = a.status == I

    adata = Tuple{Function,Function}[]
    alabels = []

    push!(adata, (num_infected, count))
    push!(alabels, "# infected")

    for practice in model.practices
        eval(quote
            $(Symbol(practice))(a) = a.knowledge[S][$practice]
        end)

        push!(alabels, practice)
        push!(adata, (eval(Symbol(practice)), std))
    end

    params = Dict(
        :infection_chance => 0.1:0.1:1.0
    )

    graphplotkwargs = (
        layout=GraphMakie.Shell(), # node positions
        arrow_show=false, # hide directions of graph edges
        edge_color=:black, # change edge colors and widths with own functions
        edge_width=1,
        edge_plottype=:linesegments, # needed for tapered edge widths
    )

    fig, abmobs = abmexploration(model;
        (agent_step!)=agent_step!, ac=agent_color, params, graphplotkwargs,
        adata, alabels)

    return fig
end