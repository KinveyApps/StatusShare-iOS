//
//  KinveyFriend.h
//  KinveyGram
//
//  Copyright (c) 2012 Kinvey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KinveyKit/KinveyKit.h>

/** KinveyFriend is the entity that represents the public information about an individual user in KinveyGram. This object is backed by the "friends" collection for the app. */
@interface KinveyFriend : NSObject <KCSPersistable>

@property (nonatomic) NSString* userName;
@property (nonatomic) NSString* kinveyId;

@end
