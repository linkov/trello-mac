//
//  NSImage+Util.m
//  Trellobyte
//
//  Created by alex on 10/25/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "NSImage+Util.h"

@implementation NSImage (Util)

- (NSImage*)imageRotatedByDegrees:(CGFloat)degrees {
    // Calculate the bounds for the rotated image
    // We do this by affine-transforming the bounds rectangle
    NSRect imageBounds = {NSZeroPoint, [self size]};
    NSBezierPath* boundsPath = [NSBezierPath bezierPathWithRect:imageBounds];
    NSAffineTransform* transform = [NSAffineTransform transform];
    [transform rotateByDegrees:degrees];
    [boundsPath transformUsingAffineTransform:transform];
    NSRect rotatedBounds = {NSZeroPoint, [boundsPath bounds].size};
    NSImage* rotatedImage = [[NSImage alloc] initWithSize:rotatedBounds.size] ;

    // Center the image within the rotated bounds
    imageBounds.origin.x = NSMidX(rotatedBounds) - (NSWidth(imageBounds) / 2);
    imageBounds.origin.y = NSMidY(rotatedBounds) - (NSHeight(imageBounds) / 2);

    // Start a new transform, to transform the image
    transform = [NSAffineTransform transform];

    // Move coordinate system to the center
    // (since we want to rotate around the center)
    [transform translateXBy:+(NSWidth(rotatedBounds) / 2)
                        yBy:+(NSHeight(rotatedBounds) / 2)];
    // Do the rotation
    [transform rotateByDegrees:degrees];
    // Move coordinate system back to normal (bottom, left)
    [transform translateXBy:-(NSWidth(rotatedBounds) / 2)
                        yBy:-(NSHeight(rotatedBounds) / 2)];

    // Draw the original image, rotated, into the new image
    // Note: This "drawing" is done off-screen.
    [rotatedImage lockFocus];
    [transform concat];
    [self drawInRect:imageBounds fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0] ;
    [rotatedImage unlockFocus];
    
    return rotatedImage;
}

- (NSImage *)imageTintedWithColor:(NSColor *)tint
{
    NSImage *image = [self copy];
    if (tint) {
        [image lockFocus];
        [tint set];
        NSRect imageRect = {NSZeroPoint, [image size]};
        NSRectFillUsingOperation(imageRect, NSCompositeSourceAtop);
        [image unlockFocus];
    }
    return image;
}

- (NSImage *)grayscaleImageWithAlphaValue:(CGFloat)alphaValue
                          saturationValue:(CGFloat)saturationValue
                          brightnessValue:(CGFloat)brightnessValue
                            contrastValue:(CGFloat)contrastValue
{
    NSSize size = [self size];
    NSRect bounds = { NSZeroPoint, size };
    NSImage *tintedImage = [[NSImage alloc] initWithSize:size];

    [tintedImage lockFocus];

    CIFilter *monochromeFilter = [CIFilter filterWithName:@"CIColorMonochrome"];
    [monochromeFilter setDefaults];
    [monochromeFilter setValue:[CIImage imageWithData:[self TIFFRepresentation]] forKey:@"inputImage"];
    [monochromeFilter setValue:[CIColor colorWithRed:0 green:0 blue:0 alpha:1] forKey:@"inputColor"];
    [monochromeFilter setValue:[NSNumber numberWithFloat:1] forKey:@"inputIntensity"];

    CIFilter *colorFilter = [CIFilter filterWithName:@"CIColorControls"];
    [colorFilter setDefaults];
    [colorFilter setValue:[monochromeFilter valueForKey:@"outputImage"] forKey:@"inputImage"];
    [colorFilter setValue:[NSNumber numberWithFloat:saturationValue]  forKey:@"inputSaturation"];
    [colorFilter setValue:[NSNumber numberWithFloat:brightnessValue] forKey:@"inputBrightness"];
    [colorFilter setValue:[NSNumber numberWithFloat:contrastValue] forKey:@"inputContrast"];

    [[colorFilter valueForKey:@"outputImage"] drawAtPoint:NSZeroPoint
                                                 fromRect:bounds
                                                operation:NSCompositeCopy
                                                 fraction:alphaValue];

    [tintedImage unlockFocus];

    return tintedImage;
}

+ (NSImage *)imageFromBezierPath:(NSBezierPath *)path color:(NSColor *)color {


    NSImage *image = [[NSImage alloc] initWithSize:CGSizeMake(18, 18)];
    [image lockFocus];

//    NSRect aRect=NSMakeRect(0.0,0.0,20.0,20.0);
//    NSBezierPath *thePath=[NSBezierPath bezierPathWithRect:aRect];
    [color set];
    [path stroke];

    [image unlockFocus];

    return image;

}

+ (NSImage *)imageWithCIImage:(CIImage *)i fromRect:(CGRect)r
{
    NSImage *image;
    NSCIImageRep *ir;

    ir = [NSCIImageRep imageRepWithCIImage:i];
    image = [[NSImage alloc] initWithSize:
              NSMakeSize(r.size.width, r.size.height)]
             ;
    [image addRepresentation:ir];
    return image;
}

+ (NSImage *)imageWithCIImage:(CIImage *)i
{
    return [self imageWithCIImage:i fromRect:[i extent]];
}

@end
