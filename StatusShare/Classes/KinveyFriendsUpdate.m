//
//  KinveyFriendsUpdate.m
//  StatusShare
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
