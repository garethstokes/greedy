//
//  AsteroidSprite.m
//  SpritePhysics
//
//  Created by Richard Owen on 6/04/11.
//  Copyright 2011 Digital Five. All rights reserved.
//

#import "AsteroidSprite.h"

@implementation AsteroidSprite

const int SKIN_WIDTH = 250;
const int SKIN_HEIGHT = 250;

const int POINTS_PER_QUADRANT = 9;
const int SIZE_SMALL = 30;
const int SIZE_MEDIUM = 60;
const int SIZE_LARGE = 90;

int pointLocation(CGPoint A, CGPoint B, CGPoint P) {
    
    int cp1 = (B.x-A.x)*(P.y-A.y) - (B.y-A.y)*(P.x-A.x);
    
    return (cp1>0)?1:-1;
}

int pointDistance(CGPoint A, CGPoint B, CGPoint C) {
    int ABx = B.x-A.x;
    int ABy = B.y-A.y;
    int num = ABx*(A.y-C.y)-ABy*(A.x-C.x);
    if (num < 0) num = -num;
    return num;
} 

void hullSet(CGPoint A, CGPoint B, NSMutableArray *set, NSMutableArray *hull) {
    int insertPosition = [hull indexOfObject:[NSValue valueWithCGPoint:B]];
    
    if ([set count] == 0) 
        return;
    
    if ([set count] == 1) {
        CGPoint p = [(NSValue *)[set objectAtIndex:0] CGPointValue];
        [set removeObjectAtIndex:0];
        [hull insertObject:[NSValue valueWithCGPoint:p] atIndex:insertPosition];
        return;
    }
    
    int dist = INT_MIN;
    int furthestPoint = -1;
    
    int i = 0;
    for (NSValue *val in set) {
        CGPoint p = [val CGPointValue];
        
        int adistance = pointDistance(A, B, p);
        
        
        if (adistance > dist) {
            dist = adistance;
            furthestPoint = i;
        }
        
        i++;
    }
    
    CGPoint P = [(NSValue *)[set objectAtIndex:furthestPoint] CGPointValue];
    [set removeObjectAtIndex:furthestPoint];
    [hull insertObject:[NSValue valueWithCGPoint:P] atIndex:insertPosition];
    
    // Determine who's to the left of AP
    NSMutableArray *leftSetAP = [[NSMutableArray alloc] init];
    i = 0;
    for (NSValue *val in set) {
        CGPoint M = [val CGPointValue];   
        if (pointLocation(A,P,M)==1) {
            [leftSetAP addObject:[NSValue valueWithCGPoint:M]];
        }
        i++;
    }
    
    // Determine who's to the left of PB
    NSMutableArray *leftSetPB = [[NSMutableArray alloc] init];
    i = 0;
    for (NSValue *val in set) {
        CGPoint M = [val CGPointValue];   
        if (pointLocation(P,B,M)==1) {
            [leftSetPB addObject:[NSValue valueWithCGPoint:M]];
        }
    }
    
    hullSet(A, P, leftSetAP, hull);
    hullSet(P, B, leftSetPB, hull);
}

NSMutableArray *quickHull(NSMutableArray *points) 
{
    NSMutableArray *convexHull = [[NSMutableArray alloc] init];
    
    //If we have less then 3 points this is a no go
    if ([points count] < 3) 
        return points;
    
    // find extremals
    int minPoint = -1;
    int maxPoint = -1;
    int minX = INT_MAX;
    int maxX = INT_MIN;
    
    int i = 0;
    for (NSValue *val in points) {
        CGPoint p = [val CGPointValue];
        
        if (p.x < minX) {
            minX = p.x;
            minPoint = i;
        } 
        if (p.x > maxX) {
            maxX = p.x;
            maxPoint = i;       
        }
        i++;
    }
    
    CGPoint A = [(NSValue *)[points objectAtIndex:minPoint] CGPointValue];
    CGPoint B = [(NSValue *)[points objectAtIndex:maxPoint] CGPointValue];;
    
    [convexHull addObject:[NSValue valueWithCGPoint:A]];
    [convexHull addObject:[NSValue valueWithCGPoint:B]];
    
    [points removeObject:[NSValue valueWithCGPoint:A]];
    [points removeObject:[NSValue valueWithCGPoint:B]];
    
    NSMutableArray *leftSet  = [[NSMutableArray alloc] init];
    NSMutableArray *rightSet = [[NSMutableArray alloc] init];
    
    for (NSValue *val in points) {
        CGPoint p = [val CGPointValue];
        if (pointLocation(A,B,p) == -1)
            [leftSet addObject:[NSValue valueWithCGPoint:p]];
        else
            [rightSet addObject:[NSValue valueWithCGPoint:p]];
    }
    
    hullSet(A, B, rightSet, convexHull);
    hullSet(B, A, leftSet, convexHull);
    
    return convexHull;
}

void drawCubicBezier(CGPoint origin, CGPoint control1, CGPoint control2, CGPoint destination, int segments, CGPoint *vertices)
{
    //CGPoint vertices[segments + 1];
    
    float t = 0.0;
    for(int i = 0; i < segments; i++)
    {
        float x = pow(1 - t, 3) * origin.x + 3.0 * pow(1 - t, 2) * t * control1.x + 3.0 * (1 - t) * t * t * control2.x + t * t * t * destination.x;
        float y = pow(1 - t, 3) * origin.y + 3.0 * pow(1 - t, 2) * t * control1.y + 3.0 * (1 - t) * t * t * control2.y + t * t * t * destination.y;
        vertices[i] = CGPointMake(x, y);
        t += 1.0 / segments;
    }
    vertices[segments] = destination;
}

