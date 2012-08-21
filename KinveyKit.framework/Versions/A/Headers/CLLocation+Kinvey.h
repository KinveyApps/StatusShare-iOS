//
//  CLLocation+Kinvey.h
//  KinveyKit
//
//  Created by Michael Katz on 8/20/12.
//  Copyright (c) 2012 Kinvey. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (Kinvey)
- (NSArray*) kinveyValue;
+ (CLLocation*) locationFromKinveyValue:(NSArray*)kinveyValue;
@end
