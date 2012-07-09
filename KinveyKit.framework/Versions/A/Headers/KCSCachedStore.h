//
//  KCSCachedStore.h
//  KinveyKit
//
//  Copyright (c) 2012 Kinvey, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCSStore.h"
#import "KCSAppdataStore.h"

/** Cache Policies. These constants determine the caching behavior when used with KCSChacedStore query. */
typedef enum KCSCachePolicy {
    /** No Caching - all queries are sent to the server */
    KCSCachePolicyNone,
    KCSCachePolicyLocalOnly,
    KCSCachePolicyLocalFirst,
    KCSCachePolicyNetworkFirst,
    KCSCachePolicyBoth
} KCSCachePolicy;

#define KCSStoreKeyCachePolicy @"cachePolicy"

/**
 This application data store caches queries, depending on the policy.
 
 Available caching policies:
 
 - `KCSCachePolicyNone` - No caching, all queries are sent to the server.
 - `KCSCachePolicyLocalOnly` - Only the cache is queried, the server is never called. If a result is not in the cache, an error is returned.
 - `KCSCachePolicyLocalFirst` - The cache is queried and if the result is stored, the `completionBlock` is called with that value. The cache is then updated in the background. If the cache does not contain a result for the query, then the server is queried first.
 - `KCSCachePolicyNetworkFirst` - The network is queried and the cache is updated with each result. The cached value is only returned when the network is unavailable. 
 - `KCSCachePolicyBoth` - If available, the cached value is returned to `completionBlock`. The network is then queried and cache updated, afterwards. The `completionBlock` will be called again with the updated result from the server.
 
 For an individual store, the chace policy can inherit from the defaultCachePolicy, be set using storeWithOptions: factory constructor, supplying the enum for the key `KCSStoreKeyCahcePolicy`.
 */
@interface KCSCachedStore : KCSAppdataStore <KCSStore> {
    NSCache* _cache;
}

/** @name Cache Policy */

/** The cache policy used, by default, for this store */
@property (nonatomic, readwrite) KCSCachePolicy cachePolicy;

#pragma mark - Default Cache Policy
/** gets the default cache policy for all new KCSCachedStore's */
+ (KCSCachePolicy) defaultCachePolicy;
/** Sets the default cache policy for all new KCSCachedStore's.
 @param cachePolicy the default `KCSCachePolicy` for all new stores.
 */
+ (void) setDefaultCachePolicy:(KCSCachePolicy)cachePolicy;

/** @name Querying/Fetching */

/**  Load objects from the store with the given IDs.
 
 @param objectID this is an individual ID or an array of IDs to load
 @param completionBlock A block that gets invoked when all objects are loaded
 @param progressBlock A block that is invoked whenever the store can offer an update on the progress of the operation.
 @param cachePolicy override the object's cachePolicy for this load only.
 @see [KCSAppdataStore loadObjectWithID:withCompletionBlock:withProgressBlock:]
 */
- (void)loadObjectWithID:(id)objectID 
     withCompletionBlock:(KCSCompletionBlock)completionBlock
       withProgressBlock:(KCSProgressBlock)progressBlock
             cachePolicy:(KCSCachePolicy)cachePolicy;

/** Query or fetch an object (or objects) in the store.
 
 This method takes a query object and returns the value from the server or cache, depending on the supplied `cachePolicy`. 
 
 This method might be used when you know the network is unavailable and you want to use `KCSCachePolicyLocalOnly` until the network connection is reestablished, and then go back to using the store's normal policy.
 
 @param query A query to act on a store.  The store defines the type of queries it accepts, an object of type "KCSAllObjects" causes all objects to be returned.
 @param completionBlock A block that gets invoked when the query/fetch is "complete" (as defined by the store)
 @param progressBlock A block that is invoked whenever the store can offer an update on the progress of the operation.
 @param cachePolicy the policy for to use for this query only. 
 */
- (void)queryWithQuery:(id)query withCompletionBlock:(KCSCompletionBlock)completionBlock withProgressBlock:(KCSProgressBlock)progressBlock cachePolicy:(KCSCachePolicy)cachePolicy;

/*! Aggregate objects in the store and apply a function to all members in that group.
 
 This method will find the objects in the store, collect them with other other objects that have the same value for the specified fields, and then apply the supplied function on those objects. Right now the types of functions that can be applied are simple mathematical operations. See KCSReduceFunction for more information on the types of functions available.
 
 @param fieldOrFields The array of fields to group by (or a single `NSString` field name). If multiple field names are supplied the groups will be made from objects that form the intersection of the field values. For instance, if you have two fields "a" and "b", and objects "{a:1,b:1},{a:1,b:1},{a:1,b:2},{a:2,b:2}" and apply the `COUNT` function, the returned KCSGroup object will have an array of 3 objects: "{a:1,b:1,count:2},{a:1,b:2,count:1},{a:2,b:2,count:1}". For objects that don't have a value for a given field, the value used will be `NSNull`.
 @param function This is the function that is applied to the items in the group. If you do not want to apply a function, just use queryWithQuery:withCompletionBlock:withProgressBlock: instead and query for items that match specific field values.
 @param condition This is a KCSQuery object that is used to filter the objects before grouping. Only groupings with at least one object that matches the condition will appear in the resultant KCSGroup object. 
 @param completionBlock A block that is invoked when the grouping is complete, or an error occurs. 
 @param progressBlock A block that is invoked whenever the store can offer an update on the progress of the operation.
 @param cachePolicy override the object's cachePolicy for this group query only.
 @see [KCSAppdataStore group:reduce:condition:completionBlock:progressBlock:]
 */
- (void)group:(id)fieldOrFields reduce:(KCSReduceFunction *)function condition:(KCSQuery *)condition completionBlock:(KCSGroupCompletionBlock)completionBlock progressBlock:(KCSProgressBlock)progressBlock cachePolicy:(KCSCachePolicy)cachePolicy;

#if BUILD_FOR_UNIT_TEST
- (void) setReachable:(BOOL)reachOverwrite;
#endif
@end
