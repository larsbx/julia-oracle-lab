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
        "finite-integer.bigz.canonical-bytes",
        v"0.1.0",
        "larsbx/finite-math-kernels",
        "bigz-canonical-bytes",
        "larsbx/finite-math-kernels",
        "shared-finite-kernel",
        :exact,
    )
    @test validate_binding(valid)

    missing_checker = OracleBinding(
        "finite-integer.bigz.canonical-bytes", v"0.1.0",
        "larsbx/finite-math-kernels", "bigz-canonical-bytes", "",
        "shared-finite-kernel", :exact,
    )
    @test !validate_binding(missing_checker)
end

@testset "canonical BigInt golden vectors" begin
    @test bytes2hex(canonical_bigint_bytes(big"0")) == "000000000000000000"
    @test bytes2hex(canonical_bigint_bytes(big"1")) == "01000000000000000101"
    @test bytes2hex(canonical_bigint_bytes(big"-1000000001")) == "0200000000000000043b9aca01"

    # Minimal magnitude: no leading zero byte.
    encoded = canonical_bigint_bytes(big"256")
    @test bytes2hex(encoded) == "0100000000000000020100"
end
