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

    encoded = canonical_bigint_bytes(big"256")
    @test bytes2hex(encoded) == "0100000000000000020100"
end

@testset "oracle comparison is explicit" begin
    expected = canonical_bigint_bytes(big"-1000000001")
    @test compare_bytes(copy(expected), expected) == agrees

    corrupted = copy(expected)
    corrupted[end] ⊻= 0x01
    @test compare_bytes(corrupted, expected) == disagrees
end

@testset "registry entries fail closed" begin
    entry = Dict{String, Any}(
        "schema" => "julia-oracle-entry/v1",
        "oracle_id" => "finite-integer.bigz.canonical-bytes",
        "version" => "0.1.0",
        "domain_repository" => "larsbx/finite-math-kernels",
        "claim_id" => "bigz-canonical-bytes",
        "checker_repository" => "larsbx/finite-math-kernels",
        "boundary_id" => "shared-finite-kernel",
        "exactness" => "exact",
        "result_vocabulary" => ["agrees", "disagrees", "inconclusive", "oracle_error"],
        "julia_compat" => "1.11",
    )
    @test validate_registry_entry(entry)

    unknown_critical = copy(entry)
    unknown_critical["acceptance_authority"] = true
    @test !validate_registry_entry(unknown_critical)

    missing_checker = copy(entry)
    delete!(missing_checker, "checker_repository")
    @test !validate_registry_entry(missing_checker)

    expanded_vocabulary = copy(entry)
    expanded_vocabulary["result_vocabulary"] = [
        "agrees", "disagrees", "inconclusive", "oracle_error", "accepted",
    ]
    @test !validate_registry_entry(expanded_vocabulary)
end

@testset "exact arithmetic transcript oracle" begin
    oracle = JuliaOracleLab.ExactArithmeticOracle
    @test oracle.encode_z_token(big"0") == "0.0.0.0.0.0.0.0.0"
    @test oracle.encode_z_token(big"-1000000001") ==
        "2.0.0.0.0.0.0.0.4.59.154.202.1"
    @test oracle.encode_q_token(big"-2" // big"4") ==
        "2.0.0.0.0.0.0.0.1.1.1.0.0.0.0.0.0.0.1.2"

    transcript = oracle.expected_lines()
    @test length(transcript) == 1 + oracle.Z_CASES + oracle.Q_CASES + 1
    @test isempty(oracle.compare_transcript(transcript))

    corrupted = copy(transcript)
    tokens = split(corrupted[2])
    tokens[5] = "0.0.0.0.0.0.0.0.0"
    corrupted[2] = join(tokens, " ")
    @test !isempty(oracle.compare_transcript(corrupted))
end
