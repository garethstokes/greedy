//
//  Asteroid.m
//  greedy
//
//  Created by gareth stokes on 8/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "Asteroid.h"
#import "ConvexHull.h"
#import "chipmunk.h"
#import "GameObjectCache.h"

@implementation Asteroid

@synthesize shape=_shape;

//- (id) initWithEnvironment:(GameEnvironment *)environment 
//                 withLayer:(cpLayers)withLayer 
//                  withSize:(float) size 
//              withPosition:(cpVect) withPosition
//{
//    if(!(self = [super init])) return nil;
//    
//    
//    _shape = [environment.manager 
//              addPolyAt:withPosition
//              mass:(size == 100 ? 1000000 : _mass)
//              rotation:CCRANDOM_0_1()
//              points:[_convexHull points]];
//    
//    _shape->layers = withLayer;
//    _shape->collision_type = kAsteroidCollisionType;
//    
//    // push it in a random direction.
//    if(withLayer == LAYER_BACKGROUND || size > 99)
//    {
//        cpBodySleep(_shape->body);
//    }else{
//        /*
//         CGPoint p = rand() % 2 == 0 ? ccp(CCRANDOM_0_1(),CCRANDOM_0_1()) : ccpNeg(ccp(CCRANDOM_0_1(),CCRANDOM_0_1()));
//         cpBodyApplyImpulse(_shape->body, 
//         p, 
//         ccp(rand() % 10000, rand() % 10000));
//         */
//    };
//    
//    //    cpCCSprite *sprite = [[AsteroidSprite alloc] initWithPoints:[_convexHull points] 
//    //                                                           size:[_convexHull size] 
//    //                                                      withShape:_shape
//    //                                                   isBackground:(withLayer == LAYER_BACKGROUND)];
//    //    
//    //[self addChild:sprite];  
//    //[sprite release];
//    
//    return self;
//}

-(void) createAsteroid:(float) radius
{
    ConvexHull *_convexHull = [[[ConvexHull alloc] initWithStaticSize:_size] autorelease];
    _area = [_convexHull area];
    
    vertexCount = [[_convexHull points] count] + 2;
    
    fan = (ccV2F_T2F *)malloc(sizeof(ccV2F_T2F) * vertexCount);
    
    //center point
    fan[0].vertices.x = 0;
    fan[0].vertices.y = 0;
    fan[0].texCoords.u = 0.5;
    fan[0].texCoords.v = 0.5;
    //CCLOG(@"fan[%d] x:%f y:%f u:%f v:%f", 0, fan[0].vertices.x, fan[0].vertices.y, fan[0].texCoords.u , fan[0].texCoords.v );
    
    int index = 1;
    for(NSValue *point in [_convexHull points])
    {
        CGPoint p = [point CGPointValue];
        
        fan[index].vertices.x = p.x;
        fan[index].vertices.y = p.y;
        fan[index].texCoords.u = ((128.0 * CC_CONTENT_SCALE_FACTOR()) + p.x) / (256.0 * CC_CONTENT_SCALE_FACTOR());
        fan[index].texCoords.v = ((128.0 * CC_CONTENT_SCALE_FACTOR()) + p.y) / (256.0 * CC_CONTENT_SCALE_FACTOR());
        
        //CCLOG(@"fan[%d] x:%f y:%f u:%f v:%f", index, fan[index].vertices.x, fan[index].vertices.y, fan[index].texCoords.u , fan[index].texCoords.v );
        
        index++;
    }
    
    //copy the first point again to close the last triangle
    CGPoint p = [[[_convexHull points] objectAtIndex:0] CGPointValue];
    fan[index].vertices.x = p.x;
    fan[index].vertices.y = p.y;
    fan[index].texCoords.u = ((128.0 * CC_CONTENT_SCALE_FACTOR()) + p.x) / (256.0 * CC_CONTENT_SCALE_FACTOR());
    fan[index].texCoords.v = ((128.0 * CC_CONTENT_SCALE_FACTOR()) + p.y) / (256.0 * CC_CONTENT_SCALE_FACTOR());
    
    //CCLOG(@"fan[%d] x:%f y:%f u:%f v:%f", index, fan[index].vertices.x, fan[index].vertices.y, fan[index].texCoords.u , fan[index].texCoords.v );
    
    _shape = [[[GameObjectCache sharedGameObjectCache] spaceManager] 
              addPolyAt:positionInPixels_
              mass:(_size == 100 ? 1000000 : _mass)
              rotation:CCRANDOM_0_1()
              points:[_convexHull points]];
    
    _shape->layers = LAYER_ASTEROID;
    _shape->collision_type = kAsteroidCollisionType;
    _shape->body->p = positionInPixels_;
}


-(id) initWithRadius:(int)size atPosition:(CGPoint)position
{
    if(!(self = [super init])) return nil;
    
    _size = size;
    _mass = size * 100;
    _ore = size * ORE_FACTOR;
    
    [self createAsteroid:size];
    
    [self setPosition:position];
    
    return self;
}

-(void) draw{
    NSUInteger offset = (NSUInteger)fan;
    
    glColor4f(1, 1, 1, 1);
    
    NSUInteger diff = offsetof( ccV2F_T2F, vertices);
    glVertexPointer(2, GL_FLOAT, 16, (GLvoid*) (offset+diff));
    
    diff = offsetof( ccV2F_T2F, texCoords);
    glTexCoordPointer(2, GL_FLOAT, 16, (GLvoid*) (offset+diff));
    
    glDrawArrays(GL_TRIANGLE_FAN, 0, (GLsizei)(vertexCount));
}

- (CGPoint) position
{
    cpBody *body = _shape->body;
    return body->p;
}


- (cpFloat) area 
{ 
    return _area; 
}

- (int) mass 
{ 
    return _mass; 
}

- (float) mineOre:(float)time length:(float)length
{
    if(_ore == 0) return 0;
    
    float extracted = abs(length) * time;
    
    if(_ore > extracted)
    {
        _ore -= extracted;
    }else
    {
        extracted = extracted - _ore;
        _ore = 0;
    }
    
    return extracted;
}

- (void)dealloc
{
    NSLog(@"Dealloc Asteroid");
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}

@end
