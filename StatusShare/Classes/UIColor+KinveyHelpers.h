//
//  UIColor+KinveyHelpers.h
//
//  Copyright (c) 2012 Kinvey. All rights reserved.
//

#import <UIKit/UIKit.h>

/* Just some common color tasks for Kinvey Sample Apps */
@interface UIColor (KinveyHelpers)

+ (UIColor*) colorWithIntRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue;

+ (UIColor*) kinveyOrange;
+ (UIColor*) kinveyBlue;

- (UIColor*) darkerColor;
- (UIColor*) lighterColor;
@end
