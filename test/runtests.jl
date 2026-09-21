using Test
using JuliaOracleLab

@testset "authority-safe result vocabulary" begin
    @test Set(instances(OracleOutcome)) == Set((agrees, disagrees, inconclusive, oracle_error))
    @test !(:accepted in propertynames(JuliaOracleLab))
    @test !(:proved in propertynames(JuliaOracleLab))
    @test !(:authorized in propertynames(JuliaOracleLab))
end

@testset "checker binding is mandatory" begin
    valid = OracleBinding(
        "nlap.bigz.roundtrip",
        v"0.1.0",
        "larsbx/NLAP-JT",
        "bigz-canonical-roundtrip",
        "larsbx/NLAP-JT",
        "finite-certificate-replay",
        :exact,
    )
    @test validate_binding(valid)

    missing_checker = OracleBinding(
        "nlap.bigz.roundtrip", v"0.1.0", "larsbx/NLAP-JT",
        "bigz-canonical-roundtrip", "", "finite-certificate-replay", :exact,
    )
    @test !validate_binding(missing_checker)
end
