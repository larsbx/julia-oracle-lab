module JuliaOracleLab

export OracleOutcome, agrees, disagrees, inconclusive, oracle_error
export OracleBinding, validate_binding
export canonical_bigint_bytes

@enum OracleOutcome agrees disagrees inconclusive oracle_error

struct OracleBinding
    oracle_id::String
    version::VersionNumber
    domain_repository::String
    claim_id::String
    checker_repository::String
    boundary_id::String
    exactness::Symbol
end

const ALLOWED_EXACTNESS = Set((:exact, :interval, :numerical, :mixed))

function validate_binding(binding::OracleBinding)::Bool
    fields = (
        binding.oracle_id,
        binding.domain_repository,
        binding.claim_id,
        binding.checker_repository,
        binding.boundary_id,
    )
    all(value -> !isempty(value), fields) || return false
    binding.exactness in ALLOWED_EXACTNESS || return false
    return true
end

function canonical_bigint_bytes(value::Integer)::Vector{UInt8}
    sign_byte = value == 0 ? UInt8(0) : value > 0 ? UInt8(1) : UInt8(2)
    magnitude = abs(big(value))
    magnitude_bytes = UInt8[]
    while magnitude != 0
        magnitude, remainder = divrem(magnitude, 256)
        push!(magnitude_bytes, UInt8(remainder))
    end
    reverse!(magnitude_bytes)

    byte_len = UInt64(length(magnitude_bytes))
    result = UInt8[sign_byte]
    for shift in 56:-8:0
        push!(result, UInt8((byte_len >> shift) & 0xff))
    end
    append!(result, magnitude_bytes)
    return result
end

end
