using StanVariational
using Test

if haskey(ENV, "JULIA_CMDSTAN_HOME") || haskey(ENV, "CMDSTAN")

  bernoulli_model = "
  data { 
    int<lower=1> N; 
    int<lower=0,upper=1> y[N];
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
      sdf = read_summary(stanmodel)

      @test sdf[sdf.parameters .== :theta, :mean][1] ≈ 0.32 atol=0.1
    end

  end

else
  println("\nCMDSTAN or JULIA_CMDSTAN_HOME not set. Skipping tests")
end
