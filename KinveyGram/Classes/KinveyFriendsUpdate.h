//
//  KinveyFriendsUpdate.h
//  KinveyGram
//
//  Copyright (c) 2012 Kinvey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KinveyKit/KinveyKit.h>

/** This class represents an indivual post to the service */
@interface KinveyFriendsUpdate : NSObject <KCSPersistable>

@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) NSString* author;
@property (nonatomic, retain) NSString* kinveyId;
@property (nonatomic, retain) NSDate* userDate;
@property (nonatomic, retain) UIImage* attachment;
@property (nonatomic, retain) KCSMetadata* meta;

@end
