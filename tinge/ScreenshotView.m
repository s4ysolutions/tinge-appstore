//
//  ScreenshotView.m
//  Tinge
//
//  Created by Sergey Dolin on 8/2/16.
//  Copyright (c) 2016 S4Y. All rights reserved.
//

#import "ScreenshotView.h"
#import "CropView.h"

@implementation ScreenshotView {
@private
    CGImageRef _image;
    CropView* _cropView;
    NSObject<ScreenshotDelegator>* _delegator;
   // float scale;
}

- (id)initWithCGImage:(CGImageRef)anImage
{
    // scale = 1;
    NSRect frame=NSMakeRect(0, 0, CGImageGetWidth(anImage), CGImageGetHeight(anImage));
    self = [super initWithFrame:frame];
    if (self) {
        _image = (CGImageRef)CFRetain(anImage);
        _cropView = [[CropView alloc] initWithFrame:frame];
        [_cropView setScreenshotView:self];
        [self addSubview:_cropView];
        [_cropView release];
    }
    return self;
}

- (void)dealloc {
    if (_image)
        CFRelease(_image);
    [super dealloc];
}


- (void)setDelegator:(NSObject<ScreenshotDelegator> *)delegator{
    [_delegator release];
    _delegator=[delegator retain];
}


- (void) drawImage
{
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    if (context==nil)
        return;
    
    if (_image==nil)
        return;
    
    CGRect imageRect = [self frame];
    /*
    CGRect rd = CGContextConvertRectToDeviceSpace(context, imageRect);
    scale = rd.size.width/imageRect.size.width;
    NSLog(@"scale %f of %f,%f", scale, imageRect.size.width, rd.size.width);
    */
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    CGContextDrawImage(context, imageRect, _image);
}

- (void)drawRect:(NSRect)dirtyRect
{
    [self drawImage];
}

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (void)screenshotWasCroppedWithA:(CGPoint) a andB:(CGPoint) b
{
    float scale = [[NSScreen mainScreen] backingScaleFactor];
    NSLog(@"Mouse  %f,%f %f,%f",a.x, a.y, b.x, b.y);
    a.x*=scale;
    b.x*=scale;
    a.y*=scale;
    b.y*=scale;
    NSLog(@"Mouse scaled by %f %f,%f %f,%f",scale, a.x, a.y, b.x, b.y);
    CGRect rs = CGRectMake(a.x,
                           (CGImageGetHeight(_image)-b.y),
                           b.x-a.x,
                           b.y-a.y);
    
    CGImageRef cropped=CGImageCreateWithImageInRect(_image,rs);
    NSLog(@"Screenshot size: %zu x %zu",CGImageGetWidth(_image), CGImageGetHeight(_image));
    NSLog(@"Crop screenshot %f,%f %f,%f",rs.origin.x,rs.origin.y,rs.size.width,rs.size.height);
    if (cropped)
        [_delegator screenshot:_image wasCropped: cropped];
    else
        NSLog(@"Can't crop screenshot %f,%f %f,%f",rs.origin.x,rs.origin.y,rs.size.width,rs.size.height);
    CGImageRelease(cropped);
};

@end
