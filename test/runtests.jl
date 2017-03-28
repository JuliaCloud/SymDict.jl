#==============================================================================#
# runtests.jl
#
# Tests for SymDict.jl
#
# Copyright Sam O'Connor 2015 - All rights reserved
#==============================================================================#


using SymDict
using Base.Test

d = Dict(:a=>1,:b=>2)

@test StringDict(d) == Dict("a"=>1,"b"=>2)
@test SymbolDict(StringDict(d)) == d


function f()
    a = 1
    b = 2
    @SymDict(a,b,c=3,d=4)
end
@test f() == Dict(:a=>1,:b=>2,:c=>3,:d=>4)


function f2(a; args...)
    b = 2
    @SymDict(a, b, c=3, d=4, args...)
end
@test f2(1) == Dict(:a=>1,:b=>2,:c=>3,:d=>4)
@test f2(1,d="!") == Dict(:a=>1,:b=>2,:c=>3,:d=>"!")
@test f2(1,x=24,y=25,z=26) == Dict(:a=>1,:b=>2,:c=>3,:d=>4,:x=>24,:y=>25,:z=>26)


d = Dict(:a=>1,:b=>2,:c=>3,:d=>4)
@test merge(d, e=5, f=6) == Dict(:a=>1,:b=>2,:c=>3,:d=>4,:e=>5,:f=>6)

d = StringDict(Dict(:a=>1,:b=>2,:c=>3,:d=>4))
@test merge(d) == Dict("a"=>1,"b"=>2,"c"=>3,"d"=>4)
@test merge(d, "e" => 5, "f" => 6) == Dict("a"=>1,"b"=>2,"c"=>3,"d"=>4,"e"=>5,"f"=>6)


d = nothing
@test get(d, :a, "default") == "default"

@test @SymDict(a=1, "b"=2, c=3) == @SymDict(a=1, b=2, c=3)


function f3(;args...)
    StringDict(args)
end

@test f3(a=1, b=2, c=3) == StringDict(@SymDict(a=1, b=2, c=3))


#==============================================================================#
# End of file.
#==============================================================================#
