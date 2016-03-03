//
//  KCSIncrementalCache.h
//  KinveyKit
//
//  Created by Victor Barros on 2015-09-25.
//  Copyright © 2015 Kinvey. All rights reserved.
//

#ifndef KinveyKit_KCSCacheUpdatePolicy_h
#define KinveyKit_KCSCacheUpdatePolicy_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, KCSCacheUpdatePolicy) {
    KCSCacheUpdatePolicyLoadFull = 0,
    KCSCacheUpdatePolicyLoadIncremental,
};

#endif
