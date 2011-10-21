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

@implementation AsteroidField

- (id) initWithEnvironment:(GameEnvironment *)environment totalArea:(float)totalArea density:(float)density Layer:(cpLayers)Layer
{
    if((self=[super init])){
        
        
        GDKaosEngine *engine = [[GDKaosEngine alloc] initWorldSize:CGSizeMake(500.0, 1800.0) withDensity:density];
        
        while ([engine hasRoom])
        {
            Asteroid *a = [[Asteroid alloc] initWithEnvironment:environment 
                                                    withPosition:[engine position]
                                                       withLayer:Layer];
            [engine addArea:[a area]];
            
            [self addChild:a];
        
            [a release];
        }
        
        [engine release];
    };
    
    return self;
}

- (void)dealloc
{
    NSLog(@"Dealloc AsteroidField");
    [super dealloc];
}

@end
