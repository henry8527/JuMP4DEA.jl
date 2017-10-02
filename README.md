# JuMP4DEA.jl

[![Build Status](https://travis-ci.org/henry8527/JuMP4DEA.jl.svg?branch=master)](https://travis-ci.org/henry8527/JuMP4DEA.jl)


**JuMP4DEA.jl** is a package for solving large-scale data envelopment analysis (DEA) problems. Benefited from the development of JuMP, a modeling language in Julia, and cutting-edge solvers, JuMP4DEA is user-friendly, flexible and computationally efficient to solve different DEA problems, including radial, non-radial and different returns to scale assumptions.  
<br>

## Installation
`julia> Pkg.clone("git://github.com/henry8527/JuMP4DEA.jl.git")`
<br><br>

## Quick Start Guide
### Creating Model
Models are Julia objects. They are created by calling the constructor: <br><br>
` m = model() `
<br><br>
All variables and constraints are associated with a Model object. Usually, you’ll also want to provide a solver object here by using the `solver=` keyword argument
<br><br>
In our example code , default using `solver = GurobiSolver()`
<br><br>

### Defining Variables

Variables are also Julia objects, and are defined using the `@variable` macro. The first argument will always be the Model to associate this variable with. In the examples below we assume m is already defined. The second argument is an expression that declares the variable name and optionally allows specification of lower and upper bounds.

	@variable(m, x )              # No bounds
	@variable(m, x >= lb )        # Lower bound only (note: 'lb <= x' is not valid)
	@variable(m, x <= ub )        # Upper bound only
	@variable(m, lb <= x <= ub )  # Lower and upper bounds
	
<br>
In our example code , we define varibles `CLambda` and `Ctheta` for solving DEA problems.

	@variable(crs,cLambda[1:scale] >= 0)
	@variable(crs,cTheta) 
	
<br><br>
### Objective and Constraints

JuMP allows users to use a natural notation to describe linear expressions. To add constraints, use the `@constraint()` and `@objective()` macros

	@constraint(m, x[i] - s[i] <= 0)  # Other options: == and >=
	@constraint(m, sum(x[i] for i=1:numLocation) == 1)
	@objective(m, Max, 5x + 22y + (x+y)/2) # or Min
	
<br>
In our example code , We define `Min` objective , and add constraints for product input and output. 

	@objective(crs,Min,cTheta)
    @constraint(crs, C1[j=1:2], sum{data[i,j]*cLambda[i], i = 1:scale} >= data[t,j])
    @constraint(crs, C2[j=3:5], sum{data[i,j]*cLambda[i], i = 1:scale} <= cTheta*data[t,j])
    
<br><br>
### Solve problem
call our JuMP4DEA function solveDEA
	
	stat,iterations,duals,slack = JuMP4DEA.solveDEA(model)
	
	
<br><br>
### Parameter and its default value in solveDEA
<br>

>
**incrementSize** : smallLP increment size when its size under lpUP for resampling
<br>

	stat,iterations,duals,slack = JuMP4DEA.solveDEA(model, incrementSize = 100)

>
**Tol** : the accuracy for solving DEA problem
<br>

	stat,iterations,duals,slack = JuMP4DEA.solveDEA(model, Tol = 10^-6)

>
**lpUB** : the limit size of LP
<br>

	stat,iterations,duals,slack = JuMP4DEA.solveDEA(model, lpUB = Inf)

>
**extremeValueSetFlag** : first sampling take extremeValueSet or not ( 0 = turn off, 1 = turn on )
<br>


	stat,iterations,duals,slack = JuMP4DEA.solveDEA(model, extremeValueSetFlag = 0)

<br>
