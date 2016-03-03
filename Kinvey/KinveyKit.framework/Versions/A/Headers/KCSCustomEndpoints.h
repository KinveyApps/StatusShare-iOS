//
//  KCSCustomEndpoints.h
//  KinveyKit
//
//  Created by Michael Katz on 5/30/13.
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

#ifndef KinveyKit_KCSCustomEndpoints_h
#define KinveyKit_KCSCustomEndpoints_h

#import <Foundation/Foundation.h>
#import "KCSBlockDefs.h"
#import "KCSRequest.h"

/**
 Class to wrap Custom Business Logic Endpoints.
 @since 1.17.0
 */
@interface KCSCustomEndpoints : NSObject

/** Call a custom endpoint
 @param endpoint the name of the custom endpoint
 @param params the body paramaters to pass to the endpoint
 @param completionBlock the response block. `results` will be the value returned by your business logic, and `error` will be non-nil if an error occurred.
 @return KCSRequest object that represents the pending request made against the store. Since version 1.36.0
 @since 1.17.0
 */
+(KCSRequest*)callEndpoint:(NSString*)endpoint
                    params:(NSDictionary*)params
           completionBlock:(KCSCustomEndpointBlock)completionBlock;

@end

#endif
