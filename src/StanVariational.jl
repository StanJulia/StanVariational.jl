"""

$(SIGNATURES)

Helper infrastructure to compile and sample models using `cmdstan`.
"""
module StanVariational

using CSV, DelimitedFiles, Unicode
using NamedTupleTools, Parameters
using StanDump, DataFrames

using DocStringExtensions: FIELDS, SIGNATURES, TYPEDEF

import StanSample: stan_summary, read_summary

include("common/common_definitions.jl")
include("common/update_model_file.jl")
include("common/par.jl")

include("stanmodel/VariationalModel.jl")

include("stanrun/stan_run.jl")
include("stanrun/cmdline.jl")

include("stansamples/read_variational.jl")
include("stansamples/read_summary.jl")
include("stansamples/stan_summary.jl")

stan_variational = stan_run

export
  VariationalModel,
  stan_variational,
  read_variational

end # module
