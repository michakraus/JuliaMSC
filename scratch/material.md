
## The Julia Language

### Vectorization with the dot syntax


::: {.content-visible unless-format="docx"}

Maximum efficiency is typically achieved when the output array of a vectorized operation is pre-allocated, so repeated calls do not allocate new arrays over and over again for the results.
A convenient syntax for this is `X .= ...`, which is equivalent to `broadcast!(identity, X, ...)` except that the `broadcast!` loop is fused with any nested "dot" calls:
```{julia}
X .= sin.(Y)
```
is equivalent to
```{julia}
broadcast!(sin, X, Y)
```
overwriting `X` with `sin.(Y)` in place.

If the left-hand side is an array-indexing expression, e.g., `X[begin+1:end] .= sin.(Y)`, then it translates to `broadcast!` on a `view`, specifically
```{julia}
broadcast!(sin, view(X, firstindex(X)+1:lastindex(X)), Y[2:3])
```
so that the left-hand side is updated in-place.

The pipe operator can also be used with broadcasting, as `.|>`, to provide a useful combination of the chaining/piping and dot vectorization syntax:
```{julia}
["a", "list", "of", "strings"] .|> [uppercase, reverse, titlecase, length]
```

:::


## Types

- this "declaration" behaviour only occurs in specific contexts and applies to the whole current scope, even before the declaration
```julia
julia> local x::Int8  # in a local declaration

julia> x::Int8 = 10   # as the left-hand side of an assignment
Error: cannot set type for global x. It already has a value or is already set to a different type.
```


- Julia also has a predefined abstract "bottom" type, at the nadir of the type graph, which is written as `Union{}`

- it is the exact opposite of `Any`: no object is an instance of `Union{}` and all types are supertypes of `Union{}`


We declared `MyInt8` to be a subtype of `Integer`, which makes all the standard integer methods available to our new type once we implemented those type-specific methods, that require knowledge of the actual bit-layout of our new type.



- the standard primitive types are all defined in the language itself:
```julia
primitive type Float16 <: AbstractFloat 16 end
primitive type Float32 <: AbstractFloat 32 end
primitive type Float64 <: AbstractFloat 64 end

primitive type Bool <: Integer 8 end
primitive type Char <: AbstractChar 32 end

primitive type Int8    <: Signed   8 end
primitive type UInt8   <: Unsigned 8 end
primitive type Int16   <: Signed   16 end
primitive type UInt16  <: Unsigned 16 end
primitive type Int32   <: Signed   32 end
primitive type UInt32  <: Unsigned 32 end
primitive type Int64   <: Signed   64 end
primitive type UInt64  <: Unsigned 64 end
primitive type Int128  <: Signed   128 end
primitive type UInt128 <: Unsigned 128 end
```

- the declaration of `Bool` therefore means that a boolean value takes eight bits to store, and has `Integer` as its immediate supertype
```{julia}
primitive type Bool <: Integer 8 end
```

- currently, only sizes that are multiples of 8 bits are supported, therefore boolean values, although they really need just a single bit, cannot be declared to be any smaller than eight bits

- the types `Bool`, `Int8` and `UInt8` all have identical representations: they are eight-bit chunks of memory
```{julia}
primitive type Int8    <: Signed   8 end
primitive type UInt8   <: Unsigned 8 end
```



- since Julia's type system is nominative, however, they are not interchangeable despite having identical structure


- a fundamental difference between them is that they have different supertypes: `Bool`'s direct supertype is `Integer`, `Int8`'s is `Signed`, and `UInt8`'s is `Unsigned`


- all other differences between `Bool`, `Int8`, and `UInt8` are matters of behaviour: the way functions are defined to act when given objects of these types as arguments


- this is why a nominative (or name-based) type system is necessary: if structure determined type, which in turn dictates behaviour, then it would be impossible to make `Bool` behave any differently than `Int8` or `UInt8`


### Parametric primitive types

, and all specific pointer types are subtypes of the `Ptr` type:
```{julia}
Ptr{Float64} <: Ptr
```
```{julia}
Ptr{Int64} <: Ptr
```


### Tuple Types

- tuples are an abstraction of the arguments of a function – without the function itself

- the salient aspects of a function's arguments are their order and their types

- therefore a tuple type is similar to a parameterized immutable type where each parameter is the type of one field

- example: a 2-element tuple type resembles the following immutable type
```julia; eval=false
struct Tuple2{A,B}
    a::A
    b::B
end
```

