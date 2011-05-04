//
//  GreedyGameScene.m
//  greedy
//
//  Created by gareth stokes on 4/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "GreedyGameScene.h"

@implementation GreedyGameScene

@synthesize layer=_layer;

+ (id) scene
{
    GreedyGameScene *scene = [GreedyGameScene node];
    
    scene.layer = [[GreedyGameLayer alloc] init];
    [scene addChild:scene.layer z:5];
    
    return scene;
}

@end
