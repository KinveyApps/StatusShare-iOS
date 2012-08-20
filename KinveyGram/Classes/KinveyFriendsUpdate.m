//
//  KinveyFriendsUpdate.m
//  KinveyGram
//
//  Copyright (c) 2012 Kinvey. All rights reserved.
//

#import "KinveyFriendsUpdate.h"

@implementation KinveyFriendsUpdate
@synthesize text = _text;
@synthesize kinveyId = _kinveyId;
@synthesize userDate = _userDate;
@synthesize attachment = _attachment;
@synthesize meta = _meta;

// Kinvey code use: any "KCSPersistable" has to implement this mapping method
- (NSDictionary *)hostToKinveyPropertyMapping
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"text", @"text",
            KCSEntityKeyId, @"kinveyId",
            @"userDate", @"userDate",
            @"attachment", @"attachment",
            KCSEntityKeyMetadata, @"meta",
            nil];
}
@end
