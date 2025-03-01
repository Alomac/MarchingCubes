package main

import "vendor:raylib"

GridSize  :: 10
IsoValue  :: 25.0

// Function to generate a scalar field
// This one just uses a simple sphere equation: f(x, y, z) = x² + y² + z²
// It returns a float where values < IsoValue are "inside" the shape
scalar_field :: proc(x, y, z: f32) -> f32 {
    center :f32 = 5.0 // Place the center of the sphere at (5,5,5)
    dx := x - center
    dy := y - center
    dz := z - center
    return dx*dx + dy*dy + dz*dz
}

// get_cube_case :: proc(x, y, z: f32) -> u8 {
//     case_index: u8 = 0

//     corners :raylib.Vector3 = [
//         raylib.Vector3{x, y, z},
//         raylib.Vector3{x + 1, y, z},
//         raylib.Vector3{x, y + 1, z},
//         raylib.Vector3{x + 1, y + 1, z},
//         raylib.Vector3{x, y, z + 1},
//         raylib.Vector3{x + 1, y, z + 1},
//         raylib.Vector3{x, y + 1, z + 1},
//         raylib.Vector3{x + 1, y + 1, z + 1},
//     ]

//     for i := 0; i < 8; i += 1 {
//         if scalar_field(corners[i].x, corners[i].y, corners[i].z) < IsoValue {
//             case_index |= (1 << i) // Set bit i
//         }
//     }

//     return case_index
// }


main :: proc() {
    raylib.InitWindow(800, 600, "Marching Cubes Scalar Field Example")
    defer raylib.CloseWindow()

    cam : raylib.Camera3D = {
        position = raylib.Vector3{15, 15, 15},
        target = raylib.Vector3{5, 5, 5},
        up = raylib.Vector3{0, 1, 0},
        fovy = 45.0,
        projection = raylib.CameraProjection.PERSPECTIVE,
    }

    for !raylib.WindowShouldClose() {

        raylib.UpdateCamera(&cam, raylib.CameraMode.ORBITAL) // Allows moving the camera around

        raylib.BeginDrawing()
        raylib.ClearBackground(raylib.BLACK)
        raylib.BeginMode3D(cam)

        for z := 0; z < GridSize; z += 1 {
            for y := 0; y < GridSize; y += 1 {
                for x := 0; x < GridSize; x += 1 {
                    val := scalar_field(f32(x), f32(y), f32(z))
    
                    if val < IsoValue {
                        // In a real implementation, you'd store this information
                        raylib.DrawCubeV(raylib.Vector3{f32(x), f32(y), f32(z)}, raylib.Vector3{0.2, 0.2, 0.2}, raylib.GREEN)
                    }
                }
            }
        }

        raylib.EndMode3D()
        raylib.EndDrawing()
    }
}
