//
//  GDKaosEngine.m
//  lander_randomlevel
//
//  Created by gareth stokes on 6/04/11.
//  Copyright 2011 digital five. All rights reserved.
//

#import "GDKaosEngine.h"
#import "chipmunk.h"

@implementation GDKaosEngine

- (id) initWorldSize:(CGSize)worldSize withDensity:(CGFloat)density
{
  // return nil if the super class failes to initialise
  if (!(self=[super init])) return nil;
  
  if (density > 50) density = 50;
  if (density < 0) density = 0;
  
  _density = density;
  _currentArea = 0;
  _worldSize = worldSize;
  _radius = 0;
  _worldArea = _worldSize.width * _worldSize.height;
  
  return self;
}

- (id) initWorldSizeCircle:(int)worldRadius withDensity:(CGFloat)density
{
  // return nil if the super class failes to initialise
  if (!(self=[super init])) return nil;
  
  if (density > 50) density = 50;
  if (density < 0) density = 0;
  
  _density = density;
  _currentArea = 0; 
  //_worldSize = CGPointZero;
  _radius = worldRadius;
  _worldArea = 3.1476 * _radius * _radius;
  
  return self;
}
- (BOOL) hasRoom
{
  return (_currentArea / _worldArea) * 100 < _density;
}

- (void) addArea:(CGFloat)area
{
  _currentArea += area;
}

- (CGPoint) position
{
  if(_radius == 0){
    int x = (int)_worldSize.width;
    int y = (int)_worldSize.height;
    CGPoint position = ccp(arc4random() % x, arc4random() % y);
    return position;
  } else {
    
    int radius = arc4random() % _radius;
    int angle = arc4random() % 360;
    
    int randX = radius * cos( CC_DEGREES_TO_RADIANS(angle) );
    int randY = radius * sin( CC_DEGREES_TO_RADIANS(angle) );
    
    CGPoint position = ccp(randX, randY);
    
    return position;
  }
}

@end