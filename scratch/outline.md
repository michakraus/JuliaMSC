# Outline {-}

**Part 1: Programming in Julia**

1. Basics of the Julia Language
2. Julia’s Type System
3. Methods and Multiple Dispatch
4. Working with Arrays
5. Design Patterns

**Part 2: Research Software Engineering**

1. Package Development
2. Git and GitHub
3. Software Sustainability
4. Test Driven Development
5. Performance and Introspection

**Part 3: Useful Libraries and Solutions to Common Problems**

1. Working with Data
2. Differentiable Programming
3. Linear and Nonlinear Equations
4. Differential Equations
5. Machine Learning

**Part 4: Parallel and GPU Programming**

1. Parallel Programming Paradigms
2. Parallel Arrays
3. GPU Programming
4. Hybrid Parallel Programming
5. Case Studies (optional)


**Appendix (2nd Edition)**

1. The Julia Language: Basics
2. The Julia Language: Advanced Topics


## Page Count

|-----------------------------------------------------------|-----|-----|
| Part 1: Programming in Julia                              | 130 |     |
|-----------------------------------------------------------|-----|-----|
| 1. Basics of the Julia Language                           |  35 |  55 |
| 2. Julia’s Type System                                    |  20 |  30 |
| 3. Methods and Multiple Dispatch                          |  25 |  30 |
| 4. Working with Arrays                                    |  20 | _28_|
| 5. Design Patterns                                        |  30 |     |
|-----------------------------------------------------------|-----|-----|
| Part 2: Research Software Engineering                     | 125 |     |
|-----------------------------------------------------------|-----|-----|
| 1. Package Development                                    |  30 |     |
| 2. Git and GitHub                                         |  20 |     |
| 3. Software Sustainability                                |  25 |     |
| 4. Test Driven Development                                |  25 |     |
| 5. Performance and Introspection                          |  25 |     |
|-----------------------------------------------------------|-----|-----|
| Part 3: Useful Libraries and Solutions to Common Problems | 120 |     |
|-----------------------------------------------------------|-----|-----|
| 1. Working with Data                                      |  30 |     |
| 2. Differentiable Programming                             |  20 |     |
| 3. Linear and Nonlinear Equations                         |  20 |     |
| 4. Differential Equations                                 |  30 |     |
| 5. Machine Learning                                       |  20 |     |
|-----------------------------------------------------------|-----|-----|
| Part 4: Parallel and GPU Programming                      | 120 |     |
|-----------------------------------------------------------|-----|-----|
| 1. Parallel Programming Paradigms                         |  30 |     |
| 2. Parallel Arrays                                        |  15 |     |
| 3. GPU Programming                                        |  30 |     |
| 4. Hybrid Parallel Programming                            |  25 |     |
| 5. Case Studies (optional; not included in proposal)      |  20 |     |
|-----------------------------------------------------------|-----|-----|


### Preface: Julia’s Superpowers

## Part 1: Programming in Julia

The first part of the book introduces important aspects of the Julia programming language and ecosystem that are relevant for scientific computing.
It highlights concepts and language elements that are different from other programming languages such as Python or C++ and describes design and problem solving patterns that are typical for scientific programming. 
It explains the full package development cycle, from the creation of a package, over introspection and performance optimization, up to its registration in the Julia package registry.
Research software engineering techniques that lead to high quality code, such as continuous integration and test driven development, are emphasized.


### Basics of the Julia Language
35 pages

This chapter briefly reviews the most important elements of the Julia programming language.
Its main aim is to present all basic language elements that are used in the book, thus keeping the book self-contained to a certain level, and bring all readers onto the same page.
This chapter could also serve as a crash course in Julia for readers who are experienced in other programming languages such as Python or C++.

#### Chapter Headings

- Development Environments
- Julia Code
- Variables
- Numbers
- Data Structures
- Functions
- Macros
- Control Flow
- Packages
- Environments

#### Skills learned

- Overview of all basic elements of the Julia programming language that are used in the book


### Julia’s Type System
20 pages

This chapter introduces Julia's dynamic type system.
It explains the differences between abstract and concrete types, between primitive and composite types, and introduces the concept of parametric types.
In the discussion, the similarities and differences to other languages are emphasized, e.g., how composite types relate to classes in class-based object-oriented languages, or how parametric types relate to templates in C++.
The chapter includes a brief discussion of type set theory, i.e., which sets of types are supersets or subsets of other sets of types, as this is a common pitfall in Julia, especially in sight of multiple dispatch (cf. next chapter).
The chapter closes with a section on conversion and promotion that explains how type conversions can be automatized in order to write generic code.