- however, there are three key differences:
    - tuple types may have any number of parameters
    - tuple types are covariant in their parameters: `Tuple{Int}` is a subtype of `Tuple{Any}`; therefore `Tuple{Any}` is considered an abstract type, and tuple types are only concrete if their parameters are
    - tuples do not have field names; fields are only accessed by index

- when a tuple is constructed, an appropriate tuple type is generated on demand
```julia; term=true
typeof((1,"foo",2.5))
```

- note the implications of covariance
```julia; term=true
Tuple{Int,AbstractString} <: Tuple{Real,Any}
```


### Vararg Tuple Types

- the last parameter of a tuple type can be the special type `Vararg`, which denotes any number of trailing elements
```julia; term=true
mytupletype = Tuple{AbstractString,Vararg{Int}}
isa(("1",), mytupletype)
isa(("1",1), mytupletype)
isa(("1",1,2), mytupletype)
isa(("1",1,2,3.0), mytupletype)
```

- `Vararg` tuple types are used to represent the arguments accepted by varargs methods

- the type `Vararg{T}` corresponds to zero or more elements of type `T`

- the type `Vararg{T,N}` corresponds to exactly `N` elements of type `T`

- `NTuple{N,T}` is a convenient alias for `Tuple{Vararg{T,N}}`, i.e. a tuple type containing exactly `N` elements of type `T`


### Named Tuple Types (?)

- named tuples are instances of the `NamedTuple` type, which has two parameters:
    - a tuple of symbols giving the field names
    - and a tuple type giving the field types

```julia; term=true
typeof((a=1,b="hello"))
```

- a `NamedTuple` type can be used as a constructor, accepting a single tuple argument

- the constructed `NamedTuple` type can be either a concrete type, with both parameters specified, or a type that specifies only field names
```julia; term=true
NamedTuple{(:a, :b),Tuple{Float32, String}}((1,""))
NamedTuple{(:a, :b)}((1,""))
```

- if field types are specified, the arguments are converted; otherwise the types of the arguments are used directly


### Type set theory

#### Parametric abstract types

In the language of type theory, this means that Julia's type parameters are _invariant_ but not _covariant_ or even _contravariant_.

- the notation `Pointy{<:Real}` can be used to express the Julia analogue of a covariant type, while `Pointy{>:Int}` the analogue of a contravariant type, but technically these represent sets of types
```julia; term=true
Pointy{Float64} <: Pointy{<:Real}
Pointy{Real} <: Pointy{>:Int}
```

- much as abstract types serve to create useful hierarchies of types over concrete types, parametric abstract types serve the same purpose with respect to parametric composite types

- example: declare `XYPoint{T}` to be a subtype of `Pointy{T}`
```julia
struct XYPoint{T} <: Pointy{T}
    x::T
    y::T
end
```

- given such a declaration, for each choice of `T`, we have `XYPoint{T}` as a subtype of `Pointy{T}`
```julia; term=true
XYPoint{Float64} <: Pointy{Float64}
XYPoint{Real} <: Pointy{Real}
XYPoint{AbstractString} <: Pointy{AbstractString}
```

- this relationship is also invariant
```julia; term=true
XYPoint{Float64} <: Pointy{Real}
XYPoint{Float64} <: Pointy{<:Real}
```

- create a point-like implementation that only requires a single coordinate because the point is on the diagonal line `x = y`
```julia; term=true
struct DiagPoint{T} <: Pointy{T}
    x::T
end
```

- both `XYPoint{Float64}` and `DiagPoint{Float64}` are implementations of the `Pointy{Float64}` abstraction, and similarly for every other possible choice of type `T`

- this allows programming to a common interface shared by all `Pointy` objects, implemented for both `XYPoint` and `DiagPoint`


#### Parametric composite types

- while any instance of `Point{Float64}` may conceptually be like an instance of `Point{Real}` as well, the two types have different representations in memory
    - an instance of `Point{Float64}` can be represented compactly and efficiently as an immediate pair of 64-bit values
    - an instance of `Point{Real}` must be able to hold any pair of instances of `Real`; since objects that are instances of `Real` can be of arbitrary size and structure, in practice an instance of `Point{Real}` must be represented as a pair of pointers to individually allocated `Real` objects

