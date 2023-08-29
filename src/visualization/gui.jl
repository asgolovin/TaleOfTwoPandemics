using Graphs
using Agents
using GLMakie
using GraphMakie
using ColorTypes

export gui

function agent_color(agents)
    for agent in agents
        return agent.status == S ? :green : :red
    end
    return RGB(0, 0, 0)
end

function gui(model)
    graphplotkwargs = (
        layout=GraphMakie.Shell(), # node positions
        arrow_show=false, # hide directions of graph edges
        edge_color=:black, # change edge colors and widths with own functions
        edge_width=1,
        edge_plottype=:linesegments, # needed for tapered edge widths
    )

    fig, ax, abmobs = abmplot(model; (agent_step!)=agent_step!, ac=agent_color, graphplotkwargs)

    return fig
end