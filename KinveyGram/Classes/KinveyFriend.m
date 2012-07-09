//
//  KinveyFriend.m
//  KinveyGram
//
//  Copyright (c) 2012 Kinvey. All rights reserved.
//

#import "KinveyFriend.h"

@implementation KinveyFriend 
@synthesize userName;
@synthesize kinveyId;

// Kinvey code use: any "KCSPersistable" has to implement this mapping method
- (NSDictionary *)hostToKinveyPropertyMapping
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"userName", @"userName",
            @"_id", @"kinveyId", nil];
}

@end
