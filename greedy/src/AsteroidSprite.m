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

- (id) initWithPoints:(NSArray *)convexHull size:(int)thisSize withShape:(cpShape *)shape
{
    if((self=[super init])){
      CPCCNODE_MEM_VARS_INIT(shape);
        
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
      
      if ((rand() % 1) == 0) 
          xPixelOffset += (rand() % ((width - thisSize) / 2));
      else    
          xPixelOffset -= (rand() % ((width - thisSize) / 2));
      
     if((rand() % 1) == 0)
         yPixelOffset += (rand() % ((height - thisSize) / 2));
      else
          yPixelOffset -= (rand() % ((height - thisSize) / 2));
         
      //NSLog(@"W and H: (%d, %d)", width, height);
      //NSLog(@"PixelOffsets: (%d, %d)", xPixelOffset, yPixelOffset);
      
      //create the clipping path for the asteroids
      CGContextMoveToPoint(offscreenContext, xPixelOffset + verts[0].x, yPixelOffset + verts[0].y);
          
          for(int idx = 1; idx < num; idx++){
              CGContextAddLineToPoint(offscreenContext, xPixelOffset + verts[idx].x, yPixelOffset + verts[idx].y);
          }        
          
      CGContextClosePath(offscreenContext);
      
      CGContextClip (offscreenContext);
      
      //clip in the prebuilt meteor skin
      CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), imageRef);
      
      // make this context into a real UIImage object
      CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
      
      CGRect copyRect = CGRectMake(xPixelOffset - (thisSize / 2), height - (thisSize / 2) - yPixelOffset, thisSize, thisSize);
      //NSLog(@"RectForCopy: (%f, %f, %f, %f)", copyRect.origin.x, copyRect.origin.y, copyRect.size.width, copyRect.size.height );
      
      CGImageRef resImageRef = CGImageCreateWithImageInRect(imageRefWithAlpha, copyRect);
      UIImage *imageResed = [UIImage imageWithCGImage:resImageRef];
      
      //call sprite init fucntion to use new image
      [self initWithCGImage:imageResed.CGImage key:[NSString stringWithFormat:@"Meteor%d", rand()%1000000]];

      //clean up memory
      CGContextRelease(offscreenContext);
      CGImageRelease(imageRefWithAlpha);
    }
    
    CPCCNODE_SYNC_POS_ROT(self);
    return self;
}

- (void) dealloc
{
	CCLOGINFO(@"AsteroidSprite: deallocing %@", self);
	[super dealloc];
}

@end
