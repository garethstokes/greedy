//
//  ConvexHull.m
//  greedy
//
//  Created by gareth stokes on 8/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "ConvexHull.h"
#import "cocos2d.h"
#import "chipmunk.h"

@implementation ConvexHull

const int SKIN_WIDTH = 250;
const int SKIN_HEIGHT = 250;

const int POINTS_PER_QUADRANT = 9;
const int SIZE_SMALL = 30;
const int SIZE_MEDIUM = 60;
const int SIZE_LARGE = 90;

int pointLocation(CGPoint A, CGPoint B, CGPoint P) {
  
  int cp1 = (B.x-A.x)*(P.y-A.y) - (B.y-A.y)*(P.x-A.x);
  
  return (cp1>0)?1:-1;
}

int pointDistance(CGPoint A, CGPoint B, CGPoint C) {
  int ABx = B.x-A.x;
  int ABy = B.y-A.y;
  int num = ABx*(A.y-C.y)-ABy*(A.x-C.x);
  if (num < 0) num = -num;
  return num;
} 

void hullSet(CGPoint A, CGPoint B, NSMutableArray *set, NSMutableArray *hull) {
  int insertPosition = [hull indexOfObject:[NSValue valueWithCGPoint:B]];
  
  if ([set count] == 0) 
    return;
  
  if ([set count] == 1) {
    CGPoint p = [(NSValue *)[set objectAtIndex:0] CGPointValue];
    [set removeObjectAtIndex:0];
    [hull insertObject:[NSValue valueWithCGPoint:p] atIndex:insertPosition];
    return;
  }
  
  int dist = INT_MIN;
  int furthestPoint = -1;
  
  int i = 0;
  for (NSValue *val in set) {
    CGPoint p = [val CGPointValue];
    
    int adistance = pointDistance(A, B, p);
    
    
    if (adistance > dist) {
      dist = adistance;
      furthestPoint = i;
    }
    
    i++;
  }
  
  CGPoint P = [(NSValue *)[set objectAtIndex:furthestPoint] CGPointValue];
  [set removeObjectAtIndex:furthestPoint];
  [hull insertObject:[NSValue valueWithCGPoint:P] atIndex:insertPosition];
  
  // Determine who's to the left of AP
  NSMutableArray *leftSetAP = [[NSMutableArray alloc] init];
  i = 0;
  for (NSValue *val in set) {
    CGPoint M = [val CGPointValue];   
    if (pointLocation(A,P,M)==1) {
      [leftSetAP addObject:[NSValue valueWithCGPoint:M]];
    }
    i++;
  }
  
  // Determine who's to the left of PB
  NSMutableArray *leftSetPB = [[NSMutableArray alloc] init];
  i = 0;
  for (NSValue *val in set) {
    CGPoint M = [val CGPointValue];   
    if (pointLocation(P,B,M)==1) {
      [leftSetPB addObject:[NSValue valueWithCGPoint:M]];
    }
  }
  
  hullSet(A, P, leftSetAP, hull);
  hullSet(P, B, leftSetPB, hull);
}

NSMutableArray *quickHull(NSMutableArray *points) 
{
  NSMutableArray *convexHull = [[NSMutableArray alloc] init];
  
  //If we have less then 3 points this is a no go
  if ([points count] < 3) 
    return points;
  
  // find extremals
  int minPoint = -1;
  int maxPoint = -1;
  int minX = INT_MAX;
  int maxX = INT_MIN;
  
  int i = 0;
  for (NSValue *val in points) {
    CGPoint p = [val CGPointValue];
    
    if (p.x < minX) {
      minX = p.x;
      minPoint = i;
    } 
    if (p.x > maxX) {
      maxX = p.x;
      maxPoint = i;       
    }
    i++;
  }
  
  CGPoint A = [(NSValue *)[points objectAtIndex:minPoint] CGPointValue];
  CGPoint B = [(NSValue *)[points objectAtIndex:maxPoint] CGPointValue];;
  
  [convexHull addObject:[NSValue valueWithCGPoint:A]];
  [convexHull addObject:[NSValue valueWithCGPoint:B]];
  
  [points removeObject:[NSValue valueWithCGPoint:A]];
  [points removeObject:[NSValue valueWithCGPoint:B]];
  
  NSMutableArray *leftSet  = [[NSMutableArray alloc] init];
  NSMutableArray *rightSet = [[NSMutableArray alloc] init];
  
  for (NSValue *val in points) {
    CGPoint p = [val CGPointValue];
    if (pointLocation(A,B,p) == -1)
      [leftSet addObject:[NSValue valueWithCGPoint:p]];
    else
      [rightSet addObject:[NSValue valueWithCGPoint:p]];
  }
  
  hullSet(A, B, rightSet, convexHull);
  hullSet(B, A, leftSet, convexHull);
  
  return convexHull;
}

