//
//  Radar.m
//  greedy
//
//  Created by Richard Owen on 29/10/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "Radar.h"



@implementation Radar

-(id) initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect
{
    self = [super initWithTexture:texture rect:rect];
    
    radarAngle = rotation_;
    userData_ = [NSValue valueWithCGPoint:ccp(0,0)];
    
    return self;
}

-(void)setRadarRotation:(float)rot
{
    radarAngle = rot;
    
    userData_ = [NSValue valueWithCGPoint:ccp(rot,0)];
    
    rotation_ = rot;
    
    [self setRotation:radarAngle];
}

-(void)setRotation:(float)rot
{
    float angle = [(NSValue *)(userData_) CGPointValue].x;
    
    [super setRotation:angle];
}


#pragma mark CCSprite - CCNode overrides



@end

//@implementation CCSprite(MySpriteRadar)
//-(void)setRotation:(float)rot
//{
//    float angle = [(NSValue *)(userData_) CGPointValue].x;
//    
//    [super setRotation:angle];
//}
//@end

//
// RotateBy
//
#pragma mark -
#pragma mark RotateBy

@implementation CCRadarRotateBy
+(id) actionWithDuration: (ccTime) t angle:(float) a
{	
	return [[[self alloc] initWithDuration:t angle:a ] autorelease];
}

-(id) initWithDuration: (ccTime) t angle:(float) a
{
	if( (self=[super initWithDuration: t]) )
		angle_ = a;
	
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	CCAction *copy = [[[self class] allocWithZone: zone] initWithDuration: [self duration] angle: angle_];
	return copy;
}

-(void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	startAngle_ = [target_ rotation];
}

-(void) update: (ccTime) t
{	
	// XXX: shall I add % 360
	[(Radar *)target_ setRadarRotation: (startAngle_ +angle_ * t )];
}

-(CCActionInterval*) reverse
{
	return [[self class] actionWithDuration:duration_ angle:-angle_];
}

@end
