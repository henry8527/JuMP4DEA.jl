using JuMP
using MathProgBase
using Gurobi
using JuMP4DEA

data = readcsv("example.csv") # input User's (.csv) data path
scale = 25000 # scale of example data = 25000

for t = 1 : scale

    benchmark = data[t,:]

    #Model
    crs = Model(solver = GurobiSolver()) # example use GurobiSolver , User can choose their own favorite solver
    @variable(crs,cLambda[1:scale] >= 0)
    @variable(crs,cTheta)
    @objective(crs,Min,cTheta)
    @constraint(crs, C1[j=1:2], sum{data[i,j]*cLambda[i], i = 1:scale} >= data[t,j])
    @constraint(crs, C2[j=3:5], sum{data[i,j]*cLambda[i], i = 1:scale} <= cTheta*data[t,j])

    # main function call here

    # use dafault parameter
    # incrementSize = 100
    # Tol = 10.0^-6
    # lpUB = Inf
    # extremeValueSetFlag = 0 (default turn off extreme value set)
    stat,iterations,duals,slack = JuMP4DEA.solveDEA(crs)

    # Get DEA problem answer
    #--------------------------
    #println("stat = $stat")
    #println("iterations = $iterations")

    #println("the real data to test: $benchmark")
    #println("lambdas: $(getvalue(cLambda)))")
    #println("Objective value: $(getobjectivevalue(crs))")
    #println("Duals value: $duals")
    #println("Slack value: $slack")
    #--------------------------
end
