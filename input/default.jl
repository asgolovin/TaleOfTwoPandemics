using TaleOfTwoPandemics
using Graphs

params = InputParams(
    NetworkParams(
        num_agents=10,
        graph_generator=watts_strogatz,
        graph_args=(10, 4, 0.3),
    ),
    ModelParams(
        infection_chance=0.1,
        sickness_time=8,
        immunity_time=15,
        r=1.0,
        β=0.5,
        similarity_threshold=0.5,
        action_threshold=0.5,
        action_space=Dict(
            "garlic" => (q_true=0.2, cost=0.2),
            "isolation" => (q_true=0.9, cost=1.0),
            "praying" => (q_true=0.0, cost=0.1),
            "transfusion" => (q_true=-0.3, cost=0.8),
            "handwashing" => (q_true=0.7, cost=0.3)
        )
    )
)