void drawCubicBezier(CGPoint origin, CGPoint control1, CGPoint control2, CGPoint destination, int segments, CGPoint *vertices)
{
  //CGPoint vertices[segments + 1];
  
  float t = 0.0;
  for(int i = 0; i < segments; i++)
  {
    float x = pow(1 - t, 3) * origin.x + 3.0 * pow(1 - t, 2) * t * control1.x + 3.0 * (1 - t) * t * t * control2.x + t * t * t * destination.x;
    float y = pow(1 - t, 3) * origin.y + 3.0 * pow(1 - t, 2) * t * control1.y + 3.0 * (1 - t) * t * t * control2.y + t * t * t * destination.y;
    vertices[i] = CGPointMake(x, y);
    t += 1.0 / segments;
  }
  vertices[segments] = destination;
}

NSMutableArray *createAsteroidShape(int width, int height)
{
  NSMutableArray *points = [[NSMutableArray alloc] init];
  
  int halfWidth = width / 2;
  int halfHeight = height / 2;
  
  CGPoint q1, q2, q3, q4;
  
  for(int i = 0 ; i < POINTS_PER_QUADRANT; i ++){
    q1 = ccp(-(random() % halfWidth), random() % halfHeight);
    [points addObject:[NSValue valueWithCGPoint:q1]];
    
    q2 = ccp(random() % halfWidth, random() % halfHeight);
    [points addObject:[NSValue valueWithCGPoint:q2]];
    
    q3 = ccp(random() % halfWidth, -(random() % halfHeight));
    [points addObject:[NSValue valueWithCGPoint:q3]];
    
    q4 = ccp(-(random() % halfWidth), -(random() % halfHeight));
    [points addObject:[NSValue valueWithCGPoint:q4]];
  }
  
  return points; 
}

- (id) initWithStaticSize:(int)size;
{
  if(!(self = [super init])) return nil;
  
  //Create a convex hull for the points below
  int thisSize = 0;
  NSMutableArray *spriteHull;
  switch(size){
    case 0:
    case 1:
    case 2:
    case 3:
    case 4:
      thisSize = SIZE_SMALL;
      break;
    case 5:
    case 6:
    case 7:
      thisSize = SIZE_MEDIUM;
      break;
    case 8:
    case 9: thisSize = SIZE_LARGE;
      break;
    default:
      thisSize - SIZE_SMALL;
  }
  
  _size = thisSize;
  
  //Random gen points for asteroids
  spriteHull = createAsteroidShape(thisSize, thisSize);
  _points = quickHull(spriteHull);
  return self;
}

- (CGFloat) area
{
  int minx = 0;
  int miny = 0;
  int maxx = 0;
  int maxy = 0;
  int i = 0;
  
  for (NSValue *val in _points) {
    CGPoint x = [val CGPointValue];
    minx = (x.x < minx) ? x.x : minx;
    miny = (x.y < miny) ? x.y : miny;
    maxx = (x.x > maxx) ? x.x : maxx;
    maxy = (x.x > maxy) ? x.x : maxx;
    i++;
  }
  return (maxx - minx) * (maxy - miny);
}

- (NSArray *)points { return _points; }
- (int) size { return _size; }

@end
