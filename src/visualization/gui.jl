using GLMakie
using Graphs
using GraphMakie

export gui

function gui(model)
    graphplotkwargs = (
        layout=GraphMakie.Shell(), # node positions
        arrow_show=false, # hide directions of graph edges
        edge_color=edge_color, # change edge colors and widths with own functions
        edge_width=edge_width,
        edge_plottype=:linesegments # needed for tapered edge widths
    )

    fig, ax, abmobs = abmplot(model;
        (agent_step!)=agent_step!,
        (model_step!)=nothing,
        graphplotkwargs)

    return fig
end