#### Chapter Headings

- Abstract Types
- Primitive Types
- Composite Types
- Parametric Types
- Type Set Theory: Supertypes, Subtypes, Unions
- Conversion and Promotion

#### Skills learned

- Understand Julia's dynamic type system
- Understand how types are declared and constrained
- Build abstract type hierarchies
- Build composite types and understand how they relate to classes in Python or C++
- Use conversion and promotion to facilitate generic and robust code


### Methods & Multiple Dispatch
25 pages

This chapter explains methods and the multiple dispatch paradigm, on which Julia is based. It explains typical design patterns around multiple dispatch, how to utilize it effectively, and compares this approach to class based object oriented programming languages such as Python and C++.
The reader will be familiarized with guiding principles for writing generic code and learn when and how to specialize code.

#### Chapter Headings

- Functions and Methods
- Dispatch
- Parametric Methods
- Generic Code and Specialization

#### Skills learned

- Understand Julia's concept of dynamic dispatch
- Facilitate multiple dispatch to write expressive and extensible code
- Write generic code and know when to specialize code


### Working with Arrays
20 pages

This chapter explores all aspects of working with Arrays in Julia. It starts with an overview of standard array types, before explaining Julia's abstract array interface, that makes implementing custom array types very easy. The reader will learn about Julia’s unique approach to arrays and some peculiarities that are different to arrays in other languages, especially when it comes to indexing and looping over arrays. This chapter closes with an overview of useful array types that allow for custom index ranges, continuous indexing, fast computations on the stack, or the representation of arrays of infinite size.

#### Chapter Headings

- Vectors, Matrices, Arrays
- Indexing, Looping, Mapping
- Abstract Array Interface
- Custom Arrays
- Lazy Arrays
- Array Libraries
    - Offset Arrays
    - Static Arrays
    - Continuum Arrays
    - Linear Operators

#### Skills learned

- Understanding Julia's abstract array interface
- Understanding generic indexing and looping
- Implementation of custom array types
- Knowledge of useful array libraries


### Design Patterns
30 pages

This chapter explains some important design patterns that are typical for Julia but not necessarily found in other languages. Most importantly, it discusses the difference of composition and inheritance and highlights the advantages of composition for writing generic and maintainable scientific code.
Further, it discusses Julia's concept of interfaces and how to utilize it effectively in order to write generic and extensible code.
Lazy arrays are presented as a typical example of an interface and a powerful design pattern that is widely used in Julia scientific computing.
Lastly, this chapter explains how Julia's meta-programming facilities can be used to create domain-specific languages.

#### Chapter Headings

- Composition
- Conversion, Promotion, Similar
- Interfaces
- Domain-specific Languages

#### Skills learned

- Understand the difference between composition and inheritance
- Use interfaces to write generic and extensible code
- How and when to use lazy arrays
- Develop domain-specific languages with Julia's meta-programming facilities


## Part 2: Research Software Engineering

Part 2 explains crucial aspects of research software engineering that aim at guaranteeing robustness, flexibility, extensibility, maintainability and sustainability of scientific computer codes as well as efficiency of the development process. It is illustrated how Julia provides a unique environment for implementing these principles and how to apply these techniques in real-world problems.

### Package Development
30 pages

This chapter discusses all aspects of creating, developing and maintaining a Julia package. Starting from package creation, over documentation and testing, up to integration with GitHub, which is Julia's main development platform.

#### Chapter Headings

- Packages
- Modules
- Dependency Management
- Documentation
- Tests
- Style Guides
- Package Templates

#### Skills learned

- Understand the structure and ingredients of Julia packages
- Create Julia packages from scratch by hand and from templates
- Setup and create documentation
- Setup and create automated tests


### Git and GitHub
20 pages

This chapter covers basic ideas around version control using Git and collaborative software development on GitHub.
It explains why version control is essential for many aspects of research software engineering, such as maintainability and reproducibility but also attribution.
This chapter also explains how to work with GitHub, which is the main platform used for Julia development, hosting the vast majority of all Julia packages.
It explains GitHub workflows which can be used, e.g., for automated testing, continuous integration, package registration, as well as best practices that avoid potential problems.

#### Chapter Headings

