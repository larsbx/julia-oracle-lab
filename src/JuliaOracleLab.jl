module JuliaOracleLab

export OracleOutcome, agrees, disagrees, inconclusive, oracle_error
export OracleBinding, validate_binding

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
    all(!isempty, fields) || return false
    binding.exactness in ALLOWED_EXACTNESS || return false
    return true
end

end
