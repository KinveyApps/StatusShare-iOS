//
//  KinveyPersistable.h
//  KinveyKit
//
//  Copyright (c) 2008-2011, Kinvey, Inc. All rights reserved.
//
//  This software contains valuable confidential and proprietary information of
//  KINVEY, INC and is subject to applicable licensing agreements.
//  Unauthorized reproduction, transmission or distribution of this file and its
//  contents is a violation of applicable laws.

#import <Foundation/Foundation.h>

// Forward declaration to have access to the KCSClient definition in this protocol definition.
@class KCSCollection;

/*! Defines the implementation details of a class expecting to perform actions after the completion of a save operation.

Developers interested in performing actions based on the state of a save operation should conform to this protocol.

 */
@protocol KCSPersistableDelegate <NSObject>

/*! Invoked when a save operation fails
 @param entity The Object that was attempting to be saved.
 @param error A detailed description of the error.
 */
- (void) entity: (id)entity operationDidFailWithError: (NSError *)error;

/*! Invoked when a save operation completes successfully.
 @param entity The Object that was attempting to be saved.
 @param result The result of the operation (NOTE: The value of this result is still changing, do not count on the value yet)
 */
- (void) entity:(id)entity operationDidCompleteWithResult: (NSObject *)result;

@end

/*! Definies the interface for a persistable object.

This protocol is used to inform that this object is able to be saved to the Kinvey Cloud Service.  The methods
defined in this protocol are used to determine what data to save and then to actually save the data.

The KCSEntity category on NSObject conforms to this protocol, providing a default implementation of this protocol
for all NSObject descendants.  You may directly implement this protocol in order to provide actions not accomplished by
the default methods provided.  See method documentation for important information about restrictions on clients when
implementing these methods.
 
 @bug Only hostToKinveyPropertyMapping should be implemented by the library user, the implementation provided by the KCSEntity category
 should be used for all other methods.
 
 */
@protocol KCSPersistable <NSObject>
///---------------------------------------------------------------------------------------
/// @name Save Items
///---------------------------------------------------------------------------------------
/*!  Save an Entity into KCS for a given KCS client and register a delegate to notify when complete.

  When overriding this method an implementer will most likely need to communicate with the KCSClient class,
 which has a different delegate interface.  An implementer will need to map between these delegates.  This does
 not apply to using the built-in implementation.
 
 @warning It is strongly advised to not override this method.

 @param collection An instance of a KCS collection to use in saving this Entity
 @param delegate The delegate to inform upon the completion of the save operation.
 

 */
- (void)saveToCollection: (KCSCollection *)collection withDelegate: (id <KCSPersistableDelegate>)delegate;

///---------------------------------------------------------------------------------------
/// @name Delete Items
///---------------------------------------------------------------------------------------
/*! Delete an entity from Kinvey and register a delegate for notification.
 When overriding this method an implementer will most likely need to communicate with the KCSClient class,
 which has a different delegate interface.  An implementer will need to map between these delegates.  This does
 not apply to using the built-in implementation.
 
 @warning It is strongly advised to not override this method.
 
 @param delegate The delegate to inform upon the completion of the delet operation.
 @param collection The collection to remove the item from.
*/ 

- (void)deleteFromCollection: (KCSCollection *)collection withDelegate: (id<KCSPersistableDelegate>)delegate;

///---------------------------------------------------------------------------------------
/// @name Map from Local to Kinvey property names
///---------------------------------------------------------------------------------------

/** Kinvey backend key for an entity's unique id */
#define KCSEntityKeyId @"_id"
/** Kinvey backend key for metadata information */
#define KCSEntityKeyMetadata @"_kinveymeta"

/*! Provide the mapping from an Entity's representation to the Native Objective-C representation.
 
 
 
 A simple implementation of a mapping function is:

 Header file:
    @property (retain, readonly) NSDictionary *mapping;

 Implimentation File:
        @synthesize mapping;

        - (id)init
        {
            self = [super init];
            if (self){
                mapping = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"EntityProperty1", @"InstanceVariableName1",
                    @"EntityProperty2", @"InstanceVariableName2", nil];

            }
        }
        - (NSDictionary *)propertyToElementMapping
        {
            return mapping;
        }

 
 
 @bug In this beta version of KCS this method has no default implementation and will raise an exception if the default
 implementation is used.

 @return The dictionary that maps from objective-c to Kinvey (JSON) mapping.

 */
- (NSDictionary*)hostToKinveyPropertyMapping;

#define KCS_USE_DESIGNATED_INITIALIZER_MAPPING_KEY @"KCS_DESIGNATED_INITIALIZER_MAPPING_KEY"
#define KCS_USE_DICTIONARY_KEY @"KCS_DICTIONARY_MAPPER_KEY"
#define KCS_DICTIONARY_NAME_KEY @"KCS_DICTIONARY_NAME_KEY"
#define kCS_DICTIONARY_DATATYPE_BUILDER @"KCS_DICTIONARY_DATATYPE_BUILDER"

///---------------------------------------------------------------------------------------
/// @name Advanced Options (Here Be Dragons!)
///---------------------------------------------------------------------------------------

/*! Returns an NSDictionary that details advanced object building options.
 
 Most users of Kinvey will not need to use this feature.  Please be careful.
 
 Options recognized:
 - KCS_USE_DESIGNATED_INITIALIZER_MAPPING_KEY -- If set to YES, KinveyKit will build your objects via: kinveyObjectBuilderOptions
 - KCS_USE_DICTIONARY_KEY -- If set Kinvey will use a a dictionary to map data to Kinvey
 - KCS_DICTIONARY_NAME_KEY -- The name of the Instance Variable that is the dictionary to map.
 
 If KCS_USE_DICTIONARY_KEY is set to an NSNumber representing YES then KinveyKit will look for at the value for KCS_DICTIONARY_NAME_KEY.
 It will then look in your object for a property whos name is this value and is of type NSDictionary.  It will store all Key-Value pairs
 in this dictionary to the collection on the backend as individual properties (eg, the dictionary is not stored, but the key-values end
 up stored as property-values in Kinvey).  When fetching from Kinvey any properties that are not in the mapping function are placed
 as key-values into this dictionary.

 @return A dictionary that stores a subset of the above options that KinveyKit will use to determine advanced options.
 
 */
+ (NSDictionary *)kinveyObjectBuilderOptions;

/*! Override the initializer that KinveyKit uses to build objects of this type
 
 If specified in the kinveyObjectBuilderOptions dictionary, this method will be
 called to build objects instead of [[[self class] alloc] init].  This method
 _must_ return an instantiated object of the class that implements this protocol.
 This routine does not release the generated object.
 
 @return An instantiated object of the class implementing this protocol
 
 */
+ (id)kinveyDesignatedInitializer;


@end
