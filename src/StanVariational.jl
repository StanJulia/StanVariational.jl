"""
Helper infrastructure to compile and sample models using `cmdstan`.

[`StanModel`](@ref) wraps a model definition (source code), while [`stan_sample`](@ref) can
be used to sample from it.

[`stan_compile`](@ref) can be used to pre-compile a model without sampling. A
[`StanModelError`](@ref) is thrown if this fails, which contains the error messages from
`stanc`.
"""
module StanVariational

using Reexport

@reexport using Unicode, DelimitedFiles, Distributed
@reexport using StanDump
@reexport using StanRun
@reexport using StanSamples
@reexport using MCMCChains
@reexport using Parameters

using DocStringExtensions: FIELDS, SIGNATURES, TYPEDEF

import StanRun: stan_sample, stan_cmd_and_paths, default_output_base
import StanSamples: read_samples

include("stanmodel/top_level_types.jl")
include("stanmodel/variational_types.jl")
include("stanmodel/CmdStanVariationalModel.jl")
include("stanmodel/update_model_file.jl")
include("stanmodel/number_of_chains.jl")
include("stanrun/cmdline.jl")
include("stanrun/stan_sample.jl")
include("stansamples/read_variational.jl")
include("stansamples/stan_summary.jl")
include("stansamples/read_summary.jl")

export
  CmdStanModel,
  CmdStanVariationalModel,
  read_variational,
  read_summary,
  stan_summary

end # module
