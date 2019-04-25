"""
    ⊛(a::AbstractPeriodicInfiniteVector, b::AbstractPeriodicInfiniteVector)

The circular convoluation defined as \$c(n) = \\sum_{k=1}^N a(k)b(n-k)\$ for \$n\\in ℤ\$,
where `N` is the period of `a` and `b`.
"""
⊛(a, b) = circconv(a::AbstractPeriodicInfiniteVector, b::AbstractPeriodicInfiniteVector)

"""
    ⋆(a::InfiniteVector, b::InfiniteVector)

The convolution is defined as \$c(n) = \\sum_{k\\in ℤ} a(k)b(n-k)\$
"""
⋆(a, b) = conv(a, b)

"""
    *(a::InfiniteVector, b::InfiniteVector)

The convolution is defined as \$c(n) = \\sum_{k\\in ℤ} a(k)b(n-k)\$
"""
*(a::InfiniteVector, b::InfiniteVector) = conv(a, b)
*(a::AbstractPeriodicInfiniteVector, b::AbstractPeriodicInfiniteVector) = circconv(a, b)
*(a::AbstractPeriodicInfiniteVector, b::BiInfiniteVector) = conv(b, a)
*(a::BiInfiniteVector, b::AbstractPeriodicInfiniteVector) = conv(a, b)

conv(v1::AbstractPeriodicInfiniteVector, v2::Union{CompactInfiniteVector,FixedInfiniteVector}) =
    conv(v2, v1)

function conv(v1::Union{CompactInfiniteVector,FixedInfiniteVector}, v2::AbstractPeriodicInfiniteVector)
    r = conv(subvector(v1), subvector(v2))
    p = period(v2)
    v = zeros(eltype(r), p)
    for i in length(v)+1:length(r)
        r[mod(i-1, p)+1] += r[i]
    end
    PeriodicInfiniteVector(circshift(view(r, 1:length(v)), offset(v1)))
end

function PeriodicInfiniteVector(vec::Union{CompactInfiniteVector,FixedInfiniteVector}, N::Int)
    a = zeros(eltype(subvector(vec)), N)
    for i in eachnonzeroindex(vec)
        a[mod(i, N) + 1] += vec[i]
    end
    PeriodicInfiniteVector(a)
end
