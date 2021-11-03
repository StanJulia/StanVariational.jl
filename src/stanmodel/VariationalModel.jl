import Base: show

mutable struct VariationalModel <: CmdStanModels
    name::AbstractString;              # Name of the Stan program
    model::AbstractString;             # Stan language model program
    # Sample fields
    num_chains::Int64;                 # Number of chains
    num_threads::Int64;                # Number of threads
    num_samples::Int;                  # Number of draws after warmup
    num_warmups::Int;                  # Number of warmup draws
    save_warmup::Bool;                 # Store warmup_samples
    thin::Int;                         # Thinning of draws
    seed::Int;                         # Seed section of cmd to run cmdstan
    refresh::Int                       # Display progress in output files
    init_bound::Int                    # Bound for initial param values

    # Adapt fields

    # Algorithm fields
    algorithm::Symbol;                 # :meanfield or :fullrank

    iter::Int                          # Maximum no of ADVI iterations
    grad_samples::Int                  # Number of draws to compute gradient
    elbo_samples::Int                  # Number of draws for ELBO estimate
    eta::Float64                       # Stepsize scaling parameter

    # Adapt fields
    engaged::Bool                      # Eta adaptation active
    adapt_iter::Int                    # No of iterations for eta adaptation

    tol_rel_obj::Float64               # Tolerance for convergence
    eval_elbo::Int                     # No of iterations between ELBO evaluations
    output_samples::Int                # Approximate no of posterior draws to save

    # Output files
    output_base::AbstractString;       # Used for file paths to be created
    # Tmpdir setting
    tmpdir::AbstractString;            # Holds all created files
    exec_path::AbstractString;         # Path to the cmdstan excutable
    data_file::Vector{AbstractString}; # Array of data files input to cmdstan
    init_file::Vector{AbstractString}; # Array of init files input to cmdstan
    cmds::Vector{Cmd};                 # Array of cmds to be spawned/pipelined
    sample_file::Vector{String};       # Sample file array (.csv)
    log_file::Vector{String};          # Log file array
    diagnostic_file::Vector{String};   # Diagnostic file array
    cmdstan_home::AbstractString;      # Directory where cmdstan can be found
end

"""
# VariationalModel 

Create a VariationalModel and compile the Stan Language Model.. 

### Required arguments
```julia
* `name::AbstractString`        : Name for the model
* `model::AbstractString`       : Stan model source
```

### Optional positional argument
```julia
 `tmpdir::AbstractString`             : Directory where output files are stored
```

"""
function VariationalModel(
    name::AbstractString,
    model::AbstractString,
    tmpdir = mktempdir())

    !isdir(tmpdir) && mkdir(tmpdir)

    update_model_file(joinpath(tmpdir, "$(name).stan"), strip(model))

    output_base = joinpath(tmpdir, name)
    exec_path = executable_path(output_base)
    cmdstan_home = get_cmdstan_home()

    error_output = IOBuffer()
    is_ok = cd(cmdstan_home) do
        success(pipeline(
            `make -f $(cmdstan_home)/makefile -C $(cmdstan_home) $(exec_path)`;
                stderr = error_output))
    end
    if !is_ok
        throw(StanModelError(model, String(take!(error_output))))
    end

    VariationalModel(name, model, 
        # num_chains, num_threads, num_samples, num_warmups, save_warmups
        4, 4, 1000, 1000, false,
        # thin, seed, refresh, init_bound
        1, -1, 100, 2,

        # Variational settings
        :meanfield,                    # algorithm
        10000,                         # iter (ADVI)
        1,                             # grad_samples
        100,                           # elbo_samples
        1.0,                           # eta

        # Adaption
        true,                          # engaged
        50,                            # adapt_iter

        0.01,                          # tol_rel_obj
        100,                           # eval_elbo
        1000,                          # output_samples

        # Ouput settings
        output_base,
        # Tmpdir settings
        tmpdir,
        # exec_path
        exec_path,
        # Data files
        AbstractString[],
        # Init files
        AbstractString[],  
        # Command lines
        Cmd[],
        # Sample .csv files  
        String[],
        # Log files
        String[],
        # Diagnostic files
        String[],
        cmdstan_home)
end

function Base.show(io::IO, ::MIME"text/plain", m::VariationalModel)
    println(io, "\nVariational section:")
    println(io, "  name =                    ", m.name)
    println(io, "  num_chains =              ", m.num_chains)
    println(io, "  num_threads =             ", m.num_threads)
    println(io, "  num_samples =             ", m.num_samples)
    println(io, "  num_warmups =             ", m.num_warmups)
    println(io, "  save_warmup =             ", m.save_warmup)
    println(io, "  thin =                    ", m.thin)
    println(io, "  seed =                    ", m.seed)
    println(io, "  refresh =                 ", m.refresh)
    println(io, "  init_bound =              ", m.init_bound)

    println(io, "\nAlgorithm section:")
    println(io, "  algorithm =               ", m.algorithm)
    println(io, "    iter =                  ", m.iter)
    println(io, "    grad_samples =          ", m.grad_samples)
    println(io, "    elbo_samples =          ", m.elbo_samples)
    println(io, "    eta =                   ", m.eta)

    println(io, "\nAdapt section:")
    println(io, "  engaged =                 ", m.engaged)
    println(io, "  adapt_iter =              ", m.adapt_iter)

    println(io, "\nCompletion section:")
    println(io, "  tol_rel_obj =             ", m.tol_rel_obj)
    println(io, "  eval_elbo =               ", m.eval_elbo)        
    println(io, "  output_samples =          ", m.output_samples)        

    println(io, "\nOther:")
    println(io, "  output_base =             ", m.output_base)
    println(io, "  tmpdir =                  ", m.tmpdir)
end
