//
//  GameObject.h
//  greedy
//
//  Created by gareth stokes on 7/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
// 
//  Original source from Richard Owen (suck it!)
//
//

#import "cocos2d.h"
#import "chipmunk.h"

@protocol GameObject
- (void) step:(ccTime) delta;
- (void) draw:(cpShape *)shape;
@end