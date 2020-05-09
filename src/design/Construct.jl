abstract type AbstractConstruct{T} end
######################################
# Base functionalities for AbstractConstruct
######################################

"""
    eltype(::AbstractConstruct)

Returns the type that is generated by the iterator on an `AbstractConstruct` structure
"""
Base.eltype(::Type{AbstractConstruct{T}}) where {T} = T


"""
    getindex(Construct::AbstractConstruct,i::Int)

Returns the module on the i-th possition in the construct
Output of type `Mod`
"""
Base.getindex(c::AbstractConstruct,i::Int) = c.c[i]


"""
    getindex(c::AbstractConstruct,i::UnitRange)

Allows to index an `AbstractConstruct` using an `UnitRange` input.
Return a sub-construct of `c`,
base on the indexes defined on in the `UnitRange` object.
"""
Base.getindex(c::AbstractConstruct,i::UnitRange) = c.c[i] |> typeof(c)

"""
    length(Construct::AbstractConstruct)

Returns the length of the input construct, i.e., the number of modules that are
used.
"""
Base.length(c::AbstractConstruct) = length(c.c)

"""
    lastindex(c::AbstractConstruct)

Returns the last module of a construct, allow the uses of `end` when indexing on a `c`.
"""
Base.lastindex(c::AbstractConstruct) =  last(eachindex(IndexLinear(), c.c))


"""
    iterate(Construct::AbstractConstruct,state=1)

Iterator to loop over all modules in a given construct.
"""
function Base.iterate(Construct::AbstractConstruct,state=1)
    if  state <= length(Construct)
        mod = Construct[state]
        state += 1
        return (mod,state)
    else
        return
    end
end





##################
#New structs
##################


"""
    OrderedConstruct{T}  <: AbstractConstruct{T}

Structure that contains an ordered construct. In an ordered construct, the order
of the different modules is important.

For example: `OrderedConstruct([a,b,c])` is different compared to
`OrderedConstruct([c,b,a])`.
"""
struct OrderedConstruct{T<:Mod}  <: AbstractConstruct{T}
    c::Array{T}
end

"""
    isequal(c1::OrderedConstruct,c2::OrderedConstruct)

Evaluates if two OrderedConstruct constructs are equal.
"""
Base.isequal(c1::OrderedConstruct,c2::OrderedConstruct) = isequal(c1.c,c2.c)
==(c1::OrderedConstruct,c2::OrderedConstruct) = c1.c == c2.c
"""

"""
con2indix(construct,)

"""
    *(m1::Mod, m2::Mod)

Returns a `OrderedConstruct` containing both modules `m1` and `m2`. The order of
the input argument is maintained in the returned construct.

To allow efficient on the fly calculation using Kronecker product, the `Base.*`
should be defined between two `Mod`.
"""
*(m1::Mod, m2::Mod) = OrderedConstruct([m1, m2])


"""
    *(c::OrderedConstruct , m::Mod)

Returns a new `OrderedConstruct` where the module `m` is concatenated to the
end of the input construct `c`.
"""
*(c::OrderedConstruct, m::Mod) = push!(c.c,m) |> OrderedConstruct

"""
    *(m::Mod, c::OrderedConstruct)

Returns a new `OrderedConstruct` where the module `m` is concatenated in front
of the input construct `c`.

Probably less efficient than `*(c::OrderedConstruct ,m::Mod)` because of a
`firstpush!`
"""
*(m::Mod, c::OrderedConstruct) = pushfirst!(c.c,m) |> OrderedConstruct

"""
    *(c1::OrderedConstruct,c2::OrderedConstruct)

Concatenated two ordered constructs `c1` and `c2`,
where the construct that is in the second argument position will be appended to the end of the construct in the first argument position

```jldoctest
m1 = Mod("a")
m2 = Mod("b")
m3 = Mod("c")
c1 = OrderedConstruct([m1,m2])
c2 = OrderedConstruct([m1,m3])
c1*c2

# output
OrderedConstruct([m1,m2,m1,m4])
```
"""

*(c1::OrderedConstruct ,c2::OrderedConstruct) = vcat(c1.c,c2.c) |> OrderedConstruct
"""
    UnorderedConstruct{T} <: AbstractConstruct{T}

Structure that contains an unordered construct. In unordered construct, the
order of the different modules has no meaning.

For example: `UnorderedConstruct([a,b,c])` is considered equal to
`UnorderedConstruct([c,b,a])`.
"""
# currently the underlying structure is an array, a Set is can be a more logical alternative
# still for the first implementation and test, an array structure was preferred. An array can always be transformed Set where needed.
# The users shouldn't worry too much about this more to run everything smoothly internally

struct UnorderedConstruct{T<:Mod} <: AbstractConstruct{T}
    c::Array{T}
end

"""
    +(m1::Mod,m2::Mod)

Returns a `UnorderedConstruct` containing both modules `m1` and `m2`. Order of input argument is maintained in the returned construct.
The order of the modules doesn't have useful meaning, but it has some advantages internally to keep the order.
"""

+(m1::Mod,m2::Mod) = UnorderedConstruct([m1,m2])


"""
    +(c::UnorderedConstruct ,m::Mod)

Returns a new `UnorderedConstruct` where the module `m` is concatenated to the
end of the input construct `c`.
"""
+(c::UnorderedConstruct, m::Mod) = push!(c.c,m) |> UnorderedConstruct


"""
    +(c::OrderedConstruct, m::Mod)

Returns a new `UnorderedConstruct` where the module `m` is concatenated in front
of the input construct `c`
"""
+(m::Mod, c::UnorderedConstruct) = pushfirst!(c.c,m) |> UnorderedConstruct

"""
    +(c1::UnorderedConstruct, c2::UnorderedConstruct)

Concatenated two `UnorderedConstruct` `c1` and `c2`,
where the construct that is in the second argument position will be appended to
the end of the construct in the first argument position
"""
+(c1::UnorderedConstruct, c2::UnorderedConstruct) = vcat(c1.c, c2.c) |> UnorderedConstruct

"""
    Base.isequal(c1::UnorderedConstruct, c2::UnorderedConstruct)

Evaluates if two `UnorderedConstruct` are equal.
"""
Base.isequal(c1::UnorderedConstruct, c2::UnorderedConstruct) = isequal(Set(c1.c),Set(c2.c))
==(c1::UnorderedConstruct, c2::UnorderedConstruct) = Set(c1.c) == Set(c2.c)
