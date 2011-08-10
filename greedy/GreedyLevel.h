//
//  Level.h
//  greedy
//
//  Created by Gareth Stokes on 20/07/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaticAsteroidsConfig : NSObject {
  int _size;
  CGPoint _position;
}

@property int size;
@property CGPoint position;

- (void) importFromDictionary:(NSDictionary *)dictionary;

@end

@interface EnvironmentConfig : NSObject
@property int width;
@property int height;

@property int friction;
@property int elasticity;

- (void) importFromDictionary:(NSDictionary *)dictionary;
@end

@interface GreedyLevel : NSObject{
  int _number;
  
  int _asteroidFieldHeight;
  int _asteroidFieldWidth;
  
  NSMutableArray *_staticAsteroids;
  
  CGPoint _greedyPosition;
  
  EnvironmentConfig *_environment;
  
  CGPoint _startPosition;
  CGPoint _finishPosition;
}

@property int number;
@property int asteroidFieldHeight;
@property int asteroidFieldWidth;

@property (nonatomic, retain) NSMutableArray *staticAsteroids;

@property CGPoint greedyPosition;

@property (nonatomic, retain) EnvironmentConfig *environment;

@property CGPoint startPosition;
@property CGPoint finishPosition;

- (void) importFromDictionary:(NSDictionary *)dictionary;

@end