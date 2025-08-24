//
//  Shaders.metal
//  OmokakeWindowApp
//
//  Created by takedatakashiki on 2025/08/23.
//

#include <metal_stdlib>

#import "../include/ShaderTypes.h"

using namespace metal;

struct RasterizerData
{
    float4 position [[position]];
    float2 textureCoordinate;
};

vertex RasterizerData
vertexShader(uint                   vertexID              [[ vertex_id ]],
             constant VertexData    *vertexArray          [[ buffer(BufferBindingIndexForVertexData) ]],
             constant simd_uint2    *viewportSizePointer  [[ buffer(BufferBindingIndexForViewportSize) ]])

{
    RasterizerData out;
    simd_float2 pixelSpacePosition = vertexArray[vertexID].position.xy;
    simd_float2 viewportSize = simd_float2(*viewportSizePointer);
    out.position.xy = pixelSpacePosition / (viewportSize / 2.0);
    out.position.z = 0.0;
    out.position.w = 1.0;
    out.textureCoordinate = vertexArray[vertexID].textureCoordinate;
    
    return out;
}

fragment float4 samplingShader(RasterizerData  in           [[stage_in]],
                               texture2d<half> colorTexture [[ texture(RenderTextureBindingIndex) ]])
{
    constexpr sampler textureSampler (mag_filter::linear,
                                      min_filter::linear);
    
    const half4 colorSample = colorTexture.sample (textureSampler, in.textureCoordinate);
    
    return (simd_float4)(colorSample);
}

constant half3 kRec709LumaCoefficients = half3(0.2126, 0.7152, 0.0722);

kernel void
convertToGrayscale(texture2d<half, access::read>  inTexture  [[texture(ComputeTextureBindingIndexForColorImage)]],
                   texture2d<half, access::write> outTexture [[texture(ComputeTextureBindingIndexForGrayscaleImage)]],
                   uint2                          gridId     [[thread_position_in_grid]])
{
    if ((gridId.x >= outTexture.get_width()) ||
        (gridId.y >= outTexture.get_height()))
    {
        return;
    }
    
    half4 colorValue  = inTexture.read(gridId);
    
    half grayValue = dot(colorValue.rgb, kRec709LumaCoefficients);
    
    outTexture.write(half4(grayValue, grayValue, grayValue, 1.0), gridId);
}
