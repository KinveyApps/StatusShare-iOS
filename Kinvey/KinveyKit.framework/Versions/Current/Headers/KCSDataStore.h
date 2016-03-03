//
//  KCSDataStore.h
//  KinveyKit
//
//  Copyright (c) 2013-2015 Kinvey. All rights reserved.
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

#import "KCSRequest.h"

typedef void(^KCSDataStoreCompletion)(NSArray* objects, NSError* error);
typedef void(^KCSDataStoreObjectCompletion)(NSDictionary* object, NSError* error);
typedef void(^KCSDataStoreCountCompletion)(NSUInteger count, NSError* error);

@class KCSQuery2;
@protocol KCSNetworkOperation;

@interface KCSDataStore : NSObject

- (instancetype)initWithCollection:(NSString*)collection;

-(KCSRequest*)getAll:(KCSDataStoreCompletion)completion;

-(KCSRequest*)countAll:(KCSDataStoreCountCompletion)completion;

-(KCSRequest*)query:(KCSQuery2*)query
            options:(NSDictionary*)options
         completion:(KCSDataStoreCompletion)completion;

-(KCSRequest*)countQuery:(KCSQuery2*)query
              completion:(KCSDataStoreCountCompletion)completion;

//TODO: KK2(base methods should be void, advanced should have the op return)
-(KCSRequest*)deleteEntity:(NSString*)_id
                completion:(KCSDataStoreCountCompletion)completion;

-(KCSRequest*)deleteEntity:(NSString*)_id
          deleteCompletion:(KCSDataStoreObjectCompletion)completion;

-(KCSRequest*)deleteByQuery:(KCSQuery2*)query
                 completion:(KCSDataStoreCountCompletion)completion;

-(KCSRequest*)deleteByQuery:(KCSQuery2*)query
           deleteCompletion:(KCSDataStoreObjectCompletion)completion;

@end
