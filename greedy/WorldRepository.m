//
//  WorldRepository.m
//  greedy
//
//  Created by Gareth Stokes on 20/07/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "WorldRepository.h"
#import "GreedyLevel.h"
#import "World.h"
#import "CCFileUtils.h"

@implementation WorldRepository

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (World *) findWorldBy:(int) worldId
{
  World *world = [[World alloc] init];
  
  //Load in the plist and start processing the stuff
  NSString *directory = [NSString stringWithFormat:@"worlds/world_%i", worldId];
  
  for (int i = 1; i <= 12; i++)
  {
    GreedyLevel *level = [[GreedyLevel alloc] init];
    NSString *levelPath = [NSString stringWithFormat:@"level_%i", i];
    NSString *subDirectory = [NSString stringWithFormat:@"%@/%@", directory, levelPath];
   
    //NSString *configurationFilename = [[NSBundle mainBundle] pathForResource:@"level" ofType:@"plist" inDirectory:subDirectory];
    NSString *configurationFilename = [NSString stringWithFormat:@"%@/level.plist", subDirectory];
    
    NSString *path = [CCFileUtils fullPathFromRelativePath:configurationFilename];
    NSDictionary *dictLevel = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    if ([dictLevel count] == 0) continue;
    
    [level importFromDictionary:dictLevel];
    [world.levels addObject:level];
  }
  
  return world;
}

@end
