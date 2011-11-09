//
//  GreedyEye.h
//  greedy
//
//  Created by Richard Owen on 22/10/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "cocos2d.h"
#import "SpaceManagerCocos2d.h"


#define DEBUG_EYE false

@interface GreedyEye : CCNode {
    cpShapeNode  *_eyeBall;
    cpShape *_iris[16];
}

@end
