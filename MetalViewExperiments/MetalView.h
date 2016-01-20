//
//  MetalView.h
//  MetalViewExperiments
//
//  Created by Vlad Berkuta on 15/11/15.
//  Copyright © 2015 Vlad Berkuta. All rights reserved.
//

#import <MetalKit/MetalKit.h>

@interface MetalView : MTKView

@property (nonatomic, strong) id <MTLTexture> texture;

@end
