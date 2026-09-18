
Changes to chapter 2:
    - added short paragraph at the end of "Parametric composite types"
    - added section on UnionAll types





    - part: contents/appendix.qmd
      chapters:
        - contents/julia-advanced.qmd


## Topics

- add Julia naming conventions for variables, types and methods to the corresponding sections

- some tricks for computing with arbitrary precision, e.g. the big128 macro

- Ranges

- Iterables & Iterators

- Function Call Barrier

- add section `### The best of both worlds` (dynamic & compiled) at the end of `## Type systems` in `type-system`

- add section `## Object-oriented programming in Julia` to `type-system` or `methods-multiple-dispatch`

- caches -> section on automatic differentiation


## Language

- changes:
    - vector/array -> tuple
    - foreach below map in anonymous functions

- help via the integrated documentation and `?<command>`

- do
- let
- zip
- reduce

- ranges

- chaining of assignments

- argument passing behavior

- destructuring

- arrays (-> used within the chapter but not introduced)
    -> all examples changed to tuples

- operators
  - priorities of operators
  - reference to list of supported operators

- composition ∘ and piping |>
https://docs.julialang.org/en/v1/base/base/#Base.:|%3E
https://docs.julialang.org/en/v1/base/base/#Base.:∘

- overlap with Chapter 3:
    - Anonymous functions
    - Varargs
    - Optional arguments
    - Keyword arguments


![Visual Studio Code (*taken from VS Code homepage, needs to be replaced!*)](../resources/vscode.png)

The screenshot in Figure 1.1 shows Visual Studio Code's tight Julia integration with support for inline code execution, introspection, plotting, notebooks, and much more.



## Types

- TODO:
    - [ ] Pretty printing of custom types
    - [ ] Case study
    - [ ] Questions & Exercises

- Chapter Outline
    - Types, variables, values
    - Type systems
    - Working with types
    - Different types of types
        - Abstract types
        - Primitive types
        - Composite types
        - Immutability
        - Mutable composite types
        - Singletons
        - Type aliases
    - Parametric types
    - Type set theory
    - UnionAll types
    - Type unions
    - Type introspection

- Julia Manual
    - Type Declarations
    - Abstract Types
    - Primitive Types
    - Composite Types
    - Mutable Composite Types
    - Declared Types
    - Type Unions
    - Parametric Types
    - UnionAll Types
    - Singleton Types
    - Types of Functions
    - Type{T} Type Selector
    - Type Aliases
    - Operations on Types
    - Custom pretty-printing
    - Value Types

- Revised Outline
    - 
    - 
    - 
    - 
    - 
    - 
    - 
    - 


MyType{T <: Number, A <: AbstractArray{T}}
= MyType{T,A} where T <: Number where A <: AbstractArray{T}

- Values types

- Performance and generic code

After we discussed how parametric types are built, we want to elucidate the aspect of performance in some more detail.



In Julia, every expression returns a value, every function, and also every assignment, e.g.,
```{julia}
x = 3
```
returns the value `3`.
This implies that every expression is associated with a return type.
Note, however, that this return type is not the type of the expression itself.
We will come back to this later in this chapter as well as the chapter on Performance & Introspection.



- Zeilenumbruch:

julia> function strange_output()
       1 + 
       1
       end
strange_output (generic function with 1 method)

julia> strange_output()
2

julia> function strange_output()
       1  
       + 1
       end
strange_output (generic function with 1 method)

julia> strange_output()
1

Im ersten Beispiel ist die erste Zeile kein vollständiger Ausdruck, Julia parsed daher nach dem Ende der ersten Zeile weiter. Das gleiche würde passieren, wenn du schreibst
(...
...)

Die erste Zeile ist unvollständig, daher wird weiter geparsed bis zum nächsten ).

Im zweiten Beispiel sind sowohl die erste wie auch die zweite Zeile vollständige und gültige Ausdrücke.
Das + in der zweiten Zeile wird einfach als Vorzeichen für 1 interpretiert. Alles andere wäre seltsam da inkonsistent.
Mit anderen Worten, wäre das Ergebnis des zweiten Beispiels auch 2, dann würde die Bedeutung von + in der zweiten Zeile vom Ergebnis des Ausdrucks der ersten Zeile abhängen. Wäre das Ergebnis der Zeile davor eine Zahl, wäre die zweite Zeile eine Addition. Wäre das Ergebnis in der Zeile davor keine Zahl, wäre das + in der zweiten Zeile nur ein Vorzeichen.
michael.kraus
Michael Kraus @michael.kraus
4:47 PM
Es ist wichtig (und sehr hilfreich) zu verstehen, dass Julia starke Wurzeln im funktionalen Programmieren hat.
Eine Folge daraus ist, dass jeder Ausdruck einen Rückgabewert hat und im speziellen in Julia jeder Wert eine Instant eines Objekts its. Das wiederum hat zur Folge, dass es in Julia sowas wie void oder null nicht gibt. Stattdessen gibt es bspw. nothing was aber tatsächlich eine Instanz des Nothing-Typs ist.
D.h. auch dass bspw.
2

