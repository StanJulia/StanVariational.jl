"""

$(SIGNATURES)

Helper infrastructure to compile and sample models using `cmdstan`.
"""
module StanVariational

using StanBase
using DocStringExtensions: FIELDS, SIGNATURES, TYPEDEF

import StanBase: stan_sample, get_cmdstan_home
import StanBase: cmdline, read_summary, stan_summary
import StanBase: RandomSeed, Init, Output

include("stanmodel/variational_types.jl")
include("stanmodel/VariationalModel.jl")
include("stanrun/cmdline.jl")
include("stansamples/read_variational.jl")

stan_variational = stan_sample

export
  VariationalModel,
  stan_variational,
  read_variational,
  read_summary,
  stan_summary

end # module
