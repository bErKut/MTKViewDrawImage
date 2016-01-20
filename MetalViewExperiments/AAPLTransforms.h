/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Utility methods for linear transformations of projective
  geometry of the left-handed coordinate system.
 */

#ifndef _AAPL_MATH_TRANSFORMS_H_
#define _AAPL_MATH_TRANSFORMS_H_

#import <simd/simd.h>

#ifdef __cplusplus

namespace AAPL
{
    namespace Math
    {
        float radians(const float& degrees);
        
        simd::float4x4 translate(const float& x,
                                 const float& y,
                                 const float& z);
        
        simd::float4x4 translate(const simd::float3& t);
        
        simd::float4x4 frustum_oc(const float& left,
                                  const float& right,
                                  const float& bottom,
                                  const float& top,
                                  const float& near,
                                  const float& far);
        
        simd::float4x4 lookAt(const simd::float3& eye,
                              const simd::float3& center,
                              const simd::float3& up);
    } // Math
} // AAPL

#endif

#endif
