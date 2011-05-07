//
//  GreedyGameLayer.m
//  greedy
//
//  Created by gareth stokes on 4/05/11.
//  Copyright 2011 Digital Five. All rights reserved.
//

#import "GreedyGameLayer.h"
#import "GreedyGameEnvironment.h"
#import "AsteroidSprite.h"
#import "chipmunk.h"
#import "SpaceManager.h"

@implementation GreedyGameLayer

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		
		_environment = [[GreedyGameEnvironment alloc] init];
		
		[self schedule: @selector(step:)];
	}
	return self;
}

-(void) addNewAsteroidSprite: (float)x y:(float)y
{
  CGPoint p = ccp(x, y);
	
  NSLog(@"touch location (x => %f, y => %f)", p.x, p.y); 
  SpaceManager *manager = [_environment manager];
  cpSpace *space = [manager space];
	CCSprite *sprite = [[AsteroidSprite alloc] initWithSpace:space 
                                             position:p 
                                             size:rand() % 10];
    
  [self addChild:sprite];
}

-(void) step: (ccTime) dt
{
    [_environment step:dt];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
		
        //NSLog(@"touch location (x => %f, y => %f)", location.x, location.y);
		//[self addNewSpriteX: location.x y:location.y];
        [self addNewAsteroidSprite:location.x y:location.y];
    }
}

@end