- the efficiency gained by being able to store `Point{Float64}` objects with immediate values is magnified enormously in the case of arrays: an `Array{Float64}` can be stored as a contiguous memory block of 64-bit floating-point values, whereas an `Array{Real}` must be an array of pointers to individually allocated `Real` objects 

- although these may well be boxed 64-bit floating-point values, they also might be arbitrarily large, complex objects, which are declared to be implementations of the `Real` abstract type


- a correct way to define a method that accepts all arguments of type `Point{T}` where `T` is a subtype of `Real` is
```julia; eval=false
function norm(p::Point{<:Real})
    sqrt(p.x^2 + p.y^2)
end
```
or
```julia; eval=false
function norm(p::Point{T} where T<:Real)
    sqrt(p.x^2 + p.y^2)
end
```
or 
```julia; eval=false
function norm(p::Point{T}) where T<:Real
    sqrt(p.x^2 + p.y^2)
end
```


### Type Selectors

- for each type `T`, `Type{T}` is an abstract type whose only instance is the object `T`

- since the definition is a little difficult to parse, let's look at some examples
```julia; term=true
isa(Float64, Type{Float64})
isa(Real, Type{Float64})
isa(Real, Type{Real})
isa(Float64, Type{Real})
```

- `isa(A,Type{B})` is `true` iff `A` and `B` are the same object and that object is a type

- without the parameter, `Type` is an abstract type which has all type objects as its instances, including singleton types, but excluding objects that are not a type
```julia; term=true
isa(Type{Float64}, Type)
isa(Float64, Type)
isa(Real, Type)
isa(1, Type)
```

- singleton types allow to specialize function behaviour on specific type values

- this is useful for writing methods (especially parametric ones) whose behaviour depends on a type that is given as an explicit argument rather than implied by the type of one of its arguments

- their full utility will become clearer in the context of parametric methods and conversions

- in general usage, the term "singleton type" refers to a type whose only instance is a single value; this meaning applies to Julia's singleton types, but with that caveat that only type objects have singleton types


### UnionAll types

- since where expressions nest, type variable bounds can refer to outer type variables, e.g., `Tuple{T,Array{S}} where S<:AbstractArray{T} where T<:Real` refers to two-tuples whose first element is some `Real`, and whose second element is an `Array` of any kind of array whose element type contains the type of the first tuple element

- the `where` keyword itself can be nested inside a more complex declaration
```julia; term=true
const T1 = Array{Array{T,1} where T, 1}
const T2 = Array{Array{T,1}, 1} where T
```

- type `T1` defines a one-dimensional array of one-dimensional arrays; each of the inner arrays consists of objects of the same type, but this type may vary from one inner array to the next


- type `T2` defines a one-dimensional array of one-dimensional arrays all of whose inner arrays must have the same type


- note that `T2` is an abstract type, e.g., `Array{Array{Int,1},1} <: T2`, whereas `T1` is a concrete type; consequently, `T1` can be constructed with a zero-argument constructor `a=T1()` but `T2` cannot



### Parametric constructor methods

- each definition looks like the form of constructor call that it handles:
    - the call `RealPoint{Int64}(1,2)` will invoke the definition `RealPoint{T}(x,y)` inside the struct block
    - the outer constructor declaration defines a method for the general `RealPoint` constructor which only applies to pairs of values of the same real type and makes constructor calls without explicit type parameters work

- since the other constructor method declaration restricts the arguments to being of the same type, calls with arguments of different types, result in "no method" errors

- the constructor call `RealPoint(1,2.5)` can be made to work by promoting the integer value `1` to the floating-point value `1.0` with an additional outer constructor method
```julia; term=true
RealPoint(x::Int64, y::Float64) = RealPoint(convert(Float64,x),y);
RealPoint(1,2.5)
```

- this method uses the `convert` function to explicitly convert `x` to `Float64` and then delegates construction to the general constructor for the case where both arguments are `Float64`

- however, similar calls still do not work
```julia; term=true
RealPoint(1.5, 2)
```

- all it takes to make all calls to the general `RealPoint` constructor work as one would expect is the following outer method definition
```julia; term=true
RealPoint(x::Real, y::Real) = RealPoint(promote(x,y)...);
```

- the `promote` function converts all its arguments to a common type, here `Float64`

- with this method definition, the `RealPoint` constructor promotes its arguments the same way that numeric operators like `+` do, and works for all kinds of real numbers
```julia; term=true
RealPoint(1.5, 2)
RealPoint(1, 1//2)
RealPoint(1.0, 1//2)
```