- Version Control
- Basic git usage
- GitHub Repositories
- GitHub Workflows
- Best Practices

#### Skills learned

- Understand version control with git
- Create, use and maintain GitHub repositories for Julia packages
- Use GitHub Workflows for automated testing, continuous integration, package registration
- Apply best practices for clean repositories and avoiding common problems


### Software Sustainability
25 pages

This chapter discusses more design patterns, which are concerned with software engineering aspects such as robustness, reusability and maintainability.

#### Chapter Headings

- Reusability
- Robustness
- Maintainability

#### Skills learned

- Write reusable code
- Write robust code
- Write maintainable code


### Test Driven Development
25 pages

Test driven development (TDD) is a concept of great utility for the development of robust code.
In TDD, tests for each component are written ahead of the actual implementation of the component itself.
This chapter introduces the concept of TDD, shows how to implement it in Julia and how to apply it to scientific problems.
TDD is often perceived as exceedingly difficult to apply to real-world scientific software.
This perception, however, is incorrect and rather stems from poor structure of many scientific applications.
This chapter explains how to structure code in a testable way and proposes techniques for different levels of testing, that are specifically tailored towards scientific applications.

 #### Chapter Headings

- In the beginning there was the Test
- Unit Tests
- Integration Tests
- Testing Interfaces
- Manufactured Solutions

#### Skills learned

- Understand and apply test driven development techniques
- Write unit tests and integration tests for scientific software
- Use manufactured solutions for testing solvers


### Performance & Introspection
25 pages

In this chapter readers learn how to write performant code and how to avoid pitfalls that are detrimental to performance. They learn about introspection tools that can be used to analyze code performance and identify bottlenecks, to benchmark code and for debugging.

#### Chapter Headings

- Performance Tips
- Type Stability
- Code Introspection
- Profiling
- Benchmarking
- Debugging

#### Skills learned

- Understand possible performance issues in Julia and how to avoid them
- Apply introspection tools to analyze code performance


## Part 3: Useful Libraries and Solutions to Common Problems

Part 3 discusses different libraries and solution strategies for common tasks in scientific computing.
The reader learns about reading, writing and plotting data, working with data that is augmented with physical units or uncertainties, solving linear and nonlinear systems of equations, computing derivatives for Jacobians or Hessians and integrating classical algorithms with machine learning models.


### Working with Data
30 pages

This chapter explains how to solve recurrent data-related tasks such as reading ascii (CSV) and binary (HDF) data, reading and writing config files or manipulating tabular data. It features a brief crash course in plotting and mentions some useful packages that facilitate computations with augmented and non-common data types, such as high precision data, data with error margins, or physical units.

#### Chapter Headings

- Reading and Writing CSV
- Reading and Writing HDF5
- Reading and Writing Config Files
- Manipulating Tabulated Data with DataFrames.jl
- Basic Plotting with Makie
- Augmented Data
- Quadruple and Arbitrary Precision
- Uncertainties (Measurements.jl)
- Physical Units (Unitful.jl)

#### Skills learned

- Reading and writing of common data formats (CSV, HDF5, Config Files)
- Manipulating tabulated data
- Basic plotting of 2D and 3D data
- Computing with augmented and non-common data types

### Differentiable Programming
20 pages

This chapter explains the basic principles of automatic differentiation and differentiable programming.
The reader learns how to write differentiable code and how to use different methods and frameworks for automatic differentiation to solve common tasks such as the computation of gradients, Jacobians or Hessians.

#### Chapter Headings

- Automatic Differentiation
- ForwardDiff
- Enzyme

#### Skills learned

- Understand automatic differentiation and differentiable programming
- Write differentiable code
- Use automatic differentiation to compute common derivatives (gradients, Jacobians, Hessians)


### Linear and Nonlinear Equations
20 pages

This chapter explains how to solve linear and nonlinear systems of equations as well as optimization problems - a task that appears ubiquitously in scientific computing. It presents general interfaces for these tasks that can be used to call a variety of different backends and algorithms.

#### Chapter Headings

- Linear Systems
- Nonlinear Systems
- Optimization

#### Skills learned

- Solve linear systems
- Solve nonlinear systems
- Solve optimization problems


### Differential Equations
30 pages

Solving differential equations is one of the most common tasks in scientific computing.
This chapter describes how to solve typical ordinary and partial differential equations with standard tools from the Julia ecosystem.
It presents useful packages and interfaces for this task and gives a slightly more in-depth overview of Gridap, which is a powerful finite element framework for the solution of partial differential equations.

