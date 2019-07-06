import Base: show

abstract type CmdStanModel end

"""

# AbstractStanMethod

### Method
```julia
*  Sample::Method               : Sampling
*  Optimize::Method             : Optimization
*  Diagnose::Method             : Diagnostics
*  Variational::Method          : Variational Bayes
*  Generate_Quamtities:Method   : Generate_Quantities
```
""" 
abstract type AbstractStanMethod end

"""

# Random

Random number generator seed value

### Method
```julia
Random(;seed=-1)
```
### Optional arguments
```julia
* `seed::Int`           : Starting seed value
```
""" 
struct Random
  seed::Int64
end
Random(;seed::Number=-1) = Random(seed)

"""

# Init

Default bound for parameter initial value interval (if not found in init file)

### Method
```julia
Init(;bound=2)
```
### Optional arguments
```julia
* `bound::Number`           : Set interval to [-bound, bound]
```
""" 
struct Init
  bound::Int64
end
Init(;bound::Int64=2) = Init(bound)

mutable struct Output
  file::String
  diagnostic_file::String
  refresh::Int64
end
Output(;file="", diagnostic_file="", refresh=100) =
  Output(file, diagnostic_file, refresh)

