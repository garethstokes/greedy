//
//  TestLayer.m
//  greedy
//
//  Created by Richard Owen on 19/12/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "TestLayer.h"
#import "OreAnimation.h"

@implementation TestLayer


+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	TestLayer *layer = [TestLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void) addEvent:(float)duration method:(SEL)method object:(id)object
{
    [self runAction: [CCSequence actions:[CCDelayTime actionWithDuration:duration],
                      [CCCallFuncND actionWithTarget:self selector:method data:object],
                      nil]
     ];
}

-(void) endTest:(id)sender data:(void*)data
{
    OreAnimation *oreAnim = (OreAnimation *)data;
    
    [oreAnim endAnimation];
}

-(void) addPoints:(id)sender data:(void*)data
{
    OreAnimation *oreAnim = (OreAnimation *)data;
    
    [oreAnim addPoint:ccp(160 + ((arc4random() % 100) * CCRANDOM_MINUS1_1()), 240 + ((arc4random() % 100) * CCRANDOM_MINUS1_1()))];
    
    [self addEvent:0.25 method:@selector(addPoints:data:) object:oreAnim];
}

-(void) testScore:(id)sender data:(void*)data
{
    OreAnimation *oreAnim = (OreAnimation *)data;
    
    [oreAnim addScore: arc4random() % 100000];
}

-(void) testOreAnimation
{
    // add animation
    OreAnimation *oreAnim = [[[OreAnimation alloc] initWithPosition:ccp(160,240)] autorelease];
    [self addChild:oreAnim z:100];
    
    //set score in 2 seconds
    [self addEvent:2.0 method:@selector(testScore:data:) object:oreAnim];
    
    //Setendpoint timeout every .5 seconds
    [self addEvent:0.25 method:@selector(addPoints:data:) object:oreAnim];
    
    //Setendpoint timeout in 5 seconds
    [self addEvent:5.0 method:@selector(endTest:data:) object:oreAnim];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self testOreAnimation];
        
        
    }
    
    return self;
}

@end
