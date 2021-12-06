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
import StanBase: update_R_files
import StanBase: data_file_path, init_file_path, sample_file_path
import StanBase: generated_quantities_file_path, log_file_path
import StanBase: diagnostic_file_path, setup_diagnostics
import StanBase: make_string, make_command

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
