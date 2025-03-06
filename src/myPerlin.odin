package main

import "core:math"

permutation_table: [512]u8

// Fade function for smoothing
fade :: proc(t: f32) -> f32 {
    return t * t * t * (t * (t * 6 - 15) + 10)
}

// Linear interpolation
lerp :: proc(a, b, t: f32) -> f32 {
    return a + t * (b - a)
}

// Compute dot product of a pseudo-random gradient and distance vector
grad :: proc(hash: u8, x, y: f32) -> f32 {
    h := hash & 3
    u: f32
    v: f32

    if h == 0 || h == 2 {
        u = x
    } else {
        u = y
    }

    if h == 0 || h == 1 {
        v = y
    } else {
        v = -x
    }

    return u + v
}



// Generate Perlin noise at (x, y)
perlin_2d :: proc(x, y: f32) -> f32 {
    X: u8 = u8(math.floor(x)) & 255
    Y: u8 = u8(math.floor(y)) & 255
    
    x -= math.floor(x)
    y -= math.floor(y)
    
    u: f32 = fade(x)
    v: f32 = fade(y)
    
    A  := permutation_table[X] + Y
    B  := permutation_table[X + 1] + Y
    
    return lerp(
        lerp(grad(permutation_table[A], x, y), grad(permutation_table[B], x - 1, y), u),
        lerp(grad(permutation_table[A + 1], x, y - 1), grad(permutation_table[B + 1], x - 1, y - 1), u),
        v
    )
}

// Initialize permutation table (repeat for overflow handling)
init_perlin :: proc() {
    base_perm := [256]u8{151,160,137,91,90,15, // Predefined permutation
        131,13,201,95,96,53, // ... fill the rest
        235,39,17, // truncated for brevity
    }

    for i := 0; i < 256; i += 1 {
        permutation_table[i] = base_perm[i]
        permutation_table[i + 256] = base_perm[i]
    }
}

main :: proc() {
    init_perlin()

    noise_value := perlin_2d(10.5, 42.7)
    println("Perlin Noise at (10.5, 42.7): {}", noise_value)
}
