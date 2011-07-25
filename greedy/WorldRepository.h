//
//  WorldRepository.h
//  greedy
//
//  Created by Gareth Stokes on 20/07/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "World.h"

@interface WorldRepository : NSObject


- (World *) findWorldBy:(int) worldId;

@end
