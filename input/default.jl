using TaleOfTwoPandemics
using Graphs

params = InputParams(
    NetworkParams(
        num_agents=50,
        graph_generator=watts_strogatz,
        graph_args=(50, 6, 0.2),
    ),
    ModelParams(
        infection_chance=0.4,
        spontaneous_infection_chance=0.01,
        stoch_update=0.05,
        sickness_time=50,
        immunity_time=50,
        r=0.0,
        β=10.0,
        similarity_threshold=0.5,
        action_threshold=0.5,
        action_space=Dict(
            #"garlic" => (q_true=0.2, cost=-0.2),
            #"isolation" => (q_true=0.9, cost=-1.0),
            "praying" => (q_true=0.0, cost=-0.1),
            #"transfusion" => (q_true=-0.3, cost=-0.8),
            "handwashing" => (q_true=0.5, cost=-0.2)
        )
    )
)