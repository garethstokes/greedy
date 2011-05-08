//
//  GreedyGameLayer.m
//  greedy
//
//  Created by gareth stokes on 4/05/11.
//  Copyright 2011 Digital Five. All rights reserved.
//

#import "GameLayer.h"
#import "GameEnvironment.h"
#import "chipmunk.h"
#import "SpaceManager.h"
#import "Asteroid.h"
#import "GDKaosEngine.h"

@implementation GameLayer

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		
		_environment = [[GameEnvironment alloc] init];
    
    // asteroids.
    CGSize wins = [[CCDirector sharedDirector] winSize];
    GDKaosEngine *engine = [[GDKaosEngine alloc] initWorldSize:wins withDensity:10.0f];
    
    while ([engine hasRoom])
    {
      Asteroid *a = [[Asteroid alloc] initWithEnvironment:_environment 
                                             withPosition:[engine position]];
      [engine addArea:[a area]];
      [self addChild:a];
    }

    // greedy!
    _greedy = [[Greedy alloc] initWith:_environment];
    [self addChild:_greedy];
    
		[self schedule: @selector(step:)];
	}
	return self;
}

static void drawStaticObject(cpShape *shape, GameLayer *gameLayer)
{
  //id <GameObject> obj = shape->data;
	//[obj draw:shape];
}	

- (void) draw
{
	//loop through the static objects and draw
  SpaceManager *manager = [_environment manager];
  cpSpace *space = [manager space];
  
	cpSpaceHashEach(space->activeShapes, (cpSpaceHashIterator)drawStaticObject, self);
	cpSpaceHashEach(space->staticShapes, (cpSpaceHashIterator)drawStaticObject, self);
}

-(void) step: (ccTime) dt
{
  [_environment step:dt];
  [_greedy step:dt];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
		
    //NSLog(@"touch location (x => %f, y => %f)", location.x, location.y);
    //[self addNewAsteroidSprite:location.x y:location.y];
  }
}

@end
