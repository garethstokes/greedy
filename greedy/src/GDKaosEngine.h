//
//  GDKaosEngine.h
//  lander_randomlevel
//
//  Created by gareth stokes on 6/04/11.
//  Copyright 2011 digital five. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GDKaosEngine : CCNode {
  CGFloat  _density;
  CGSize   _worldSize;
  CGFloat  _currentArea;
  int      _radius;
  float    _worldArea;
}

- (id) initWorldSize:(CGSize) worldSize withDensity:(CGFloat)density;
- (id) initWorldSizeCircle:(int)worldRadius withDensity:(CGFloat)density;
- (BOOL) hasRoom;
- (void) addArea:(CGFloat)area;
- (CGPoint) position;
@end
