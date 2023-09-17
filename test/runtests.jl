using StanVariational
using Statistics, Test

if haskey(ENV, "JULIA_CMDSTAN_HOME") || haskey(ENV, "CMDSTAN")

  bernoulli_model = "
  data { 
    int<lower=1> N; 
    array[N] int<lower=0,upper=1> y;
  } 
  parameters {
    real<lower=0,upper=1> theta;
  } 
  model {
    theta ~ beta(1,1);
    y ~ bernoulli(theta);
  }
  ";

  bernoulli_data = Dict("N" => 10, "y" => [0, 1, 0, 1, 0, 0, 0, 0, 0, 1])

  stanmodel = VariationalModel("bernoulli", bernoulli_model)

  rc = stan_variational(stanmodel; data=bernoulli_data)

  if success(rc)

    @testset "Bernoulli variational example" begin
      # Read sample summary (in ChainDataFrame format)
      samples, cnames = read_variational(stanmodel)
      ms = mean(samples; dims=1)
      #ms |> display
      #ms[1, 2, 1] |> display
      @test ms[1, 2, 1] ≈ -8.2 atol=0.3
      @test ms[1, 2, 2] ≈ -8.2 atol=0.3
      @test ms[1, 2, 3] ≈ -8.2 atol=0.3
      @test ms[1, 2, 4] ≈ -8.2 atol=0.3
      @test ms[1, 3, 1] ≈ -0.5 atol=0.1
      @test ms[1, 3, 2] ≈ -0.5 atol=0.1
      @test ms[1, 3, 3] ≈ -0.5 atol=0.1
      @test ms[1, 3, 4] ≈ -0.5 atol=0.1
    end

  end

else
  println("\nCMDSTAN or JULIA_CMDSTAN_HOME not set. Skipping tests")
end
