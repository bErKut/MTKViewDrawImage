//
//  ViewController.m
//  MetalViewExperiments
//
//  Created by Vlad Berkuta on 08/11/15.
//  Copyright © 2015 Vlad Berkuta. All rights reserved.
//

#import "ViewController.h"
#import <MetalKit/MetalKit.h>
#import "MetalView.h"

@interface ViewController ()

@property (nonatomic, strong) MetalView *metalView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.metalView = (MetalView *)self.view;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"testImage"
                                                     ofType:@"jpg"];
    MTKTextureLoader *loader = [[MTKTextureLoader alloc] initWithDevice:self.metalView.device];
    NSError *err = nil;
    self.metalView.texture = [loader newTextureWithContentsOfURL:[NSURL fileURLWithPath:path] options:nil error:&err];
    if (err) NSLog(@"newTextureWithContentsOfURL err: %@", [err localizedDescription]);
}

- (void)viewDidLayoutSubviews
{
    [self.metalView draw];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end
