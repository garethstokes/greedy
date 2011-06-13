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
      
      //CGContextSetStrokeColorWithColor(offscreenContext, [[UIColor colorWithRed:0.5 green:0.5 blue:0.0 alpha:0.2] CGColor]);
      //CGContextSetLineWidth(offscreenContext, 30.0f);
      //CGContextStrokePath(offscreenContext);  
      
      // gradient properties: 
      
      CGGradientRef myGradient; 
      
      // You need tell Quartz your colour space (how you define colours), there are many colour spaces: RGBA, black&white‚Ä¶ 
      
      CGColorSpaceRef myColorspace; 
      
      // the number of different colours 
      
      size_t num_locations = 3; 
      
      // the location of each colour change, these are between 0 and 1, zero is the first circle and 1 is the end circle, so 0.5 is in the middle. 
      
      CGFloat locations[3] = { 0.0, 0.4, 1.0 }; 
      
      // this is the colour components array, because we are using an RGBA system each colour has four components (four numbers associated with it). 
      
      CGFloat components[16] = {  0.0, 0.0, 0.0, 0.0, // Start colour 
        0.0, 0.0, 0.0, 0.30,    // middle colour 
        0.0, 0.0, 0.0, 0.8,
        0.4, 0.4, 1.4, 0.40}; // End colour 
      
      myColorspace = CGColorSpaceCreateDeviceRGB(); 
      
      // Create a CGGradient object. 
      
      myGradient = CGGradientCreateWithColorComponents (myColorspace, components,locations, num_locations); 
      
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
                                  myStartPoint,myStartRadius, myEndPoint, myEndRadius, 0); 
      
      CGGradientRelease(myGradient);
      
      // make this context into a real UIImage object
      CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
      
      CGRect copyRect = CGRectMake(xPixelOffset - (thisSize / 2), height - (thisSize / 2) - yPixelOffset, thisSize, thisSize);
      //NSLog(@"RectForCopy: (%f, %f, %f, %f)", copyRect.origin.x, copyRect.origin.y, copyRect.size.width, copyRect.size.height );
      
      CGImageRef resImageRef = CGImageCreateWithImageInRect(imageRefWithAlpha, copyRect);
      UIImage *imageResed = [UIImage imageWithCGImage:resImageRef];
     
      CGImageRelease(resImageRef);
      
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
