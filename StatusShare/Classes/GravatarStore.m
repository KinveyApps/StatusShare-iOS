//
//  GravatarStore.m
//  StatusShare
//
//  Copyright (c) 2012 Kinvey. All rights reserved.
//

#import "GravatarStore.h"
#import "MD5Helpers.h"

#define kDefaultGravatarSize 48
#define kDefaultGravatarIcon GravatarDefaultIconIdenticon
#define kDefaultGravatarRating GravatarStoreRatingG

@interface GravatarStore () {
@private
    NSUInteger _defaultSize;
    NSString* _defaultIcon;
    NSString* _defaultRating;
}
@end


@implementation GravatarStore

+ (id)store
{
    return [self storeWithOptions:[NSDictionary dictionary]];
}

+ (id)storeWithOptions:(NSDictionary *)options
{
    return [self storeWithAuthHandler:nil withOptions:options];
}

+ (id) storeWithAuthHandler:(KCSAuthHandler *)authHandler withOptions:(NSDictionary *)options
{
    id store = [[self alloc] init];
    [store configureWithOptions:options];
    return store;
}

- (BOOL)configureWithOptions: (NSDictionary *)options
{
    _defaultSize = [options objectForKey:GravatarStoreOptionSizeKey] ? [[options objectForKey:GravatarStoreOptionSizeKey] intValue] : kDefaultGravatarSize;
    _defaultIcon = [options objectForKey:GravatarStoreOptionDefaultIconKey] ? [options objectForKey:GravatarStoreOptionDefaultIconKey] : kDefaultGravatarIcon; 
    _defaultRating = [options objectForKey:GravatarStoreOptionRatingKey] ? [options objectForKey:GravatarStoreOptionRatingKey] : kDefaultGravatarRating; 
    return YES;
}

- (void)setAuthHandler: (KCSAuthHandler *)handler
{
    // No auth handler needed for Gravatar
}

- (KCSAuthHandler*) authHandler
{
    return nil;  // No auth handler needed for Gravatar
}

- (void)queryWithQuery:(id)query withCompletionBlock:(KCSCompletionBlock)completionBlock withProgressBlock:(KCSProgressBlock)progressBlock
{
    //query should be one email address
    NSString* url = [NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=%i&d=%@&r=%@", [query md5], _defaultSize, _defaultIcon, _defaultRating];
    
    NSURLRequest *theRequest = [NSURLRequest
                                requestWithURL:[NSURL URLWithString:url]
                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                timeoutInterval:60.0];
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:NULL error:&error];
    UIImage* image = [UIImage imageWithData:data];
    
    completionBlock([NSArray arrayWithObject:image], error);
}

- (void)saveObject: (id)object withCompletionBlock: (KCSCompletionBlock)completionBlock withProgressBlock: (KCSProgressBlock)progressBlock
{
    //Return an error since the Gravatar API is read-only
    completionBlock(nil, [NSError errorWithDomain:GravatarStoreErrorDomain code:KCSNotSupportedError userInfo:nil]);
}

- (void)removeObject: (id)object withCompletionBlock: (KCSCompletionBlock)completionBlock withProgressBlock: (KCSProgressBlock)progressBlock
{
    //Return an error since the Gravatar API is read-only
    completionBlock(nil, [NSError errorWithDomain:GravatarStoreErrorDomain code:KCSNotSupportedError userInfo:nil]);   
}

@end
