using TaleOfTwoPandemics

input_file = "../input/default.jl"

include(input_file)

my_model = initialize_model(params)
fig = gui(my_model)