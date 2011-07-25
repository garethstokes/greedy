//
//  World.h
//  greedy
//
//  Created by Gareth Stokes on 20/07/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface World : NSObject {
  NSString *_name;
  NSMutableArray *_levels;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableArray *levels;


@end
