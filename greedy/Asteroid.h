//
//  Asteroid.h
//  greedy
//
//  Created by gareth stokes on 8/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"
#import "GameEnvironment.h"
#import "ConvexHull.h"
#import "GameConfig.h"

typedef struct _ccV2F_T2F
{
	//! vertices (2F)
	ccVertex2F		vertices;
	//! tex coords (2F)
	ccTex2F			texCoords;
} ccV2F_T2F;

@interface Asteroid : CCNode {
    int _size;
    CGFloat _area;
    int _mass;
    float _ore;
    
    //physics
    cpShape *_shape;
    
    //variables to hold the opengl rendering structure
    int  vertexCount;
    ccV2F_T2F *fan;
    
    CPCCNODE_MEM_VARS
}

@property (nonatomic) cpShape *shape;

-(id) initWithRadius:(int)size atPosition:(CGPoint)position;

- (cpFloat) area; 
- (int) mass;
- (float) mineOre:(float)time length:(float)length;

@end
