//
//  UIColor+KinveyHelpers.m
//
//  Copyright (c) 2012 Kinvey. All rights reserved.
//

#import "UIColor+KinveyHelpers.h"

@implementation UIColor (KinveyHelpers)

+ (UIColor*) colorWithIntRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue
{
    return [self colorWithRed:red/255. green:green/255. blue:blue/255. alpha:1.];
}

+ (UIColor*) kinveyOrange
{
    return [UIColor colorWithIntRed:241 green:89 blue:42];
}

+ (UIColor*) kinveyBlue
{
    return [UIColor colorWithIntRed:29 green:54 blue:84];
}

- (UIColor*) brightenBy:(CGFloat)brightnessMod
{
    CGFloat hue;
    CGFloat satuation;
    CGFloat brightness;
    CGFloat alpha;
    if ([self getHue:&hue saturation:&satuation brightness:&brightness alpha:&alpha]) {
        brightness = MIN(1., MAX(0., brightness + brightnessMod));
        return [UIColor colorWithHue:hue saturation:satuation brightness:brightness alpha:alpha];
    } else {
        return self;
    }
}

- (UIColor*) darkerColor
{
    return [self brightenBy:-.33];
}

- (UIColor*) lighterColor
{
    return [self brightenBy:.33];
}

@end
