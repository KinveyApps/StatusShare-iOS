//
//  KinveyUser.h
//  KinveyKit
//
//  Copyright (c) 2008-2012, Kinvey, Inc. All rights reserved.
//
//  This software contains valuable confidential and proprietary information of
//  KINVEY, INC and is subject to applicable licensing agreements.
//  Unauthorized reproduction, transmission or distribution of this file and its
//  contents is a violation of applicable laws.

#import <Foundation/Foundation.h>
#import "KinveyPersistable.h"
#import "KinveyEntity.h"

@class KCSCollection;
@class KCSRESTRequest;

// Need to predefine our classes here
@class KCSUser;
@class KCSUserResult;

typedef NSInteger KCSUserActionResult;

enum {
    KCSUserCreated = 1,
    KCSUserDeleted = 2,
    KCSUserFound = 3,
    KCSUSerNotFound = 4
};

typedef void (^KCSUserCompletionBlock)(KCSUser* user, NSError* errorOrNil, KCSUserActionResult result);

/*!  Describes required methods for an object wishing to be notified about the status of user actions.
 *
 * This Protocol should be implemented by a client for processing the results of any User Actions against the Kinvey
 * service that deals with users.
 *
 * The completion status is one of the following: 
 * 
 * - KCSUserCreated
 * - KCSUserDeleted
 * - KCSUserFound
 * - KCSUSerNotFound
 * 
 */
@protocol KCSUserActionDelegate <NSObject>

///---------------------------------------------------------------------------------------
/// @name Success
///---------------------------------------------------------------------------------------
/*! Called when a User Request completes successfully.
 * @param user The user the action was performed on.
 * @param result The results of the completed request
 *
 */
- (void)user: (KCSUser *)user actionDidCompleteWithResult: (KCSUserActionResult)result;

///---------------------------------------------------------------------------------------
/// @name Failure
///---------------------------------------------------------------------------------------
/*! Called when a User Request fails for some reason (including network failure, internal server failure, request issues...)
 * 
 * Use this method to handle failures.
 *  @param user The user the operation was performed on.
 *  @param error An object that encodes our error message.
 */
- (void)user: (KCSUser *)user actionDidFailWithError: (NSError *)error;

@end


/*! User in the Kinvey System
 
 All Kinvey requests must be made using an authorized user, if a user doesn't exist, an automatic user generation
 facility exists (given a username Kinvey can generate and store a password).  More user operations are available to the
 client, but are not required to be used.
 
 Since all requests *must* be made through a user, the library maintains the concept of a current user, which is the
 user used to make all requests.  Convienience routines are available to manage the state of this Current User.
 
 */
@interface KCSUser : NSObject <KCSPersistable>

///---------------------------------------------------------------------------------------
/// @name User Information
///---------------------------------------------------------------------------------------
/*! Username of this Kinvey User */
@property (nonatomic, copy) NSString *username;
/*! Password of this Kinvey User */
@property (nonatomic, copy) NSString *password;
/*! Device Tokens of this User */
@property (nonatomic, copy) NSArray *deviceTokens;


+ (BOOL) hasSavedCredentials;

///---------------------------------------------------------------------------------------
/// @name KinveyKit Internal Services
///---------------------------------------------------------------------------------------
/*! Initialize the "Current User" for Kinvey
 
 This will cause the system to initialize the "Current User" to the known "primary" user for the device
 should no user exist, one is created.  If a non-nil request is provided, the request will be started after
 user authentication.
 
 @warning This routine is not intended for application developer use, this routine is used by the library runtime to ensure all requests are authenticated.
 
 @warning This is a *blocking* routine and will block on other threads that are authenticating.  There is a short timeout before authentication failure.
 
 @param request The REST request to perform after authentication.
 
*/
- (void)initializeCurrentUserWithRequest: (KCSRESTRequest *)request;

/*! Initialize the "Current User" for Kinvey
 
 This will cause the system to initialize the "Current User" to the known "primary" user for the device
 should no user exist, one is created.
 
 @warning This routine is not intended for application developer use, this routine is used by the library runtime to ensure all requests are authenticated.
 
 @warning This is a *blocking* routine and will block on other threads that are authenticating.  There is a short timeout before authentication failure.
 
 */
- (void)initializeCurrentUser;

// Private method
+ (void)initCurrentUser;

///---------------------------------------------------------------------------------------
/// @name Creating Users
///---------------------------------------------------------------------------------------
/*! Create a new Kinvey user and register them with the backend.
 * @param username The username to create, if it already exists on the back-end an error will be returned.
 * @param password The user's password
 * @param delegate The delegate to inform once creation completes
*/
+ (void)userWithUsername: (NSString *)username password: (NSString *)password withDelegate: (id<KCSUserActionDelegate>)delegate;


/** Create a new Kinvey user and register them with the backend.
 * @param username The username to create, if it already exists on the back-end an error will be returned.
 * @param password The user's password
 * @param completionBlock The callback to perform when the creation completes (or errors).
 */
+ (void) userWithUsername:(NSString *)username password:(NSString *)password withCompletionBlock:(KCSUserCompletionBlock)completionBlock;


///---------------------------------------------------------------------------------------
/// @name Managing the Current User
///---------------------------------------------------------------------------------------
/*! Login an existing user, generates an error if the user doesn't exist
 * @param username The username of the user
 * @param password The user's password
 * @param delegate The delegate to inform once the action is complete
*/
+ (void)loginWithUsername: (NSString *)username password: (NSString *)password withDelegate: (id<KCSUserActionDelegate>)delegate;

/*! Login an existing user, generates an error if the user doesn't exist
 * @param username The username of the user
 * @param password The user's password
 * @param completionBlock The block that is called when the action is complete
 */
+ (void)loginWithUsername: (NSString *)username
                 password: (NSString *)password 
      withCompletionBlock:(KCSUserCompletionBlock)completionBlock;

/*! Removes a user and their data from Kinvey
 * @param delegate The delegate to inform once the action is complete.
*/
- (void)removeWithDelegate: (id<KCSPersistableDelegate>)delegate;

/*! Logout the user.
*/
- (void)logout;

///---------------------------------------------------------------------------------------
/// @name Using User Attributes
///---------------------------------------------------------------------------------------
/*! Load the data for the given user, user must be logged-in.
 *
 * @param delegate The delegate to inform once the action is complete.
 */
- (void)loadWithDelegate: (id<KCSEntityDelegate>)delegate;

/*! Called to update the Kinvey state of a user.
 * @param delegate The delegate to inform once the action is complete.
 */
- (void)saveWithDelegate: (id<KCSPersistableDelegate>)delegate;

/*! Return the value for an attribute for this user
 * @param attribute The attribute to retrieve
 */
- (id)getValueForAttribute: (NSString *)attribute;

/*! Set the value for an attribute
 * @param value The value to set.
 * @param attribute The attribute to modify.
 */
- (void)setValue: (id)value forAttribute: (NSString *)attribute;

/*! Called when a User Request completes successfully.
 * @return The KCSCollection to access users.
 */
- (KCSCollection *)userCollection;





@end