- while the implicit type parameter constructors provided by default in Julia are fairly strict, it is possible to make them behave in a more relaxed but sensible manner quite easily

- since constructors can leverage all of the power of the type system, methods, and multiple dispatch, defining sophisticated behaviour is typically quite simple



### Incomplete initialization


- it is possible to return incompletely initialized objects from an inner constructor (although it is generally a good idea to return a fully initialized object)
```{julia}
mutable struct Incomplete
    data
    Incomplete() = new()
end

inc = Incomplete()
```

- while you are allowed to create objects with uninitialized fields, any access to an uninitialized reference is an immediate error
```{julia}
#| error: true
inc.data
```

- this avoids the need to continually check for `null` values



## Working with arrays


- Julia does not expect programs to be written in a vectorized style for performance
- Julia's compiler uses type inference and generates optimized code for scalar array indexing, allowing programs to be written in a style that is convenient and readable, without sacrificing performance
- in Julia, all arguments to functions are passed by sharing (i.e. by pointers)
- arrays can be created by enclosing the elements in square brackets
```julia
julia> [10, 20, 30]
3-element Vector{Int64}:
 10
 20
 30

julia> ["spam", 2.0, 5, [10, 20]]
4-element Vector{Any}:
  "spam"
 2.0
 5
  [10, 20]
```

#### Initialisation

- many functions for constructing and initializing arrays are provided

| Function                            | Description                                                             |
|:----------------------------------- |:----------------------------------------------------------------------- |
| `zeros(T, dims...)`                 | an `Array` of all zeros                                                 |
| `ones(T, dims...)`                  | an `Array` of all ones                                                  |
| `trues(dims...)`                    | a `BitArray` with all values `true`                                     |
| `falses(dims...)`                   | a `BitArray` with all values `false`                                    |
| `reshape(A, dims...)`               | an array containing the same data as `A`, but with different dimensions |
| `copy(A)`                           | copy `A`                                                                |
| `deepcopy(A)`                       | copy `A`, recursively copying its elements                              |
| `reinterpret(T, A)`                 | an array with the same binary data as `A`, but element type `T`         |
| `randn(T, dims...)`                 | an `Array` with random, standard normally distributed values            |
| `rand(T, dims...)`                  | an `Array` with random, uniformly distributed values                    |
| `Matrix{T}(I, m, n)`                | `m`-by-`n` identity matrix (requires `using LinearAlgebra`)             |
| `range(start, stop=stop, length=n)` | range of `n` linearly spaced elements from `start` to `stop`            |
| `fill!(A, x)`                       | fill the array `A` with the value `x`                                   |
| `fill(x, dims...)`                  | an `Array` filled with the value `x`                                    |

- calls with a `dims...` argument can either take a single tuple of dimension sizes or a series of dimension sizes passed as a variable number of arguments
```{julia}
zeros(Int16, 2, 3) # equivalent to zeros(Int8, (2, 3))
```
- most of these functions accept a first input `T`, which is the element type of the array (if omitted `T` will default to `Float64`)

#### Properties
- comprehensions provide a general and powerful way to construct arrays
```{julia}
X = [ 1//2^i for i in 0:2 ]
```

```{julia}
Y = [ i*2^j for i in 1:3, j in 0:3]
```
- basic functions on arrays

| Function       | Description                                                         |
|:-------------- |:------------------------------------------------------------------- |
| `eltype(A)`    | the type of the elements contained in `A`                           |
| `length(A)`    | the number of elements in `A`                                       |
| `ndims(A)`     | the number of dimensions of `A`                                     |
| `size(A)`      | a tuple containing the dimensions of `A`                            |
| `size(A,n)`    | the size of `A` along dimension `n`                                 |
| `axes(A)`      | a tuple containing the valid indices of `A`                         |
| `axes(A,n)`    | a range expressing the valid indices along dimension `n`            |
| `eachindex(A)` | an efficient iterator for visiting each position in `A`             |
| `stride(A,k)`  | linear index distance between adjacent elements in dimension `k`    |
| `strides(A)`   | a tuple of the strides in each dimension                            |

#### Concatenation
- concatenation

| Syntax            | Function  | Description                                        |
|:----------------- |:--------- |:-------------------------------------------------- |
|                   | `cat`     | concatenate input arrays along dimension(s) `k`    |
| `[A; B; C; ...]`  | `vcat`    | shorthand for `cat(A...; dims=1)                   |
| `[A B C ...]`     | `hcat`    | shorthand for `cat(A...; dims=2)                   |
| `[A B; C D; ...]` | `hvcat`   | simultaneous vertical and horizontal concatenation |

