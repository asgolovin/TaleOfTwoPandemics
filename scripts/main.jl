using TaleOfTwoPandemics

input_file = "../input/default.jl"

include(input_file)

model = initialize_model(params)
fig = gui(model)