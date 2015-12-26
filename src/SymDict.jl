#==============================================================================#
# SymDict.jl
#
# Convenience functions for dictionaries with `Symbol` keys.
#
# Copyright Sam O'Connor 2015 - All rights reserved
#==============================================================================#


module SymDict


export SymbolDict, StringDict, @SymDict


typealias SymbolDict Dict{Symbol,Any}

SymbolDict(d::Dict) = [symbol(k) => v for (k,v) in d]
StringDict(d::Dict) = [string(k) => v for (k,v) in d]


# SymDict from local variables and keyword arguments.
#
#   a = 1
#   b = 2
#   @SymDict(a,b,c=3,d=4)
#   Dict(:a=>1,:b=>2,:c=>3,:d=>4)
#
#   function f(a; args...)
#       b = 2
#       @SymDict(a, b, c=3, d=0, args...)
#   end
#   f(1, d=4)
#   Dict(:a=>1,:b=>2,:c=>3,:d=>4)

macro SymDict(args...)

    @assert !isa(args[1], Expr) || args[1].head != :tuple

    # Check for "args..." at end...
    extra = nothing
    if isa(args[end], Expr) && args[end].head == symbol("...")
        extra = :(SymbolDict($(esc(args[end].args[1]))))
        args = args[1:end-1]
    end

    # Ensure that all args are keyword arg Exprs...
    new_args = []
    for a in args
        if !isa(a, Expr)
            a = :($a=$(esc(a)))
        end
        if !isa(a.args[1], Symbol)
            a.args[1] = eval(:(symbol($(a.args[1]))))
        end
        a.head = :kw
        push!(new_args, a)
    end

    if extra != nothing
        :(merge!(_SymbolDict($(new_args...)), $extra))
    else
        :(_SymbolDict($(new_args...)))
    end
end


# SymbolDict from keyword arguments.
#
#   _SymbolDict(a=1,b=2)
#   Dict{Symbol,Any}(:a=>1,:b=>2)

_SymbolDict(;args...) = SymbolDict(args)


# Merge new k,v pairs into dictionary.
#
#   d = @SymDict(a=1,b=2)
#   merge(d, c=3, d=4)
#   Dict(:a=>1,:b=>2,:c=>3,:d=>4)

Base.merge{V}(d::Dict{Symbol,V}; args...) = merge(d, Dict{Symbol,V}(args))
Base.merge!{V}(d::Dict{Symbol,V}; args...) = merge!(d, Dict{Symbol,V}(args))


# Return default is there is no dictionary.

Base.get(nothing::Void, key, default) = default



end # module SymDict

#==============================================================================#
# End of file.
#==============================================================================#
