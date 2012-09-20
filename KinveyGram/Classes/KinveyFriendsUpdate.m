//
//  KinveyFriendsUpdate.m
//  StatusShare
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
@synthesize location = _location;

// Kinvey code use: any "KCSPersistable" has to implement this mapping method
- (NSDictionary *)hostToKinveyPropertyMapping
{
    return @{
    @"text"       : @"text",
    @"userDate"   : @"userDate",
    @"attachment" : @"attachment",
    @"meta"       : KCSEntityKeyMetadata,
    @"kinveyId"   : KCSEntityKeyId,
    @"location"   : KCSEntityKeyGeolocation,
    };
}
@end
