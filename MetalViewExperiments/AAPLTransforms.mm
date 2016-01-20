/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Utility methods for linear transformations of projective
  geometry of the left-handed coordinate system.
 */

#pragma mark -
#pragma mark Private - Headers

#import <cmath>
#import <iostream>

#import "AAPLTransforms.h"

#pragma mark -
#pragma mark Private - Constants

static const float kPi_f      = float(M_PI);
static const float k1Div180_f = 1.0f / 180.0f;
static const float kRadians_f = k1Div180_f * kPi_f;

#pragma mark -
#pragma mark Private - Utilities

float AAPL::Math::radians(const float& degrees)
{
    return kRadians_f * degrees;
} // radians

#pragma mark -
#pragma mark Public - Transformations - Translate

simd::float4x4 AAPL::Math::translate(const simd::float3& t)
{
    simd::float4x4 M = matrix_identity_float4x4;
    
    M.columns[3].xyz = t;
    
    return M;
} // translate

simd::float4x4 AAPL::Math::translate(const float& x,
                                     const float& y,
                                     const float& z)
{
    return AAPL::Math::translate((simd::float3){x,y,z});
} // translate

#pragma mark -
#pragma mark Public - Transformations - LookAt

simd::float4x4 AAPL::Math::lookAt(const simd::float3& eye,
                                  const simd::float3& center,
                                  const simd::float3& up)
{
    simd::float3 E = -eye;
    simd::float3 N = simd::normalize(center + E);
    simd::float3 U = simd::normalize(simd::cross(up, N));
    simd::float3 V = simd::cross(N, U);
    
    simd::float4 P = 0.0f;
    simd::float4 Q = 0.0f;
    simd::float4 R = 0.0f;
    simd::float4 S = 0.0f;
    
    P.x = U.x;
    P.y = V.x;
    P.z = N.x;
    
    Q.x = U.y;
    Q.y = V.y;
    Q.z = N.y;
    
    R.x = U.z;
    R.y = V.z;
    R.z = N.z;
    
    S.x = simd::dot(U, E);
    S.y = simd::dot(V, E);
    S.z = simd::dot(N, E);
    S.w = 1.0f;
    
    return simd::float4x4(P, Q, R, S);
} // lookAt

#pragma mark -
#pragma mark Public - Transformations - frustum

simd::float4x4 AAPL::Math::frustum_oc(const float& left,
                                      const float& right,
                                      const float& bottom,
                                      const float& top,
                                      const float& near,
                                      const float& far)
{
    float sWidth  = 1.0f / (right - left);
    float sHeight = 1.0f / (top   - bottom);
    float sDepth  = far  / (far   - near);
    float dNear   = 2.0f * near;
    
    simd::float4 P = 0.0f;
    simd::float4 Q = 0.0f;
    simd::float4 R = 0.0f;
    simd::float4 S = 0.0f;
    
    P.x =  dNear * sWidth;
    Q.y =  dNear * sHeight;
    R.x = -sWidth  * (right + left);
    R.y = -sHeight * (top   + bottom);
    R.z =  sDepth;
    R.w =  1.0f;
    S.z = -sDepth * near;
    
    return simd::float4x4(P, Q, R, S);
} // frustum_oc
