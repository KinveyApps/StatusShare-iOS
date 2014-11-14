//
//  GravatarStore.m
//  StatusShare
//
//  Copyright 2013 Kinvey, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
    id store = [[self alloc] init];
    [store configureWithOptions:options];
    return store;
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
    NSString* url = [NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=%ld&d=%@&r=%@", [query md5], (unsigned long)_defaultSize, _defaultIcon, _defaultRating];
    
    NSURLRequest *theRequest = [NSURLRequest
                                requestWithURL:[NSURL URLWithString:url]
                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                timeoutInterval:60.0];
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:NULL error:&error];
    
    UIImage* image = [UIImage imageWithData:data];
    NSArray* objects = image ? @[image] :nil;
    
    completionBlock(objects, error);
}

- (void)saveObject: (id)object withCompletionBlock: (KCSCompletionBlock)completionBlock withProgressBlock: (KCSProgressBlock)progressBlock
{
    //Return an error since the Gravatar API is read-only
    completionBlock(nil, [NSError errorWithDomain:GravatarStoreErrorDomain code:KCSNotSupportedError userInfo:nil]);
}

- (void)removeObject: (id)object withCompletionBlock:(KCSCountBlock)completionBlock withProgressBlock: (KCSProgressBlock)progressBlock;
{
    //Return an error since the Gravatar API is read-only
    completionBlock(0, [NSError errorWithDomain:GravatarStoreErrorDomain code:KCSNotSupportedError userInfo:nil]);
}

@end
