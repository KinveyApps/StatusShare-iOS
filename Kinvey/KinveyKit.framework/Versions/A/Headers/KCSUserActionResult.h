//
//  KCSUserActionResult.h
//  KinveyKit
//
//  Created by Victor Barros on 2015-08-24.
//  Copyright (c) 2015 Kinvey. All rights reserved.
//

#ifndef KinveyKit_KCSUserActionResult_h
#define KinveyKit_KCSUserActionResult_h

typedef NS_ENUM(NSInteger, KCSUserActionResult) {
    KCSUserNoInformation = -1,
    KCSUserCreated = 1,
    KCSUserDeleted = 2,
    KCSUserFound = 3,
    KCSUSerNotFound = 4,
    KCSUserInteractionCancel = 5,
    KCSUserInteractionTimeout = 6
};

#endif
