@testset "Moduels" begin


Symbol_array =[:sym, :sym2, :sym3]
String_array = ["a", "b", "c"]

mt_a = Mod("a")
mt_b = Mod("b")
mt_c = Mod("c")
mt_d = Mod("d")
mt_e = Mod("e")

mt_symb = Mod(:sym)

moduel_test_Symbol_array_non_unique =[:sym, :sym2, :sym3, :sym2]
moduel_test_String_array_non_unique= ["a", "b", "c" ,"a"]

@testset "SetMod_single"  begin
    @test mt_symb.m == :sym
    @test mt_a.m == "a"
    @test mt_symb |> length  == 1
    @test mt_a |> length == 1
end

Group_Mod_test = Group_Mod([mt_a,mt_b,mt_c,mt_d,mt_e])
Group_Mod_test_order = Group_Mod([mt_b,mt_a,mt_c,mt_d,mt_e,mt_c])
mt_String_array = group_mod(["b", "a", "c","c","e","d"])

@testset "Group_mod" begin
    @test mt_String_array.m == Group_Mod_test.m
    @test Group_Mod_test_order.m == Group_Mod_test.m
    @test sum([mt_a mt_b mt_c mt_d mt_e]).m == Group_Mod_test.m
    @test (mt_a + mt_b).m == Group_Mod([mt_a,mt_b]).m
end

end