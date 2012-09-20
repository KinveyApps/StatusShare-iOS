//
//  GravatarStore.h
//  StatusShare
//
//  Copyright (c) 2012 Kinvey. All rights reserved.
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
