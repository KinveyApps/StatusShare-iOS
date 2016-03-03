//
//  KCSRequest.h
//  KinveyKit
//
//  Created by Victor Barros on 2015-08-26.
//  Copyright (c) 2015 Kinvey. All rights reserved.
//

#ifndef KinveyKit_KCSRequest_h
#define KinveyKit_KCSRequest_h

#import <Foundation/Foundation.h>

typedef void(^KCSRequestCancelationBlock)();

/*!
 Represents a pending request made against a store. Holding an instance of this class allows you, for example, to cancel a pending request.
 @since 1.36.0
 */
@interface KCSRequest : NSObject

/*! Flag indicating if the request was cancelled or not. */
@property (readonly, getter=isCancelled) BOOL cancelled;

/*! Block called in response to request cancellation. */
@property (copy) KCSRequestCancelationBlock cancellationBlock;

/*! Cancel the pending request. */
-(void)cancel;

@end

#endif
