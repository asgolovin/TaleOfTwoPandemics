using GLMakie
using Graphs
using GraphMakie

export gui

function gui(model)
    graphplotkwargs = (
        layout=GraphMakie.Shell(), # node positions
        arrow_show=false, # hide directions of graph edges
        edge_color=:black, # change edge colors and widths with own functions
        edge_width=1,
        edge_plottype=:linesegments, # needed for tapered edge widths
        dimension=2,
    )

    fig, ax, abmobs = abmplot(model; (agent_step!)=agent_step!, graphplotkwargs)

    return fig
end