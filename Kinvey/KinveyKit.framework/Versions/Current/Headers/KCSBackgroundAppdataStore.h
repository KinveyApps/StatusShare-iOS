//
//  KCSBackgroundAppdataStore.h
//  KinveyKit
//
//  Copyright (c) 2015 Kinvey. All rights reserved.
//
// This software is licensed to you under the Kinvey terms of service located at
// http://www.kinvey.com/terms-of-use. By downloading, accessing and/or using this
// software, you hereby accept such terms of service  (and any agreement referenced
// therein) and agree that you have read, understand and agree to be bound by such
// terms of service and are of legal age to agree to such terms with Kinvey.
//
// This software contains valuable confidential and proprietary information of
// KINVEY, INC and is subject to applicable licensing agreements.
// Unauthorized reproduction, transmission or distribution of this file and its
// contents is a violation of applicable laws.
//

#ifndef KinveyKit_KCSBackgroundAppdataStore_h
#define KinveyKit_KCSBackgroundAppdataStore_h

#import <Foundation/Foundation.h>

#import "KCSStore.h"
#import "KCSRequest.h"
#import "KCSCacheUpdatePolicy.h"

@class KCSCollection;
@interface KCSBackgroundAppdataStore : NSObject <KCSStore>

@property (nonatomic, strong) KCSAuthHandler *authHandler KCS_DEPRECATED(Auth handler not used, 1.22.0);

/**
 Enable delta set caching for this store. This optimize the time to retrieve objects from the server since it will only return the delta between the local cache and the Kinvey server.
 */
@property (nonatomic) KCSCacheUpdatePolicy cacheUpdatePolicy;


+ (instancetype) storeWithCollection:(KCSCollection*)collection options:(NSDictionary*)options;

+ (instancetype)storeWithCollection:(KCSCollection*)collection authHandler:(KCSAuthHandler *)authHandler withOptions: (NSDictionary *)options KCS_DEPRECATED(Auth handler not used--use storeWithCollection:options: instead, 1.22.0);

-(KCSRequest*)loadObjectWithID:(id)objectID
           withCompletionBlock:(KCSCompletionBlock)completionBlock
             withProgressBlock:(KCSProgressBlock)progressBlock;

-(KCSRequest*)group:(id)fieldOrFields
             reduce:(KCSReduceFunction*)function
    completionBlock:(KCSGroupCompletionBlock)completionBlock
      progressBlock:(KCSProgressBlock)progressBlock;

-(KCSRequest*)group:(id)fieldOrFields
             reduce:(KCSReduceFunction*)function
          condition:(KCSQuery*)condition
    completionBlock:(KCSGroupCompletionBlock)completionBlock
      progressBlock:(KCSProgressBlock)progressBlock;

#pragma mark -  Information
-(KCSRequest*)countWithBlock:(KCSCountBlock)countBlock;

-(KCSRequest*)countWithQuery:(KCSQuery*)query
                  completion:(KCSCountBlock)countBlock;

@end

#endif
