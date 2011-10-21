//
//  AsteroidSprite.m
//  SpritePhysics
//
//  Created by Richard Owen on 6/04/11.
//  Copyright 2011 Digital Five. All rights reserved.
//

#import "AsteroidSprite.h"
#import "cocos2d.h"
#import "chipmunk.h"
#import "SpaceManager.h"

@implementation AsteroidSprite

@synthesize ore = _ore;

- (id) initWithPoints:(NSArray *)convexHull size:(int)thisSize withShape:(cpShape *)shape isBackground:(BOOL)isBackground
{
    if((self=[super init])){
        CPCCNODE_MEM_VARS_INIT(shape);
        
        _ore = thisSize * 25.0;
        
        //Copy the remaing convex shap into vert array for body, shape and clipping usage
        int num = [convexHull count];
        CGPoint verts[num];
        
        int i = 0;
        for (NSValue *val in convexHull) {
            CGPoint aP = [val CGPointValue];
            verts[i] = aP;
            i++;
        }
        
        //create the image for the sprite
        UIImage *inputImage = [UIImage imageNamed:@"Meteor1.png"];
        
        //Create a new context to draw into
        CGImageRef imageRef = inputImage.CGImage;
        size_t width = CGImageGetWidth(imageRef);
        size_t height = CGImageGetHeight(imageRef);
        CGContextRef offscreenContext = CGBitmapContextCreate(NULL,
                                                              width,
                                                              height,
                                                              8,
                                                              0,
                                                              CGImageGetColorSpace(imageRef),
                                                              kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
        
        //move the cookie cutter around within the bounds of the SKIN (the bounds are the width and height of the source image for meteors)
        int xPixelOffset = width / 2; //middle of image
        int yPixelOffset= height / 2; //middle of image
        
        if ((rand() % 10) >= 5) 
            xPixelOffset += (rand() % ((width - thisSize) / 2));
        else    
            xPixelOffset -= (rand() % ((width - thisSize) / 2));
        
        if((rand() % 10) >= 5)
            yPixelOffset += (rand() % ((height - thisSize) / 2));
        else
            yPixelOffset -= (rand() % ((height - thisSize) / 2));
        
        //NSLog(@"W and H: (%d, %d)", width, height);
        //NSLog(@"PixelOffsets: (%d, %d)", xPixelOffset, yPixelOffset);
        
        //create the clipping path for the asteroids
        CGPoint xP = verts[0];
        CGFloat xVal = xP.x;
        
        CGContextMoveToPoint(offscreenContext, xPixelOffset + xVal, yPixelOffset + verts[0].y);
        
        for(int idx = 1; idx < num; idx++){
            CGContextAddLineToPoint(offscreenContext, xPixelOffset + verts[idx].x, yPixelOffset + verts[idx].y);
        }        
        
        CGContextClosePath(offscreenContext);
        
        CGContextClip (offscreenContext);
        //clip in the prebuilt meteor skin
        CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), imageRef);
        
        //Shade the Asteroid
        //CGContextSetFillColor(offscreenContext, CGColorGetComponents( [[UIColor colorWithRed:1 green:1 blue:1 alpha:1 ] CGColor]));
        
        CGContextMoveToPoint(offscreenContext, xPixelOffset + verts[0].x, yPixelOffset + verts[0].y);
        
        for(int idx = 1; idx < num; idx++){
            CGContextAddLineToPoint(offscreenContext, xPixelOffset + verts[idx].x, yPixelOffset + verts[idx].y);
        }        
        
        CGContextClosePath(offscreenContext);
        
        // gradient properties: 
        
        CGGradientRef myGradient; 
        
        // You need tell Quartz your colour space (how you define colours), there are many colour spaces: RGBA, black&white 
        
        CGColorSpaceRef myColorspace; 
        
        // the number of different colours 
        
        size_t num_locations = 3; 
        
        // the location of each colour change, these are between 0 and 1, zero is the first circle and 1 is the end circle, so 0.5 is in the middle. 
        
        CGFloat locations[3] = { 0.0, 0.4, 1.0 }; 
        
        // this is the colour components array, because we are using an RGBA system each colour has four components (four numbers associated with it). 
        
        CGFloat componentsNormal[16] = {  
            0.0, 0.0, 0.0, 0.0, // Start colour 
            0.0, 0.0, 0.0, 0.30,    // middle colour 
            0.0, 0.0, 0.0, 0.60};
        
        CGFloat componentsBackground[16] = {  
            0.0, 0.0, 0.0, 0.30, // Start colour 
            0.0, 0.0, 0.0, 0.50,    // middle colour 
            0.0, 0.0, 0.0, 0.80}
        ; // End colour 
        
        CGFloat *thisComponents = isBackground ? componentsBackground : componentsNormal;
        
        
        
        myColorspace = CGColorSpaceCreateDeviceRGB(); 
        
        // Create a CGGradient object. 
        
        myGradient = CGGradientCreateWithColorComponents (myColorspace, thisComponents,locations, num_locations); 
        
        CGColorSpaceRelease(myColorspace);
        
        // gradient start and end points 
        
        CGPoint myStartPoint, myEndPoint; 
        
        CGFloat myStartRadius, myEndRadius; 
        
        myStartPoint.x = xPixelOffset; 
        
        myStartPoint.y = yPixelOffset; 
        
        myEndPoint.x = xPixelOffset; 
        
        myEndPoint.y = yPixelOffset; 
        
        myStartRadius = 0;//(thisSize - 5) / 4; 
        
        myEndRadius = thisSize - (thisSize / 20); 
        
        // draw the gradient. 
        
        CGContextDrawRadialGradient(offscreenContext, 
                                    myGradient, 
                                    myStartPoint,
                                    myStartRadius, 
                                    myEndPoint, 
                                    myEndRadius, 0); 
        
        
        CGGradientRelease(myGradient);
        
        // make this context into a real UIImage object
        CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
        
        CGRect copyRect = CGRectMake(xPixelOffset - (thisSize / 2), height - (thisSize / 2) - yPixelOffset, thisSize, thisSize);
        //NSLog(@"RectForCopy: (%f, %f, %f, %f)", copyRect.origin.x, copyRect.origin.y, copyRect.size.width, copyRect.size.height );
        
        CGImageRef resImageRef = CGImageCreateWithImageInRect(imageRefWithAlpha, copyRect);
        UIImage *imageResed = [UIImage imageWithCGImage:resImageRef];
        UIImage *result;
        //if retina enlarge this baby
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
            //iPhone 4
            
            CGContextRef bitmap = CGBitmapContextCreate(NULL, thisSize * 2, thisSize * 2, CGImageGetBitsPerComponent(imageResed.CGImage), 4 * thisSize * 2, CGImageGetColorSpace(imageResed.CGImage), kCGImageAlphaNoneSkipLast);
            CGContextDrawImage(bitmap, CGRectMake(0, 0, thisSize * 2, thisSize * 2), imageResed.CGImage);
            CGImageRef ref = CGBitmapContextCreateImage(bitmap);
            result = [UIImage imageWithCGImage:ref];
            
            CGContextRelease(bitmap);
            CGImageRelease(ref);
        }else
            result = imageResed;
        
        CGImageRelease(resImageRef);
        
        //call sprite init fucntion to use new image
        static int MeteorID = 0;
        [self initWithCGImage:result.CGImage key:[NSString stringWithFormat:@"Meteor%d", MeteorID++]];
        
        //clean up memory
        CGContextRelease(offscreenContext);
        CGImageRelease(imageRefWithAlpha);
        
        CPCCNODE_SYNC_POS_ROT(self);
    }
    
    return self;
}

- (float) mineOre:(float)time length:(float)length
{
    if(_ore == 0) return 0;
    
    float extracted = abs(length) * time;
    
    if(_ore > extracted)
    {
        _ore -= extracted;
    }else
    {
        extracted = extracted - _ore;
        _ore = 0;
    }
    
    return extracted;
}

- (void) dealloc
{
	//CCLOGINFO(@"AsteroidSprite: deallocing %@", self);
    NSLog(@"Dealloc AsteroidSprite");
    [self removeFromParentAndCleanup:YES];
	[super dealloc];
}

@end