```julia
julia> [1:2; 4:5]
4-element Vector{Int64}:
 1
 2
 4
 5

julia> [1:2, 4:5] # Has a comma, so no concatenation occurs
2-element Vector{UnitRange{Int64}}:
 1:2
 4:5

julia> [1:2  4:5  7:8]
2×3 Matrix{Int64}:
 1  4  7
 2  5  8

julia> [[1 2] [3]; [4 5] [6]; [7 8] [9]]
3×3 Matrix{Int64}:
 1  2  3
 4  5  6
 7  8  9
```
#### Indexing
- the general syntax for indexing an n-dimensional array `A` is `A[I_1, I_2, ..., I_n]` where each `I_k` may be 
  - a scalar index:
      - an integer or `CartesianIndex{N}`, which behave like an N-tuple of integers spanning multiple dimensions
      - `begin` and `end` which represent the index of the first and last element in a dimension
  - an array of scalar indices: 
      - vectors and multidimensional arrays of integers or `CartesianIndex{N}`
      - empty arrays like [], which select no elements
      - ranges like `a:c` or `a:b:c`, which select contiguous or strided subsections from `a` to `c` (inclusive)
  - an object that represents an array of scalar indices and can be converted to such by `to_indices`
      - `Colon()` or `(:)`, which represents all indices within an entire dimension or across the entire array
      - arrays of booleans, which select elements at their `true` indices 
- cartesian indexing: the ordinary way to index into an `N`-dimensional array is to use exactly `N` indices, where each index selects the position(s) in its particular dimension
- linear indexing: when exactly one index `i` is provided, that index no longer represents a location in a particular dimension of the array, but it selects the `i`th element using the column-major iteration order that linearly spans the entire array
- examples
```julia
julia> X = reshape(collect(1:2:18), (3, 3))
3×3 Matrix{Int64}:
 1   7  13
 3   9  15
 5  11  17

julia> X[2,2]
9

julia> X[4]
7

julia> X[[1 4; 3 8]]
2×2 Matrix{Int64}:
 1   7
 5  15

julia> X[1:2:5]
3-element Vector{Int64}:
 1
 5
 9

julia> X[begin, :]
3-element Vector{Int64}:
  1
  7
 13
```
- Julia is column-major, i.e., data is contiguous on the first index of an array
- an array "slice" expression like `array[1:5, :]` creates a copy of that data (except on the left-hand side of an assignment `array[1:5, :] = ...`)
- when doing many operations on the slice, this can be preferable because it is more efficient to work on a smaller contiguous copy than to index into the original array
- when doing just a few simple operations on the slice, the cost of the allocation and copy operations can be substantial
- the alternative is to create a "view" of the array, which is an array object that actually references the data of the original array in-place, without making a copy
- for individual slices this can be done by calling `view`, for a whole expression or block of code this can be done by putting `@views` in front of that expression
```{julia}
fcopy(x) = sum(x[2:end-1]);
fview1(x) = sum(view(x, 2:lastindex(x)-1));
@views fview2(x) = sum(x[2:end-1]);
```
```julia
julia> x = rand(10^6);

julia> @time fcopy(x);
  0.000989 seconds (3 allocations: 7.629 MiB)

julia> @time fview1(x);
  0.000187 seconds (1 allocation: 16 bytes)

julia> @time fview2(x);
  0.000185 seconds (1 allocation: 16 bytes)
```
- in Julia, indices start with 1, which is not always convenient
- *OffsetArrays.jl* provides arrays with arbitrary indices, similar to those in Fortran
- such arrays can be constructed as follows
```{julia}
#| eval: false
OA = OffsetArray(A, axis1, axis2, ...)
```
for example
```{julia}
#| echo: false
#| output: false
using OffsetArrays
```
```{julia}
OA = OffsetArray(reshape(1:15, 3, 5), -1:1, 0:4)
```
```{julia}
OA[-1,0]
```
- in order to write general code that supports OffsetArrays as well as other abstract arrays, it is important to write index ranges in loops, etc., *not* using `1:length(A)` or `1:size(A,1)` but using `eachindex(A)` or `axis(A,1)` instead


