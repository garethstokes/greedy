//
//  Asteroid.h
//  greedy
//
//  Created by gareth stokes on 8/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "cocos2d.h"
#import "chipmunk.h"
#import "SpaceManagerCocos2d.h"
#import "GameConfig.h"
#import "OreAnimation.h"

typedef struct _ccV2F_T2F
{
	//! vertices (2F)
	ccVertex2F		vertices;
	//! tex coords (2F)
	ccTex2F			texCoords;
} ccV2F_T2F;

@interface Asteroid : CCNode<cpCCNodeProtocol> {
    int _size;
    CGFloat _area;
    int _mass;
    
    //Ore stuff
    float _ore;
    OreAnimation *_oreAnim;
    
    cpShape * _shape;
        
    //variables to hold the opengl rendering structure
    int  _vertexCount;
    ccV2F_T2F *_fan;
    
    CPCCNODE_MEM_VARS;
}

@property (nonatomic, assign) OreAnimation *oreAnim;

-(id) initWithRadius:(int)size atPosition:(CGPoint)position inLayer:(cpLayers)inLayer;

- (cpFloat) area; 
- (int) mass;
- (float) mineOre:(float)time length:(float)length;

@end
