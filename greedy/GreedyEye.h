//
//  GreedyEye.h
//  greedy
//
//  Created by Richard Owen on 22/10/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "cocos2d.h"
#import "SpaceManagerCocos2d.h"

@interface GreedyEye : cpShapeNode {
    cpShape *_iris[16];
    cpShape *_irisBoundingCircle;
}

@end