#### Dot Notation
- for every binary operation like `^`, there is a corresponding "dot" operation `.^` that is automatically defined to perform `^` element-by-element on arrays
- example: `[1,2,3]^3` is not defined, since there is no standard mathematical meaning to "cubing" a (non-square) array, but `[1,2,3] .^ 3` is defined as computing the elementwise (or "vectorized") result `[1^3, 2^3, 3^3]`
```{julia}
[1,2,3] .^ 3
```

- more specifically, `a .^ b` performs a broadcast operation: it can combine arrays and scalars and arrays of the same size (performing the operation elementwise)
- moreover, like all vectorized "dot calls," these "dot operators" are fusing
    - example: if you compute `2 .* A.^2 .+ sin.(A)` (or equivalently `@. 2A^2 + sin(A)`, using the `@.` macro) for an array `A`, it performs a single loop over `A`, computing `2a^2 + sin(a)` for each element `a` of `A`
- the dot syntax is also applicable to user-defined operators
    - example: if you define `⊗(A,B) = kron(A,B)` to give a convenient infix syntax `A ⊗ B` for Kronecker products (`kron`), then `[A,B] .⊗ [C,D]` will compute `[A⊗C, B⊗D]` with no additional coding
- combining dot operators with numeric literals can be ambiguous
    - example: it is not clear whether `1.+x` means `1. + x` or `1 .+ x`, therefore this syntax is disallowed, and spaces must be used around the operator
#### Broadcasting
- sometimes it is useful to perform element-by-element binary operations on arrays of different sizes, such as adding a vector to each column of a matrix
- to implement this efficiently Julia provides `broadcast`, which expands singleton dimensions in array arguments to match the corresponding dimension in the other array without using extra memory, and applies the given function elementwise
```julia
julia> X = rand(2,3); x = rand(2,1); y = rand(1,2);

julia> broadcast(+, x, Y)
Error: DimensionMismatch: arrays could not be broadcast to a common size; got a dimension with lengths 2 and 3

julia> broadcast(+, x, y)
2×2 Matrix{Float64}:
 0.275708  0.541215
 0.557516  0.823023
```
- dotted operators such as `.+` and `.*` are equivalent to broadcast calls
- there is also a `broadcast!` function to specify an explicit destination
```julia
julia> Y = zero(X)
2×3 Matrix{Float64}:
 0.0  0.0  0.0
 0.0  0.0  0.0

julia> broadcast!(+, Y, x, X)
2×3 Matrix{Float64}:
 0.158891  0.630913  0.565605
 1.18313   0.415112  1.2784
```




## Modules

- in Julia, modules are separate variable workspaces, i.e. they introduce a new global scope and allow for creating top-level definitions (global variables) without worrying about name conflicts; they are delimited syntactically, inside `module Name ... end`


- within a module, importing controls which names from other modules are visible, and exporting specifies which of your names are intended to be public


```julia
module MyModule

  using LinearAlgebra

  using SharedArrays: SharedMatrix

  export foo

  bar(x) = 2x
  foo(a::SharedMatrix) = det(a) .+ inv(a)

end
```



- the statement `using LinearAlgebra` means that the `LinearAlgebra` module will be available for resolving names as needed


- when a global variable is encountered that has no definition in the current module, the system will search for it among variables exported by `LinearAlgebra` and import it if it is found there (such as `det` and `inv`)


- the statement `using SharedArrays: SharedMatrix` brings just the identifier `SharedMatrix` from module `SharedArrays` into the scope of `MyModule`


- the module defines two functions `foo` and `bar`, with `foo` being exported, and thus available for importing into other modules, and `bar` being private





- Julia also has the `import` keyword, which supports the same syntax as `using`, however, it does not add modules to be searched the way using does


- once a variable is made visible via `using` or `import`, a module may not create its own variable with the same name


- imported variables are read-only; assigning to a global variable always affects a variable owned by the current module, or else raises an error
```julia
julia> module A1
                  a = 1 # a global in A1's scope
              end;

julia> module B1
                  import ..A1 # makes module A1 available
                  A1.a = 2    # changing a variable of an imported module throws below error
              end;
Error: cannot assign variables in other modules
```



- however, a module might provide functions that change its variables, and these can be imported and called from other modules
```julia
julia> module A2
                  a = 1 # a global in A2's scope
                  set_a(x) = a = x
              end;

julia> module B2
                  import ..A2 # makes module A2 available
                  A2.set_a(2) # change a variable of an imported module via a set-function
              end;
```