ein Ausdruck mit dem Rückgabewert 2 ist, genauso wie
1 + 1

ein Ausdruck mit dem Rückgabewert 2 ist, ebenso wie
sum([1,1])

Wobei es für alles, was danach kommt, keinen Unterschied macht, aus welcher der drei Möglichkeiten der Rückgabewert resultiert.
Im Allgemeinen endet ein Ausdruck mit einem Zeilenumbruch oder mit ;, es gibt aber Ausnahmen, insbesondere offene Klammern oder Operatoren als letztes Zeichen der Zeile.
D.h.
2 +

ist genauso unvollständig wie
sum([1,1]) +

was Julia zu der Annahme verleitet, dass der Ausdruck in der nächsten Zeile fortgeführt wird.





## Methods & Multiple Dispatch

- TODO:
    - [ ] Incorporate material from Chapter 1
    - [x] Introduction
    - [ ] The expression problem
    - [ ] Operator overloading
    - [x] Outer constructor methods
    - [x] Inner constructor methods
    - [x] Parametric constructor methods
    - [x] Incomplete initialization
    - [ ] Generic code and specialization
    - [ ] Coding guidelines
    - [ ] Case study: dispatch on empty types
    - [ ] Summary
    - [ ] Questions & Exercises

- Type{T} Type Selector

- nameless arguments

- anonymous functions and closures
https://docs.julialang.org/en/v1/base/base/#Base.Fix1
https://docs.julialang.org/en/v1/base/base/#Base.Fix2

function () end

- although it seems like a simple concept, multiple dispatch on the types of values is perhaps the single most powerful and central feature of the Julia language

- multiple dispatch together with the flexible parametric type system give Julia its ability to abstractly express high-level algorithms decoupled from implementation details, yet generate efficient, specialized code to handle each case at run time

- parametric polymorphism: allows the creation of generic functions with generic data structures in order to secure staticity and handle values the same without depending on their type.


- despite their implementation differences, these operations all fall under the general concept of "addition"; accordingly, in Julia, these behaviors all belong to a single object, that is the `+` function

- when a function is applied to a particular tuple of arguments, the most specific method applicable to those arguments is applied

- Here, we are exploiting the type promotion of the `+` function, a topic we will explore in more detail in Chapter 5 on design patterns.


### Coding guidelines

A function should always correspond to a concept and its methods should implement this concept for different types of arguments.

- defining (and overwriting) generic methods for everybody's types everywhere is a potential readability (and debugability) problem
-> discipline
    - extend generic functions: implement the intended behavior and nothing else

First implement a general (fallback) method and later on specialize for specific types exploiting their particular structure.
Fallback methods are often used to implement a general method for a specific behavior that works on generic e.g. numbers or array types, and to add specialized methods for specific number or array types, exploiting their particular structure in order to provide a more efficient implementation.


### Generic code and specialization

Wenn man eine Funktion aufruft, wird diese immer für die Typen aller Argumente spezialisiert, optimiert und kompiliert.
Wenn Julia den Typen eines Arguments oder einer Variablen in der Funktion nicht sicher bestimmen kann, kann es das aber nicht tun.
Dann wird die entsprechende Variable dynamisch gewrappt, was eine Menge zusätzlichen Code und Aufwand bedeutet.
Der Typ von globalen Variablen ist aber in der Regel nicht fix. Daher kann man auf den nicht optimieren.
Das gleiche gilt, wenn sich der Typ einer Variable innerhalb der Funktion ändert.


### The expression problem

The expression or extensibility problem: "To which degree can your application be structured in such a way that both the data model and the set of virtual operations over it can be extended without the need to modify existing code, without the need for code repetition and without runtime type errors."

many approaches to solve this problem rely on exotic or problem specific language extensions

- Goal 1: use the existing types provided by a third-party library, and introduce new operations on such types;

- Goal 2: use the existing operations provided by the library, and introduce new types that can be acted upon by such operations.

- Independent extensibility: It should be possible to combine independently developed extensions so that they can be used jointly.