NSMutableArray *createAsteroidShape(int width, int height)
{
    NSMutableArray *points = [[NSMutableArray alloc] init];
    
    int halfWidth = width / 2;
    int halfHeight = height / 2;
    
    CGPoint q1, q2, q3, q4;
    
    for(int i = 0 ; i < POINTS_PER_QUADRANT; i ++){
        q1 = ccp(-(rand() % halfWidth), rand() % halfHeight);
        [points addObject:[NSValue valueWithCGPoint:q1]];
        
        q2 = ccp(rand() % halfWidth, rand() % halfHeight);
        [points addObject:[NSValue valueWithCGPoint:q2]];
        
        q3 = ccp(rand() % halfWidth, -(rand() % halfHeight));
        [points addObject:[NSValue valueWithCGPoint:q3]];
        
        q4 = ccp(-(rand() % halfWidth), -(rand() % halfHeight));
        [points addObject:[NSValue valueWithCGPoint:q4]];
    }
    
    return points; 
}

- (void) drawRect:(CGRect)rect
{
    // Create a gradient from white to red
    CGFloat colors [] = { 
        1.0, 1.0, 1.0, 1.0, 
        1.0, 0.0, 0.0, 1.0
    };
    
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient), gradient = NULL;
    
    CGContextRestoreGState(context);
    
    CGContextAddEllipseInRect(context, rect);
    CGContextDrawPath(context, kCGPathStroke);
}

- (id) initWithSpace:(cpSpace *)worldSpace position:(CGPoint)position size:(int)size
{
    if((self=[super init])){
        int x = position.x;
        int y = position.y;
        
        //Create a convex hull for the points below
        int thisSize = 0;
        NSMutableArray *spriteHull;
        switch(size){
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
                thisSize = SIZE_SMALL;
                break;
            case 5:
            case 6:
            case 7:
                thisSize = SIZE_MEDIUM;
                break;
            case 8:
            case 9: thisSize = SIZE_LARGE;
                break;
            default:
                thisSize - SIZE_SMALL;
        }
        
        //Random gen points for asteroids
        spriteHull = createAsteroidShape(thisSize, thisSize);
        
        /* VALID CONVEX HULL
        priteHull = [NSMutableArray arrayWithObjects:
                                    [NSValue valueWithCGPoint:CGPointMake(-14,  16)],
                                    [NSValue valueWithCGPoint:CGPointMake( 10,  24)],
                                    [NSValue valueWithCGPoint:CGPointMake( 22,   4)],
                                    [NSValue valueWithCGPoint:CGPointMake( 22, -14)],
                                    [NSValue valueWithCGPoint:CGPointMake(  10, -24)],
                                    [NSValue valueWithCGPoint:CGPointMake(-22, -24)],
                                    [NSValue valueWithCGPoint:CGPointMake(-22, -2)],
                                nil];
        */
        
        
        /*
        // BOX TEST SHAPE
        thisSize = 100;
        spriteHull = [NSMutableArray arrayWithObjects:
                                      [NSValue valueWithCGPoint:CGPointMake(-10,  50)],
                                      [NSValue valueWithCGPoint:CGPointMake( 10,  50)],
                                      [NSValue valueWithCGPoint:CGPointMake( 50, -50)],
                                      [NSValue valueWithCGPoint:CGPointMake(-50, -50)],
                                      nil];
        
        */
        
        NSMutableArray *convexHull = [[NSMutableArray alloc] init];
        convexHull = quickHull(spriteHull);
        
        //Copy the remaing convex shap into vert array for body, shape and clipping usage
        int num = [convexHull count];
        CGPoint verts[num];
        
        int i = 0;
        for (NSValue *val in convexHull) {
            CGPoint aP = [val CGPointValue];
            verts[i] = aP;
            i++;
        }
    
        //create the physics objects for this convexHull
        body = cpBodyNew(1.0f, cpMomentForPoly(1.0f, num, verts, CGPointZero));
        body->p = ccp(x, y);
        cpSpaceAddBody(worldSpace, body);
        
        shape = cpPolyShapeNew(body, num, verts, CGPointZero);
        shape->e = 0.5f; 
        shape->u = 0.5f;
        shape->data = self;
        cpSpaceAddShape(worldSpace, shape);
        
        //create the image for the sprite
        UIImage *inputImage = [UIImage imageNamed:@"meteor1.png"];
        
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
        
        //Shade the edge of the asteroids
        CGFloat colors [] = { 
            1.0, 1.0, 1.0, 1.0, 
            1.0, 0.0, 0.0, 1.0
        };
        
        CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
        CGColorSpaceRelease(baseSpace), baseSpace = NULL;
        
        CGContextDrawLinearGradient(offscreenContext, gradient, ccp(verts[0].x, verts[0].y), ccp(verts[1].x, verts[1].y), 0);
        CGGradientRelease(gradient), gradient = NULL;
        
        // make this context into a real UIImage object
        CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
        UIImage *imageWithAlpha = [UIImage imageWithCGImage:imageRefWithAlpha];
        
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
    
    return self;
}

- (void) dealloc
{
	CCLOGINFO(@"AsteroidSprite: deallocing %@", self);
	[super dealloc];
}

@end
