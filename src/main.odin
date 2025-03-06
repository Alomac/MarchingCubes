package main

import "core:fmt"
import "core:c"
import "vendor:raylib"

foreign import "perlin.c"

CubeMarcher :: struct{
    width : i32,
    height :i32,

    noiseResolution : f32,

    showNoise : bool,
    heights : []f32,
}

CM_setHeights :: proc(self:^CubeMarcher){
    self.heights = {f32(self.width + 1), f32(self.height + 1), f32(self.width + 1)}

    for x:i32=0; x < self.width + 1; x += 1{
        for y:i32=0; y < self.height + 1; y+= 1{
            for z:i32=0; z < self.width + 1; z+=1{
                currentHeight: f32 = perlin_2d(x * self.noiseResolution, z * self.noiseResolution)
            }
        }
    }
}

main :: proc(){
    fmt.print("MARCHING CUBES!!")
}