- In object-oriented languages goal 1 is hard, goal 2 is easy: introducing new operations on existing types is hard, because we would need to modify all existing types to support the new operations (and we might not be able to do it, if we don’t control the code which defines such types); on the other hand, introducing new types is easy, because we can just subclass the existing types.

- In functional languages goal 1 is easy, goal 2 is hard: introducing new operations on existing types is easy, because we can just create a new function; but introducing new types is hard, because we would need to edit every function that accepts the new types we want to support.

- So, neither with object-oriented languages nor with functional languages we can achieve goal 1 and 2 easily, and we need to rely on additional language features or design patterns to do that.

- open classes (aka monkey patching)
- multiple dynamic dispatch (aka multimethods)
- single dynamic dispatch


Multiple dispatch is sometimes perceived to be slow. However, this conclusion mostly relies on measurements in languages, that do not implement multiple dispatch as a 

Julia, on the other hand, is designed from the ground up around multiple dispatch.


### Operator overloading





## Working with arrays

- https://julialang.org/blog/2016/02/iteration/
- https://julialang.org/blog/2017/04/offset-arrays/

-> easy parallelisation with pmap ?


Loops vs. maps vs. broadcasts
-> performance differences



## Looping, mapping, broadcasting

### Loops

### Multidimensional algorithms

### Custom axes and indices

### Maps


## Abstract array interface

## Custom array types

## Lazy arrays

Several operators and functions we have encountered do not actually create a new array but instead wrap the array they are applied to.
Consider as an example the adjoint operator:
```{julia}
x'
```
If an adjoint array is indexed, a custom method for retrieving the corresponding element is called via multiple dispatch.
This method flips the indices and relays the request to the wrapped array.
This is a common design pattern in Julia, called [lazy arrays]{.PKeyword custom-style="PKeyword"}, which will be discussed later in this chapter.


