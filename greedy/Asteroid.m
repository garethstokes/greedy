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

-(void) createAsteroid:(cpLayers)inLayer
{
    ConvexHull *_convexHull = [[[ConvexHull alloc] initWithStaticSize:_size] autorelease];
    _area = [_convexHull area];
    
    int radius = [_convexHull size];
    
    _vertexCount = [[_convexHull points] count] + 2;
    
    _fan = (ccV2F_T2F *)malloc(sizeof(ccV2F_T2F) * _vertexCount);
    
    //center point
    _fan[0].vertices.x = 0;
    _fan[0].vertices.y = 0;
    
    float uOffset = (128 + ((radius < 128) ? ((arc4random() % (128 - 90)) * RANDOM_NEG1_OR_1()) : 0)) * CC_CONTENT_SCALE_FACTOR();
    float vOffset = (128 + ((radius < 128) ? ((arc4random() % (128 - 90)) * RANDOM_NEG1_OR_1()) : 0)) * CC_CONTENT_SCALE_FACTOR();
    
    _fan[0].texCoords.u = uOffset / (256.0 * CC_CONTENT_SCALE_FACTOR());//0.5;
    _fan[0].texCoords.v = vOffset / (256.0 * CC_CONTENT_SCALE_FACTOR());//0.5;
    //CCLOG(@"fan[%d] x:%f y:%f u:%f v:%f", 0, fan[0].vertices.x, fan[0].vertices.y, fan[0].texCoords.u , fan[0].texCoords.v );
    
    int index = 1;
    for(NSValue *point in [_convexHull points])
    {
        CGPoint p = [point CGPointValue];
        
        _fan[index].vertices.x = p.x;
        _fan[index].vertices.y = p.y;
        _fan[index].texCoords.u = (uOffset + p.x * CC_CONTENT_SCALE_FACTOR()) / (256.0 * CC_CONTENT_SCALE_FACTOR());
        _fan[index].texCoords.v = (vOffset + p.y * CC_CONTENT_SCALE_FACTOR()) / (256.0 * CC_CONTENT_SCALE_FACTOR());
        
        //CCLOG(@"fan[%d] x:%f y:%f u:%f v:%f", index, fan[index].vertices.x, fan[index].vertices.y, fan[index].texCoords.u , fan[index].texCoords.v );
        
        index++;
    }
    
    //copy the first point again to close the last triangle
    CGPoint p = [[[_convexHull points] objectAtIndex:0] CGPointValue];
    _fan[index].vertices.x = p.x;
    _fan[index].vertices.y = p.y;
    _fan[index].texCoords.u = (uOffset + p.x * CC_CONTENT_SCALE_FACTOR()) / (256.0 * CC_CONTENT_SCALE_FACTOR());
    _fan[index].texCoords.v = (vOffset + p.y * CC_CONTENT_SCALE_FACTOR()) / (256.0 * CC_CONTENT_SCALE_FACTOR());
    
    //CCLOG(@"fan[%d] x:%f y:%f u:%f v:%f", index, fan[index].vertices.x, fan[index].vertices.y, fan[index].texCoords.u , fan[index].texCoords.v );
    
    _shape = [[[GameObjectCache sharedGameObjectCache] spaceManager] 
              addPolyAt:positionInPixels_
              mass:(_size == 100 ? 1000000 : _mass)
              rotation:CCRANDOM_0_1()
              points:[_convexHull points]];
    
    _shape->layers = inLayer;
    _shape->collision_type = kAsteroidCollisionType;
    _shape->body->p = positionInPixels_;
}


-(id) initWithRadius:(int)size atPosition:(CGPoint)position inLayer:(cpLayers)inLayer
{
    if(!(self = [super init])) return nil;
    
    _size = size;
    _mass = size * 100;
    _ore = size * ORE_FACTOR;
    
    [self setPositionInPixels:position];
    
    [self createAsteroid:inLayer];

    CPCCNODE_MEM_VARS_INIT(_shape);
   
    CPCCNODE_SYNC_POS_ROT(self);
    
    return self;
}

-(void) draw
{
    NSUInteger offset = (NSUInteger)_fan;
    
    glColor4f(1, 1, 1, 1);
    
    NSUInteger diff = offsetof( ccV2F_T2F, vertices);
    glVertexPointer(2, GL_FLOAT, 16, (GLvoid*) (offset+diff));
    
    diff = offsetof( ccV2F_T2F, texCoords);
    glTexCoordPointer(2, GL_FLOAT, 16, (GLvoid*) (offset+diff));
    
    glDrawArrays(GL_TRIANGLE_FAN, 0, (GLsizei)(_vertexCount));
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

CPCCNODE_FUNC_SRC

@end
