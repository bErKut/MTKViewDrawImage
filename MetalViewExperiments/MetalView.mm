//
//  MetalView.m
//  MetalViewExperiments
//
//  Created by Vlad Berkuta on 15/11/15.
//  Copyright © 2015 Vlad Berkuta. All rights reserved.
//

#import "MetalView.h"
#import "AAPLTransforms.h"

static const uint32_t kCntQuadTexCoords = 6;
static const uint32_t kSzQuadTexCoords  = kCntQuadTexCoords * sizeof(simd::float2);

static const uint32_t kCntQuadVertices = kCntQuadTexCoords;
static const uint32_t kSzQuadVertices  = kCntQuadVertices * sizeof(simd::float4);

static const simd::float4 kQuadVertices[kCntQuadVertices] =
{
    { -1.0f,  -1.0f, 0.0f, 1.0f },
    {  1.0f,  -1.0f, 0.0f, 1.0f },
    { -1.0f,   1.0f, 0.0f, 1.0f },
    
    {  1.0f,  -1.0f, 0.0f, 1.0f },
    { -1.0f,   1.0f, 0.0f, 1.0f },
    {  1.0f,   1.0f, 0.0f, 1.0f }
};

static const simd::float2 kQuadTexCoords[kCntQuadTexCoords] =
{
    { 0.0f, 0.0f },
    { 1.0f, 0.0f },
    { 0.0f, 1.0f },
    
    { 1.0f, 0.0f },
    { 0.0f, 1.0f },
    { 1.0f, 1.0f }
};

@interface MetalView()

@property (nonatomic, strong) id <MTLCommandQueue> commandQueue;
@property (nonatomic, strong) id <MTLRenderPipelineState> pipelineState;

@property (nonatomic, strong) id <MTLBuffer> vertexBuffer;
@property (nonatomic, strong) id <MTLBuffer> texCoordBuffer;

@end


@implementation MetalView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder])
    {
        [self configure];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self configure];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frameRect device:(id<MTLDevice>)device
{
    if (self = [super initWithFrame:frameRect device:device])
    {
        [self configure];
    }
    
    return self;
}

- (void)configure
{
    self.device = MTLCreateSystemDefaultDevice();
    self.colorPixelFormat = MTLPixelFormatBGRA8Unorm;
    self.framebufferOnly = YES;
    self.sampleCount = 1;
    
    // create command queue for usage during drawing
    self.commandQueue = [self.device newCommandQueue];
    
    // load shaders functions from texturedQuad.metal file. These functions needed for configuration of MTLRenderPipelineDescriptor
    id <MTLLibrary> shaderLibrary = [self.device newDefaultLibrary];
    id <MTLFunction> fragmentProgram = [shaderLibrary newFunctionWithName:@"texturedQuadFragment"];
    id <MTLFunction> vertexProgram = [shaderLibrary newFunctionWithName:@"texturedQuadVertex"];

    //  create a pipeline state
    MTLRenderPipelineDescriptor *pQuadPipelineStateDescriptor = [MTLRenderPipelineDescriptor new];
    pQuadPipelineStateDescriptor.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
    pQuadPipelineStateDescriptor.sampleCount      = self.sampleCount;
    pQuadPipelineStateDescriptor.vertexFunction   = vertexProgram;
    pQuadPipelineStateDescriptor.fragmentFunction = fragmentProgram;
    NSError *pipErr = nil;
    self.pipelineState = [self.device newRenderPipelineStateWithDescriptor:pQuadPipelineStateDescriptor
                                                                     error:&pipErr];

    if (pipErr) NSLog(@"newRenderPipelineStateWithDescriptor err: %@", pipErr);
    
    // buffers for MTLRenderCommandEncoder in drawRect: method
    self.vertexBuffer = [self.device newBufferWithBytes:kQuadVertices
                                                 length:kSzQuadVertices
                                                options:MTLResourceOptionCPUCacheModeDefault];
    
    self.texCoordBuffer = [self.device newBufferWithBytes:kQuadTexCoords
                                                   length:kSzQuadTexCoords
                                                  options:MTLResourceOptionCPUCacheModeDefault];
    
    self.paused = YES;
    self.enableSetNeedsDisplay = NO;
}

- (void)drawRect:(CGRect)rect
{
    id <MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    MTLRenderPassDescriptor *renderPassDescriptor = self.currentRenderPassDescriptor;
    
    id <MTLRenderCommandEncoder>  renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
    // Encode into a renderer
    [renderEncoder setRenderPipelineState:self.pipelineState];
    
    [renderEncoder setVertexBuffer:self.vertexBuffer
                            offset:0
                           atIndex:0];
    
    [renderEncoder setVertexBuffer:self.texCoordBuffer
                            offset:0
                           atIndex:1];
    
    [renderEncoder setFragmentTexture:self.texture
                              atIndex:0];
    
    // tell the render context we want to draw our primitives. We will draw triangles that's
    // why we need kQuadVertices and kQuadTexCoords (arrays of points)
    [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
                      vertexStart:0
                      vertexCount:6
                    instanceCount:1];
    
    [renderEncoder endEncoding];
    [commandBuffer presentDrawable:self.currentDrawable];
    [commandBuffer commit];
}

@end