#### Chapter Headings

- Ordinary Differential Equations
- Partial Differential Equations
- Finite Elements with Gridap

#### Skills learned

- Solve common differential equation types within the Julia ecosystem
- Build finite element solvers with Gridap


### Machine Learning
20 pages

This chapter gives an overview of native Julia frameworks for machine learning as well as frontends to machine learning in other languages such as TensorFlow.
The main focus of the chapter is on showcasing how advanced machine learning tasks can be solved by utilizing the power of the Julia ecosystem by integrating packages such as Manifolds.jl with machine learning models, as well as integrating machine learning methods with classical numerics, e.g., for preconditioning or solving differential equations.

#### Chapter Headings

- Deep Learning Frameworks
- Manifold Learning
- Physics Informed Neural Networks
- NeuralODEs and NeuralPDEs
- Integration with Classical Numerical Algorithms

#### Skills learned

- Overview of different deep learning frameworks
- Integrate different Julia packages in machine learning models
- Integrate machine learning models with classical numerical algorithms


## Part 4: Parallel and GPU Programming

The last part of the book explains parallel programming in Julia utilizing different paradigms, such as threads, MPI and GPUs. It explains how each of these paradigms can be used on its own and in conjunction with each other. It showcases some useful libraries that abstract parallel communication or hardware specifics away from the user, thus allowing to write more general and more robust code.

### Parallel Programming Paradigms
30 pages

This chapter explains the different parallel programming paradigms supported by Julia. It implements one problem using each paradigm and discusses when to use which paradigm.

#### Chapter Headings

- Threads
- Tasks
- Distributed
- MPI

#### Skills learned

- Understand the different parallel programming paradigms supported by Julia
- Understand the suitability of each paradigm for typical problems
- Parallelize typical problems with each of the paradigms


### Parallel Arrays
15 pages

This chapter explains different array types that hide parallel communication from the user, thus dramatically simplifying parallel programming and facilitating more robust and maintainable code.

#### Chapter Headings

- MPI Arrays
- MPIHaloArrays.jl
- ImplicitGlobalGrid.jl
- Pencil Arrays
- Partitioned Arrays

#### Skills learned

- Understand different parallel array types and their applicability


### GPU Programming
30 pages

This chapter explains how to write and run GPU code in Julia.
It emphasizes hardware-agnostic code and focuses on general concepts and frameworks such as GPU arrays, kernel abstractions and parallel stencils, rather than explaining specific frameworks such as CUDA or ROCM.
It also explains how to utilize more than one GPU at once.

#### Chapter Headings

- GPU Arrays
- Kernel Abstractions
- Parallel Stencil
- Multiple GPUs

#### Skills learned

- Write and run GPU code with GPU arrays
- Write hardware-agnostic code with kernel abstractions and parallel stencils
- Use multiple GPUs at once


### Hybrid Parallel Programming
25 pages

This chapter brings all the techniques of the previous chapters together and explains how to use different paradigms at once to utilize distributed and heterogeneous compute clusters - a typical scenario for mid- to large-scale scientific codes. It picks one real-world example and shows how to use different combinations of techniques to solve this problem.

#### Chapter Headings

- Threads and GPUs
- MPI and Threads
- MPI, Threads and GPUs

#### Skills learned

- Combine different parallelization paradigms in one code


## Appendix

### The Julia Language: Basics

#### Chapter Headings



### The Julia Language: Advanced Topics

#### Chapter Headings

- Scope of Variables




## Removed

### Development Environments 

*The reader is expected to have basic Julia knowledge, and I'd like to think that DEs can be expected to be part of this. I added a short section in Chapter 1, though.*

20 pages 
 
Description: This chapter presents different development environments and different interfaces to Julia.
It explains how to use the interactive command-line REPL (read-eval-print loop), interactive notebooks such as Jupyter and Pluto, and a fully-fledged integrated developed environment, namely Visual Studio Code. It presents workflows in each of the environments and explains for which tasks the different environments are suited.
 
#### Chapter Headings

- REPL
- Visual Studio Code
- Jupyter Notebooks
- Pluto Notebooks

#### Skills learned:
 
- Understand the different choices of interfaces and development environments for Julia
- Understand the suitability of each environment for different tasks
- Learn tools that simplify Julia code development (e.g., Revise.jl)