### Using Modules

- to understand the differences of the `using` and `import` keywords, consider the following example module with functions `x` and `y` (exported) and `p` (not exported)
```julia
module MyModule

    export x, y

    x() = "x"
    y() = "y"
    p() = "p"

end;
```




- there are several different ways to load the module and its inner functions into the current workspace

| Import Command                  | What is brought into scope                  |
|:------------------------------- |:------------------------------------------- |
| `using MyModule`                | All `export`ed names (`x` and `y`),         |
|                                 | `MyModule.x`, `MyModule.y`, `MyModule.p`    |
| `using MyModule: x, p`          | `x` and `p`                                 |
| `import MyModule`               | `MyModule.x`, `MyModule.y`, `MyModule.p`    |
| `import MyModule.x, MyModule.p` | `x` and `p`                                 |
| `import MyModule: x, p`         | `x` and `p`                                 |


- functions imported with `using` cannot be extended with new methods; methods can only be added to functions imported with `import`


### Modules and Files


- files and file names are mostly unrelated to modules; modules are associated only with module expressions


- one can have multiple files per module, and multiple modules per file
```julia
module Foo
    include("file1.jl")
    include("file2.jl")
end
```



- including the same code in different modules provides mixin-like behaviour; one could use this to run the same code with different base definitions, for example testing code by running it with "safe" versions of some operators
```julia
module Normal
    include("mycode.jl")
end

module Testing
    include("safe_operators.jl")
    include("mycode.jl")
end
```



### Paths

- given the statement `using Foo`, the system consults an internal table of top-level modules to look for one named `Foo`


- if the module does not exist, the system attempts to `require(:Foo)`, which typically results in loading code from an installed package


- some modules contain submodules, which means you sometimes need to access a non-top-level module


- the first way to do this is to use an absolute path, for example `using Base.Sort`


- the second way is to use a relative path, which makes it easier to import submodules of the current module or any of its enclosing modules
```{julia}
module Parent

    module Utils
        # ...
    end

    using .Utils

    # ...
end
```



- the module `Parent` contains a submodule `Utils`, and code in `Parent` wants the contents of `Utils` to be visible; this is done by starting the using path with a period


- adding more leading periods moves up additional levels in the module hierarchy; for example `using ..Utils` would look for `Utils` in `Parent`'s enclosing module


- note that relative-import qualifiers are only valid in `using` and `import` statements






## Performance Tips


- a useful tool for measuring performance is the `@time` macro, which reports runtimes and memory allocations during a function call
```julia
julia> x = rand(10000);

julia> function mysum()
           s = zero(eltype(x))
           for i in x
               s += i
           end
           return s
       end;

julia> @time mysum();
  0.004253 seconds (39.64 k allocations: 780.281 KiB, 86.29% compilation time)

julia> @time mysum();
  0.000557 seconds (39.49 k allocations: 773.281 KiB)
```



- on the first call the function gets compiled - this is sometimes referred to as warmup - you should not take the results of this run seriously


- on the first call of `@time`, it will also compile functions needed for timing


- in the second run, it will report the actual run time and memory allocations


- unexpected memory allocation is almost always a sign of some problem with your code, usually a problem with type-stability or creating many small temporary arrays; consequently, in addition to the allocation itself, it is very likely that the code generated for your function is far from optimal


- take such indications seriously and follow the advice below




- the *BenchmarkTools.jl* package makes performance tracking of Julia code even easier


- it provides the `@btime` macro, which is similar to `@time` but takes care of warmup
```julia
julia> @btime mysum();
  544.958 μs (39490 allocations: 773.28 KiB)
```



- the `@benchmark` macro provides more comprehensive out
```julia
julia> @benchmark mysum()
BenchmarkTools.Trial: 8630 samples with 1 evaluation.
 Range (min … max):  544.625 μs …   2.120 ms  ┊ GC (min … max): 0.00% … 69.98%
 Time  (median):     554.792 μs               ┊ GC (median):    0.00%
 Time  (mean ± σ):   578.428 μs ± 172.807 μs  ┊ GC (mean ± σ):  3.91% ±  9.07%

  █▂▁                                                           ▁
  ███▆▅▆▄▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▇█ █
  545 μs        Histogram: log(frequency) by time       1.88 ms <

 Memory estimate: 773.28 KiB, allocs estimate: 39490.
```



- the `@benchmark` macro usually runs several samples of the function to evaluate in order to mitigate benchmark noise and obtain reasonable and consistent performance predictions



