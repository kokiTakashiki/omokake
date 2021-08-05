//
//  shader.metal
//  omokake02
//
//  Created by takasiki on 10/6/1 R.
//  Copyright © 1 Reiwa takasiki. All rights reserved.
//

#include <metal_stdlib>
#import <metal_atomic>
using namespace metal;

typedef struct {
    float2 startPosition;
    float2 position;
    float direction;
    float directionRange;
    float interactionRange;
    float4 color;
    float size;
    float2 frame;
    float speed;
    float speedY;
} Particle;

kernel void perticleCompute(device Particle *particles [[buffer(0)]],
                    constant uint& particlesCount [[ buffer(1) ]],
                    const device float& timer [[ buffer(2) ]],
                    const device float2& pressureP [[ buffer(3) ]],
                    const device float2& pressureEndP [[ buffer(4) ]],
                    const device float& touchEndBool [[ buffer(5) ]],
                    uint id [[thread_position_in_grid]]) {
    if (id >= particlesCount) {
        return;
    }
    Particle particle = particles[id];
    float xVelocity = particle.speed * cos(particle.direction + timer*0.25);
    float yVelocity = abs(particle.speed * particle.speedY); //* sin(particle.direction + timer) ;
    if (particles[id].position.x < particles[id].startPosition.x - particle.frame.x/2 || particles[id].position.x > particles[id].startPosition.x + particle.frame.x/2){
        particles[id].position.x = particles[id].startPosition.x - xVelocity*0.5;
    }
    if (particles[id].position.y < particles[id].startPosition.y - particle.frame.y/2 || particles[id].position.y > particles[id].startPosition.y + particle.frame.y){
        particles[id].position.y = particles[id].startPosition.y + 0.01;
    }
//    particles[id].position.x += xVelocity;
//    particles[id].position.y += yVelocity;
    
//    float ExpXv = 5 * cos(particle.direction + particle.directionRange);
//    float ExpYv = 5 * sin(particle.direction + particle.directionRange);
    
    float preXv = pressureP.x;
    float preYv = pressureP.y;
    float vx = preXv - particles[id].position.x;
    float vy = preYv - particles[id].position.y;
    //
    float lengthSquared = (vx*vx + vy*vy);
    // 純粋な長さを求める
    float len = sqrt(lengthSquared);
    if(len < 120.0){
        // 正規化(ベクトルの長さを 1 にする)
        vx /= len;
        vy /= len;
        if(preXv != 0.0){
            particles[id].position.x += vx*abs(particle.speed + 2.0);
            particles[id].position.y += vy*abs(particle.speed + 5.0);
        }
    }
    
    float endXv = pressureEndP.x;
    float endYv = pressureEndP.y;
    float evx = endXv - particles[id].position.x;
    float evy = endYv - particles[id].position.y;
    //
    float EndlengthSquared = (evx*evx + evy*evy);
    // 純粋な長さを求める
    float Endlen = sqrt(EndlengthSquared);
    
    if(touchEndBool == 1.0){
        if(Endlen < 160.0){
            // 正規化(ベクトルの長さを 1 にする)
            evx /= Endlen;
            evy /= Endlen;
            particles[id].position.x += 3 * cos(particle.direction + particle.directionRange + particle.interactionRange);//vx*abs(particle.speed + 2.0);
            particles[id].position.y -= 3 * sin(particle.direction + particle.directionRange + particle.interactionRange);//vy*abs(particle.speed + 5.0);
            if(endXv != 0.0){
                
            }
        }
    }
    
    
    particles[id].position.x += xVelocity;
    particles[id].position.y += yVelocity;
    
    
}

struct VertexOut {
    float4 position   [[ position ]];
    float  point_size [[ point_size ]];
    float4 color;
};


vertex VertexOut vertexTransform(constant float2 &size [[buffer(0)]],
                                 device Particle *particles [[buffer(1)]],
                                 constant float2 &setParticlePosition [[ buffer(2) ]],
                                 const device float& customSize [[ buffer(3) ]],
                                 uint iid [[instance_id]]) {
    VertexOut out;
    float2 position = particles[iid].position + setParticlePosition;
    out.position.xy = position.xy / size * 2.0 - 1.0;
    out.position.z = 0;
    out.position.w = 1;
    out.point_size = customSize; //particles[iid].size; //* particles[instance].scale;
    out.color = particles[iid].color;
    return out;
}

fragment float4 fragmentShader(VertexOut in [[ stage_in ]],
                                  texture2d<float> particleTexture [[ texture(0) ]],
                                  float2 point [[ point_coord ]]) {
    constexpr sampler default_sampler;
    //テクスチャ情報
    float4 color = particleTexture.sample(default_sampler, point);
    color = float4(color.xyz, 1.0);
    color *= in.color;
    return color;
}
