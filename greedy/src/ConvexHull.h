//
//  ConvexHull.h
//  greedy
//
//  Created by gareth stokes on 8/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//
#import "cocos2d.h"

@interface ConvexHull : CCNode {
  NSArray *_points;
  int _size;
}

- (id) initWithStaticSize:(int)size;
- (CGFloat) area;
- (NSArray *) points;
- (int) size;

@end
