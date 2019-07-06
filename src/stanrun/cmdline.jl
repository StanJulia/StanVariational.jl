"""

# cmdline 

Recursively parse the model to construct command line. 

### Method
```julia
cmdline(m)
```

### Required arguments
```julia
* `m::CmdStanSampleModel`                : CmdStanSampleModel
```

### Related help
```julia
?CmdStanSampleModel                      : Create a CmdStanSampleModel
```
"""
function cmdline(m, id)
  
  #=
  `./bernoulli3 sample num_samples=1000 num_warmup=1000 
    save_warmup=0 thin=1 adapt engaged=1 gamma=0.05 delta=0.8 kappa=0.75 
    t0=10.0 init_buffer=75 term_buffer=50 window=25 algorithm=hmc engine=nuts 
    max_depth=10 metric=diag_e stepsize=1.0 stepsize_jitter=1.0 random 
    seed=-1 init=bernoulli3_1.init.R id=1 data file=bernoulli3_1.data.R 
    output file=bernoulli3_samples_1.csv refresh=100`,
  =#
  cmd = ``
  if isa(m, CmdStanVariationalModel)
    # Handle the model name field for unix and windows
    cmd = `$(m.exec_path)`

    # Sample() specific portion of the model
    cmd = `$cmd $(cmdline(getfield(m, :method), id))`
    
    # Common to all models
    cmd = `$cmd $(cmdline(getfield(m, :random), id))`
    
    # Init file required?
    if length(m.init_file) > 0 && isfile(m.init_file[id])
      cmd = `$cmd init=$(m.init_file[id])`
    else
      cmd = `$cmd init=$(m.init.bound)`
    end
    
    # Data file required?
    if length(m.data_file) > 0 && isfile(m.data_file[id])
      cmd = `$cmd id=$(id) data file=$(m.data_file[id])`
    end
    
    # Output options
    cmd = `$cmd output`
    if length(getfield(m, :output).file) > 0
      cmd = `$cmd file=$(string(getfield(m, :output).file))`
    end
    if length(m.diagnostic_file) > 0
      cmd = `$cmd diagnostic_file=$(string(getfield(m, :output).diagnostic_file))`
    end
    cmd = `$cmd refresh=$(string(getfield(m, :output).refresh))`
    
  else
    
    # The 'recursive' part
    cmd = `$cmd $(split(lowercase(string(typeof(m))), '.')[end])`
    for name in fieldnames(typeof(m))
      cmd = `$cmd $(name)=$(getfield(m, name))`
    end
  end
  
  cmd
  
end

