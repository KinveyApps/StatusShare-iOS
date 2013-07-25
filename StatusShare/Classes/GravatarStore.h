//
//  GravatarStore.h
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


#import <Foundation/Foundation.h>
#import <KinveyKit/KinveyKit.h>


#define GravatarStoreErrorDomain @"GravatarStoreDomain"
#define GravatarStoreOptionSizeKey @"GravatarSize"

#define GravatarStoreOptionDefaultIconKey @"GravatarDefaultIcon"

/** These are defined by the Gravatar API: https://en.gravatar.com/site/implement/images/
 */

/** Do not load any image if none is associated with the email hash, instead return an error */
#define GravatarDefaultIconError @"404"
/** (mystery-man) a simple, cartoon-style silhouetted outline of a person (does not vary by email) */
#define GravatarDefaultIconMysteryMan @"mm"
/** a geometric pattern based on email */
#define GravatarDefaultIconIdenticon @"identicon"
/** a generated 'monster' with different colors, faces, etc */
#define GravatarDefaultIconMonster @"monsterid"
/** generated faces with differing features and backgrounds */
#define GravatarDefaultIconWavatar @"wavatar"
/** awesome generated, 8-bit arcade-style pixelated faces */
#define GravatarDefaultIconRetro @"retro"

#define GravatarStoreOptionRatingKey @"GravatarRating"

/** suitable for display on all websites with any audience type */
#define GravatarStoreRatingG @"g"
/** may contain rude gestures, provocatively dressed individuals, the lesser swear words, or mild violence */
#define GravatarStoreRatingPG @"pg"
/** may contain such things as harsh profanity, intense violence, nudity, or hard drug use */
#define GravatarStoreRatingR @"r"
/** may contain hardcore sexual imagery or extremely disturbing violence */
#define GravatarStoreRatingX @"x"

/**
 A sample `KCSStore` that uses the Gravatar.com API to load avatar images for a specified email address. 
 
 This store only supports query operations, since it is a read-only API. 
 
 Send the email address as a `NSString` query object. 
 
 Exammple:
 <pre class="code">GravatarStore* store = [GravatarStore storeWithOptions:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:size], GravatarStoreOptionSizeKey, nil]];</pre>
 */
@interface GravatarStore : NSObject <KCSStore> 
@end
