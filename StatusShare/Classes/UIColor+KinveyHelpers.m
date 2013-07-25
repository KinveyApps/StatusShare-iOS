//
//  UIColor+KinveyHelpers.m
//
//  Copyright 2013 Kinvey, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
