"""

stan_variational()

Sample from a StanJulia VariationalModel (<: CmdStanModel.)

## Required argument
```julia
* `m::VariationalModel`                # VariationalModel.
* `use_json=true`                      # Use JSON3 for data and init files
```

### Most frequently used keyword arguments
```julia
* `data`                               # Observations Dict or NamedTuple.
* `init`                               # Init Dict or NT (default: -2 to +2).
```

### Returns
```julia
* `rc`                                 # Return code, 0 is success.
```

See extended help for other keyword arguments ( `??stan_sample` ).

# Extended help

### Additional configuration keyword arguments
```julia
* `num_chains=4`                       # Update number of chains.
* `num_threads=8`                      # Update number of threads.

* `seed=-1`                            # Set seed value.
* `refresh=100`                        # Strem to output.
* `init_bound=2`                       # Bound for initial values.

* `algorithm=:meanfield`               # :menafield or :fullrank
* `iter=10000`                         # Maximim no of ADVI iterations
* `grad_samples=1`                     # Number of draws to compute gradient
* `elbo_samples=100`                   # Number of draws for ELBO estimate
* `eta=1.0`                            # Stepsize scaling parameter

* `engaged=true`                       # Eta adaptation active
* `adapt_iter=50`                      # No of iterations for eta adaptation

* `tol_rel_obj=0.01`                   # Tolerance for convergence
* `eval_elbo=100`                      # No of iterations between ELBO evaluations
* `output_samples=1000`                # Approximate no of posterior draws to save
```
"""
function stan_run(m::T, use_json=true; kwargs...) where {T <: CmdStanModels}

    handle_keywords!(m, kwargs)
    
    # Diagnostics files requested?
    diagnostics = false
    if :diagnostics in keys(kwargs)
        diagnostics = kwargs[:diagnostics]
        setup_diagnostics(m, m.num_chains)
    end

    # Remove existing sample files
    for id in 1:m.num_chains
        sfile = sample_file_path(m.output_base, id)
        isfile(sfile) && rm(sfile)
    end

    if use_json
        :init in keys(kwargs) && update_json_files(m, kwargs[:init],
            m.num_chains, "init")
        :data in keys(kwargs) && update_json_files(m, kwargs[:data],
            m.num_chains, "data")
    else
        :init in keys(kwargs) && update_R_files(m, kwargs[:init],
            m.num_chains, "init")
        :data in keys(kwargs) && update_R_files(m, kwargs[:data],
            m.num_chains, "data")
    end

    m.cmds = [stan_cmds(m, id; kwargs...) for id in 1:m.num_chains]

    #println(typeof(m.cmds))
    #println()
    #println(m.cmds)

    run(pipeline(par(m.cmds), stdout=m.log_file[1]))
end

"""

Generate a cmdstan command line (a run `cmd`).

$(SIGNATURES)

Internal, not exported.
"""
function stan_cmds(m::T, id::Integer; kwargs...) where {T <: CmdStanModels}
    append!(m.sample_file, [sample_file_path(m.output_base, id)])
    append!(m.log_file, [log_file_path(m.output_base, id)])
    if length(m.diagnostic_file) > 0
      append!(m.diagnostic_file, [diagnostic_file_path(m.output_base, id)])
    end
    cmdline(m, id)
end
