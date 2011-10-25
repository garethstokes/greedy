//
//  AsteroidField.m
//  greedy
//
//  Created by Richard Owen on 13/06/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "AsteroidField.h"
#import "Asteroid.h"
#import "GDKaosEngine.h"
#import "SpriteHelperLoader.h"

@implementation AsteroidField


-(void) createAsteroid:(int) size position:(CGPoint)position
{
    //create the object to add to the array
    Asteroid *newAsteroid = [[[Asteroid alloc] initWithRadius:size atPosition:position] retain];
    
    AsteroidElement *asteroidItem = malloc(sizeof(AsteroidElement));
    
    asteroidItem->asteroid = newAsteroid;
    asteroidItem->next = NULL;
    asteroidItem->prev = NULL;
    
    DL_APPEND(asteroids_, asteroidItem);
}

- (id) initWithEnvironment:(GameEnvironment *)environment totalArea:(float)totalArea density:(float)density Layer:(cpLayers)Layer
{
    if((self=[super init])){
        
        SpriteHelperLoader *spriteLoader = [[SpriteHelperLoader alloc] initWithContentOfFile:@"asteroidSkins"];
        
        _asteroidSkin = [[spriteLoader spriteWithUniqueName:@"normal" atPosition:ccp(0,0) inLayer:nil] retain];
        
        _noise = [[CCSprite spriteWithFile:@"noise.png"] retain];
        
        [spriteLoader release];
        
        GDKaosEngine *engine = [[GDKaosEngine alloc] initWorldSize:CGSizeMake(500.0, 1800.0) withDensity:density];
        
        asteroids_ = NULL;

        //while we have space lets add an asteroid
        for(int i = 0; i < 20; i++)
        {
            int x = (arc4random() % (500 / 2)) * (CCRANDOM_MINUS1_1());
            int y = (arc4random() % (1800 / 2)) * (CCRANDOM_MINUS1_1());
            
            [self createAsteroid:(arc4random() % 10) position:ccp(x, y)];
        }
        
        [engine release];
    };
    
    return self;
}



-(void) draw
{
    glDisableClientState(GL_COLOR_ARRAY);
    
    AsteroidElement *elem;
    AsteroidElement *temp;
    
    // Now blend in the gradient
    glBindTexture(GL_TEXTURE_2D, _asteroidSkin.texture.name);
    DL_FOREACH_SAFE(asteroids_, elem, temp)
    {
        [elem->asteroid visit];
    }
    
    //for each asteroid in this field render it
    glBindTexture(GL_TEXTURE_2D, _noise.texture.name);
    glBlendFunc(GL_DST_COLOR, GL_ZERO);
    DL_FOREACH_SAFE(asteroids_, elem, temp)
    {
        [elem->asteroid visit];
    }
  
    // restore default state
    glBlendFunc( CC_BLEND_SRC, CC_BLEND_DST );
    glEnableClientState(GL_COLOR_ARRAY);
}

- (void)dealloc
{
    NSLog(@"Dealloc AsteroidField");
    [_noise release];
    [_asteroidSkin release];
    [super dealloc];
}

@end