Other examples:
- reshape (https://docs.julialang.org/en/v1/base/arrays/#Base.reshape)
- vec (https://docs.julialang.org/en/v1/base/arrays/#Base.vec)
- views






### Broadcasts

We already encountered the simplest form of broadcasting when discussing vectorization.
In all examples thus far, we used the dot syntax to apply an operation to each element of an array.
Internally, the dot syntax is mostly syntactic sugar for calling the `broadcast` function, which can do much more than just applying a specific operation to each element of a single array.
Similar to the `map` function, it can also operate on several collections and at this is fairly flexible with respect to the dimensions and the axes of its arguments.

### Loops vs. maps vs. broadcasts

Many problems can be solved equally well using loops, maps or broadcasts.
Some problems are easier or more compactly expressed one way than another, but some problems might also be solved more computationally efficiently one way than another.
So the question arises when to use which option?





## Design Patterns



## Research Software Engineering




## Notes

- Julia's key strength:
    - solves the expression problem
    - code reuse and code sharing
    - embraces good research software engineering practices

- code reuse
    - generic algorithms: applied to many different types
    - common types: shared by very different packages

- keyword: generic functions
    - Generic functions are relevant for several "classes" (structs, ...)

- duck typing

- https://discourse.julialang.org/t/why-is-julia-so-great/94718


Control Flow:

#### Assertions {.unnumbered}


::: {custom-style="PCallout"}
:::

[tuple]{custom-style="PKeyword"}


sode_equations_compatibility(v::Nothing, q::Nothing) = false
sode_equations_compatibility(v::Tuple, q::Nothing) = true
sode_equations_compatibility(v::Nothing, q::Tuple) = true
sode_equations_compatibility(v::Tuple, q::Tuple) = length(q) == length(v)





## General

- technical requirements
- define keywords
- add "Note" call out boxes
- images and code blocks should be introduced before they are shown; after they are shown there should be a short explanation what the image is showing or what the code block is doing
- sentences should not be split with code in between
- do not end section with code blocks or bullet points
- add signposts at the end of sections and chapters
- table captions
- summary sections at the end of chapters
    - What has the reader learnt in the chapter?
    - Why is the information important to the reader?
    - What will the reader learn in the next chapter?
- some questions and answers to reinforce the learning of the reader
- reference section with additional links for the user to refer


## Comments on Chapter 1: Basics of the Julia Language

- in the beginning, mention the overall outlook of the book
- at the end of the introduction, add a list of the main H1 Headings, e.g., "In this chapter, we will cover the following:"
- include technical requirements


## Comments on Chapter 2: Julia's Type System





## Comments on Chapter 3: Methods & Multiple Dispatch





## Thoughts on writing

I finished Chapter 3 and I am in the process of revising Chapter 1 and 2.
I have moved some material on function definitions from Chapter 1 to 3 to provide a more coherent presentation. This also helps shortening Chapter 1 a bit, which is quite a good thing.
I had to add a section on UnionAll types in Chapter 2 as this is needed for some material in Chapter 3.

For an updated schedule, I intend to finish chapters 4 and 5 before Christmas.
I think this is realistic, but I am not sure I can do much more than that. I hope to and will try to, but I don't want to make more promises I cannot keep.

I should also stress that I need a complete timeout over the Christmas holidays (Dec 22 - Jan 08).
We had school holidays this week and I took off for the better part of the week as I had to take care of the kids and also to recover a bit from the past two months, which have been rather stressful. 
Eventually, I ended up working on the book for a large fraction of the time, as I am equally dissatisfied with the progress so far.
The time until Christmas will probably not be as stressful, but nonetheless I will need some time away from work.

I have to say that while overall I am really enjoying this project I am sometimes struggling quite a bit.
A couple of times already I ran into some kind of writer's block, usually in phases when I am very busy, don't know where to start working, and have to jump between projects a lot.
I am not functioning particularly well under such conditions.
Probably not surprisingly, I find it much easier to write in relaxed times, like the last week, when I am not haunted by some deadline or dealing with yet another unexpected incident.

I also have to say that the expected pace for the book turned out to be quite ambitious for someone in my situation, definitely more than I expected.
The expected pace for the book is about 2 pages per work day or 10 pages per week.
In terms of pure writing, this is quite doable. 
However, developing the book is not just writing.
There is research that precedes the writing, the development of code examples, revisions of already written chapters, etc.
So overall it takes quite some time to produce and deliver 10 pages of high quality content per week. Often enough that is more time than I can expend and definitely more than 8~9 hours / week.

By now I was able to eliminate many of the stress factors of the past few months, by reducing obligations and restricting my involvements in various activities.
For example, in spring and summer, I had to take care of seven students, now I have five, two of which will graduate by the end of the month, so soon there will be only three left.
This is to say that I expect to be able to focus more on the book in the next few months.
I had already expected this after the summer, but then my wife started a new job after staying home for a long time to take care of the kids.
This turned out to be a bit more disruptive than expected, but I think by now we have mostly settled into this new situation.

Regarding a coauthor, I think this is an idea worthwhile considering and I already have two potential candidates in mind that could fit well. I have not yet reached out to them, though, as there is one potential issue.
Frankly speaking, the revenue of the book for me as author is already quite low considering the effort that goes into writing. If this is to be decreased even further by splitting among coauthors I am not sure if all of this is worth the effort and if I could justify to continue spending so much time on this project. Obviously, adding a coauthor would also reduce the amount of work on my side. But nonetheless this is a bit concerning.



The expected pace for the book is about 2 pages per work day or 10 pages per week.
At the same time you expect authors to work about 8-9h/week on the book (at least, of course).
That roughly amounts to about one page per hour.
When I am just writing, this is about the pace I achieve. Sometimes it's two or three pages in an hour, but sometimes it takes three hours to put down a single page. So on average this is probably pretty accurate.
However, this is writing only. This does not include research and it does not include the development of more involved code examples, taking screenshots, etc.
It also does not include time for revisions of already written chapters.
So overall it takes quite a bit more time to produce and deliver 10 pages of high quality content per week.
On average I would estimate that about 5 pages per week are realistic when spending 8-10h/week working on the book.

On the other hand, the expected time spent on the book per week is one full day. This is quite a lot given that most authors have a busy day job, many have a family, a social life, and it would not be healthy to sacrifice any of this for the sake of the book.

I started to work on actually writing the book in April, in week 16/2023.
By the end of week 44/2023 (first week of November), that is after 23 weeks net (29 weeks - 6 weeks of previously announced conferences and holidays, time of sickness not included), I had finished three chapters with a total of 110 pages (54+27+29) which is indeed about 4,8 pages / week.

My estimates for the first five chapters were (35+20+25+20+30) = 130 pages. Although I have only completed 3 chapters, they total to (54+27+29) = 110 pages, so the material amounts to what was planned for five chapters.
I don't want to make the figures seem better than they are, but we also have to take them for what they are.

In can see that from PACKT's point of view this might not be satisfactory, but I think it is what can be expected and achieved realistically given the boundary conditions.




I have to say that while overall, I am really enjoying this project, I am sometimes struggling a bit. A couple of times already, I ran into some kind of writer's block, usually in phases when I am very busy, don't know where to start working, and have to jump between projects a lot. I am not functioning particularly well under such conditions. Probably not surprisingly, I find it much easier to write in relaxed times, like last week, when I am not haunted by some deadline or dealing with yet another unexpected incident.
