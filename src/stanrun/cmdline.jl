"""

# cmdline 

Recursively parse the model to construct command line. 

### Method
```julia
cmdline(m)
```

### Required arguments
```julia
* `m::VariationalModel`                : VariationalModel
```

"""
function cmdline(m::VariationalModel, id)
  
    #=
    `/Users/rob/.julia/dev/StanVariational/examples/Bernoulli/tmp/bernoulli 
    variational algorithm=meanfield grad_samples=1 elbo_samples=100 
    iter=10000 tol_rel_obj=0.01 eval_elbo=100 output_samples=10000 
    random seed=-1 init=2 id=1 
    data file=/Users/rob/.julia/dev/StanVariational/examples/Bernoulli/tmp/bernoulli_data_1.R 
    output file=/Users/rob/.julia/dev/StanVariational/examples/Bernoulli/tmp/bernoulli_chain_1.csv 
    refresh=100`
    =#

    cmd = ``
    # Handle the model name field for unix and windows
    cmd = `$(m.exec_path)`

    # Variational() specific portion of the model
    cmd = `$cmd variational algorithm=$(string(m.algorithm))`

    cmd = `$cmd iter=$(m.iter)`
    cmd = `$cmd grad_samples=$(m.grad_samples) elbo_samples=$(m.elbo_samples)`
    cmd = `$cmd eta=$(m.eta)`

    if m.engaged
        cmd = `$cmd adapt engaged=1 iter=$(m.adapt_iter)`
    end

    cmd = `$cmd tol_rel_obj=$(m.tol_rel_obj)`
    cmd = `$cmd eval_elbo=$(m.eval_elbo) output_samples=$(m.output_samples)`

    cmd = `$cmd id=$(id)`

    # Data file required?
    if length(m.data_file) > 0 && isfile(m.data_file[id])
      cmd = `$cmd data file=$(m.data_file[id])`
    end
    
    # Init file required?
    if length(m.init_file) > 0 && isfile(m.init_file[id])
      cmd = `$cmd init=$(m.init_file[id])`
    else
      cmd = `$cmd init=$(m.init_bound)`
    end
    
    cmd = `$cmd random seed=$(m.seed)`
    
    # Output options
    cmd = `$cmd output`
    if length(m.sample_file) > 0
      cmd = `$cmd file=$(m.sample_file[id])`
    end
    if length(m.diagnostic_file) > 0
      cmd = `$cmd diagnostic_file=$(m.diagnostic_file)`
    end

    cmd = `$cmd refresh=$(m.refresh)`

    cmd
  
end

