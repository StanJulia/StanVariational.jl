"""

$(SIGNATURES)

Helper infrastructure to compile and sample models using `cmdstan`.
"""
module StanVariational

using CSV, DelimitedFiles, Unicode
using NamedTupleTools, Parameters
using StanDump, DataFrames

using DocStringExtensions: FIELDS, SIGNATURES, TYPEDEF

using StanBase

import StanBase: update_model_file, par, handle_keywords!
import StanBase: executable_path, ensure_executable, stan_compile

include("stanmodel/VariationalModel.jl")

include("stanrun/stan_run.jl")
include("stanrun/cmdline.jl")

include("stansamples/read_variational.jl")

stan_variational = stan_run

export
  VariationalModel,
  stan_variational,
  read_variational,
  read_summary,
  stan_summary

end # module
