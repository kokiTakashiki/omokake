//
//  ShaderTypes.h
//  OmokakeWindowApp
//
//  Created by takedatakashiki on 2025/08/23.
//

#ifndef ShaderTypes_h
#define ShaderTypes_h

#import <simd/simd.h>

typedef enum BufferBindingIndex
{
    BufferBindingIndexForVertexData = 0,
    BufferBindingIndexForViewportSize = 1,
} BufferBindingIndex;

typedef enum TextureBindingIndex
{
    ComputeTextureBindingIndexForColorImage = 0,
    ComputeTextureBindingIndexForGrayscaleImage = 1,
    RenderTextureBindingIndex = 0,
} TextureBindingIndex;

typedef struct VertexData
{
    simd_float2 position;
    simd_float2 textureCoordinate;
} VertexData;

#endif /* ShaderTypes_h */
