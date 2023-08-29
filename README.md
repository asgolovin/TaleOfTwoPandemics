# The Tale of Two Pandemics

What would happen if the Black Death pandemic would break out today?

Group notes: https://yopad.eu/p/Tale-of-two-pandemics-365days

## Development Notes

To install all packages, related to the project, start Julia, activate the virtual environment and install all packages:

```bash
$ julia
julia> ]activate .
julia> ]instantiate 
```

### Setup

Before you start, here are some helpful quality-of-life improvements:

#### 1. Load the package automatically

Create a file `~/.julia/config/startup.jl` and put the following into it:

```julia
using Pkg
using Revise
if isfile("Project.toml") && isfile("Manifest.toml")
    Pkg.activate(".")
end
```

For Windows, the location is `C:/Users/%username%/.julia/config/startup.jl` (I think). 

#### 2. Set up automatic formatting on save

In VSCode, go to Settings, search for "Format on Save" and check the box.

#### 3. Fix a bug in Agents.jl

Start a Julia REPL in the project folder. In the REPL, press `]` to go into the package manager mode. Then, remove the "official" Agents.jl library and add the fixed version:

```julia
rm Agents
add https://github.com/asgolovin/Agents.jl
```