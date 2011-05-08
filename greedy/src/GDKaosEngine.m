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
  
  return self;
}

- (BOOL) hasRoom
{
  CGFloat worldArea = _worldSize.width * _worldSize.height;
  return (_currentArea / worldArea) * 100 < _density;
}

- (void) addArea:(CGFloat)area
{
  _currentArea += area;
}

- (CGPoint) position
{
  int x = (int)_worldSize.width;
  int y = (int)_worldSize.height;
  CGPoint position = ccp(arc4random() % x, arc4random() % y);
  
  NSLog(@"kaos engine position: (x => %f, y => %f)", position.x, position.y);
  return position;
}

@end