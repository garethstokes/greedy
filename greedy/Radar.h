//
//  Radar.h
//  greedy
//
//  Created by Richard Owen on 29/10/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "cocos2d.h"
#import "SpaceManagerCocos2d.h"

//@interface CCSprite(MySpriteRadar)
//-(void)setRotation:(float)rotation;
//@end

@interface Radar : CCSprite<cpCCNodeProtocol>{
    
    CPCCNODE_MEM_VARS;
    cpShape *_shapeRadarCircle;
    cpShape *_radarShape;
    float _score;
}
-(id) initWithBody:(cpBody*)body;
- (void) step:(ccTime) delta;
- (void) stop;
- (void) start;
-(float) score;
	
@end
