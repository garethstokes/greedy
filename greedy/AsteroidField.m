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

-(Asteroid *) createAsteroid:(int) size position:(CGPoint)position Layer:(cpLayers)Layer
{
    //create the object to add to the array
    Asteroid *newAsteroid = [[[Asteroid alloc] initWithRadius:size atPosition:position inLayer:Layer] retain];
    
    AsteroidElement *asteroidItem = malloc(sizeof(AsteroidElement));
    
    asteroidItem->asteroid = newAsteroid;
    asteroidItem->next = NULL;
    asteroidItem->prev = NULL;
    
    DL_APPEND(asteroids_, asteroidItem);
    
    return  newAsteroid;
}

- (id) initWithSize:(CGSize)size density:(float)density Layer:(cpLayers)Layer
{
    if((self=[super init])){
        
        SpriteHelperLoader *spriteLoader = [[SpriteHelperLoader alloc] initWithContentOfFile:@"asteroidSkins"];
        
        _asteroidSkin = [[spriteLoader spriteWithUniqueName:@"normal" atPosition:ccp(0,0) inLayer:nil] retain];
        
        if(Layer == LAYER_BACKGROUND)
            _noise = [[CCSprite spriteWithFile:@"noise.png"] retain];
        else
            _noise = [[CCSprite spriteWithFile:@"noise_game.png"] retain];
        
        _layer = Layer;
        
        _size = size;
        
        [spriteLoader release];
        
        GDKaosEngine *engine = [[GDKaosEngine alloc] initWorldSize:size withDensity:density];
        
        asteroids_ = NULL;

        //while we have space lets add an asteroid
        for(int i = 0; i < 15; i++)
        {
            [self addAsteroid:arc4random() % ((Layer == LAYER_BACKGROUND) ? 8 : 10)];
        }
        
        [engine release];
    };
    
    return self;
}

- (Asteroid *) addAsteroid:(int)size
{
    int x = (arc4random() % (int)(_size.width / 2.0f));
    x = x * RANDOM_NEG1_OR_1();
    int y = (arc4random() % (int)(_size.height / 2.0f)) * (RANDOM_NEG1_OR_1());
        
    return [self createAsteroid:size position:ccp(x, y) Layer:_layer];
};

- (Asteroid *) addAsteroid:(CGPoint)position size:(int)size
{
    return [self createAsteroid:size position:position Layer:_layer]; 
}

-(void) draw
{
    glDisableClientState(GL_COLOR_ARRAY);
    
    AsteroidElement *elem;
    AsteroidElement *temp;
    
    // load in the main skin
    glBindTexture(GL_TEXTURE_2D, _asteroidSkin.texture.name);
    DL_FOREACH_SAFE(asteroids_, elem, temp)
    {
        [elem->asteroid visit];
    }
    
    //blend in the gradient
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