### Global Variables

- a global variable might have its value, and therefore its type, change at any point


- this makes it difficult for the compiler to optimize code using global variables


- variables should be local, or passed as arguments to functions, whenever possible


- code that is performance critical or being benchmarked should be inside a function


- globals are often constants; declaring them as such greatly improves performance
```julia
julia> const DEFAULT_VAL = 0;
```



- uses of non-constant globals can be optimized by annotating their types when used
```julia
global x = rand(1000);

function loop_over_global_annotated()
    s = 0.0
    for i in x::Vector{Float64}
        s += i
    end
    return s
end;
```




- passing arguments to functions is better style and leads to more reusable code
```julia
function loop_over_global(x)
    s = 0.0
    for i in x
        s += i
    end
    return s
end;
```


```julia
function loop_over_global_simple()
    s = 0.0
    for i in x
        s += i
    end
    return s
end;

function loop_over_global_annotated()
    s = 0.0
    for i in x::Vector{Float64}
        s += i
    end
    return s
end;

function loop_over_global(x)
    s = 0.0
    for i in x
        s += i
    end
    return s
end;
```


```julia
julia> @btime loop_over_global_simple();
  52.375 μs (3490 allocations: 70.16 KiB)

julia> @btime loop_over_global_annotated();
  864.407 ns (0 allocations: 0 bytes)

julia> @btime loop_over_global(x);
  884.347 ns (1 allocation: 16 bytes)
```




## Type Stability

### Type-stable Functions

#### Write "type-stable" functions

- the following function might return a value of two types: either the type of `0`, which is an integer (of type `Int`), or the type of `x`, which might be of any type
```julia
pos(x) = x < 0 ? 0 : x;
```




- it is easy to ensure that the function always returns a value of the same type
```julia
pos(x) = x < 0 ? zero(x) : x;
```




- there is also a `one()` function, and a more general `oftype(x, y)` function, which returns `y` converted to the type of `x`



### Type-stable Variables

#### Avoid changing the type of a variable

- an analogous "type-stability" problem exists for variables used repeatedly within a function
```julia
julia> function foo()
           x = 1
           for i in 1:10
               x /= rand()
           end
           return x
       end;
```



- the local variable `x` starts as an integer, and after one loop iteration becomes a floating-point number (the result of `/` operator)


- possible solutions:
  - initialize `x` with `x = 1.0`
  - declare the type of `x`: `x::Float64 = 1`
  - use an explicit conversion: `x = one(Float64)`


#### Type Annotations

#### Annotate values taken from untyped locations

- it is often convenient to work with data structures that may contain values of any type (e.g. arrays of type `Array{Any}`)


- if you are using such a structure and happen to know the type of an element, it helps to share this knowledge with the compiler
```julia
function foo(a::Array{Any,1})
    x = a[1]::Int32
    b = x+1
    # ...
end
```



- here, we happened to know that the first element of a would be an `Int32`


- making an annotation like this has the added benefit that it will raise a run-time error if the value is not of the expected type, potentially catching certain bugs


- if the type of `a[1]` is not known precisely, `x` can be declared via
```julia
x = convert(Int32, a[1])::Int32
```



- the use of the `convert` function allows `a[1]` to be any object convertible to an `Int32`, thus increasing the genericity of the code by loosening the type requirement


- notice that `convert` itself needs a type annotation in this context in order to achieve type stability, because the compiler cannot deduce the type of the return value of a function, even `convert`, unless the types of all the function's arguments are known



#### Function Barriers

- many functions follow a pattern of performing some set-up work, and then running many iterations to perform a core computation


- these core computations should be put in separate functions


- the following contrived function returns an array of a randomly-chosen type
```julia
function strange_twos(n)
    a = Vector{rand(Bool) ? Int64 : Float64}(undef, n)
    for i in 1:n
        a[i] = 2
    end
    return a
end;
```



- Julia's compiler specializes code for argument types at function boundaries, so it does not know the type of a during the loop (since it is chosen randomly)


- separating out the inner loop allows the compiler to specialise for different types
```julia
function fill_twos!(a)
    for i in eachindex(a)
        a[i] = 2
    end
end;

function strange_twos(n)
    a = Vector{rand(Bool) ? Int64 : Float64}(undef, n)
    fill_twos!(a)
    return a
end;
```



- the second form is also often better style and can lead to more code reuse

