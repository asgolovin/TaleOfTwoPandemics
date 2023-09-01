using TaleOfTwoPandemics
using Graphs

params = InputParams(
    NetworkParams(
        num_agents=200,
        graph_generator=watts_strogatz,
        graph_args=(200, 4, 0.3),

    ),
    ModelParams(
        infection_chance=0.7,
        spontaneous_infection_chance=0.06,
        stoch_update=0.05,
        sickness_time=4,
        immunity_time=8,
        r=0.60,
        β=0.85,
        similarity_threshold=0.87,
        action_threshold=0.448,
        action_space=Dict(
            "Praying" => (q_true=0.0, cost=-0.0),
            "Isolation" => (q_true=0.9, cost=-0.9),
            "Flagellation" => (q_true=0.1, cost=-0.8),
            "Handwashing" => (q_true=0.6, cost=-0.1),
            #= "Sanitising" => (q_true=0.6, cost=-0.3),
            "Garlic" => (q_true=0.3, cost=-0.5),
            "Sauna" => (q_true=0.3, cost=-0.7),
            "ThroatWash" => (q_true=0.2, cost=-0.3),
            "Mask" => (q_true=0.4, cost=-0.5),
            "ColdShower" => (q_true=0.2, cost=-0.4) =#
            
        )
    )
)