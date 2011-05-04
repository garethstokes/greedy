//
//  GreedyGameScene.h
//  greedy
//
//  Created by gareth stokes on 4/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GreedyGameLayer.h"

@interface GreedyGameScene : CCScene {
    GreedyGameLayer *_gameLayer;
}

@property (nonatomic, retain) GreedyGameLayer *layer;
+ (id) scene;

@end
