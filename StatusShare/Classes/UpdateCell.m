//
//  UpdateCell.m
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


#import "UpdateCell.h"

#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FacebookSDK.h>

#import "StatusShareUpdate.h"

#import "UIColor+KinveyHelpers.h"
#import "GravatarStore.h"

#define kThumbnailSize 250.

@interface CellBgView : UIView

@end

@implementation CellBgView

- (void) drawRect:(CGRect)rect
{
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:rect];
    [[UIColor colorWithIntRed:172 green:172 blue:172] setStroke];
    [path setLineWidth:1.];
    
    [[UIColor whiteColor] setFill];
    [path fill];
    
    [path stroke];
}

@end

@interface UpdateCell ()
@end

@implementation UpdateCell
@synthesize nameLabel, textLabel, timeLabel, avatar, thumbnailView, pinView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView setBackgroundColor:[UIColor colorWithIntRed:220 green:220 blue:220]];
        
        CellBgView* bgView = [[CellBgView alloc] initWithFrame:CGRectMake(0., 0., 100., 100.)];
        bgView.autoresizesSubviews = YES;
        bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        bgView.clipsToBounds = YES;
        [self.contentView addSubview:bgView];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(62., 8., 100, 16.)];
        nameLabel.font = [UIFont boldSystemFontOfSize:14.];
        nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        nameLabel.layer.borderColor = [UIColor redColor].CGColor;
        nameLabel.backgroundColor = [UIColor clearColor];
        
        [bgView addSubview:nameLabel];
        
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(62., CGRectGetMaxY(nameLabel.frame), 100., 20.)];
        textLabel.textColor = [UIColor colorWithIntRed:64 green:64 blue:64];
        textLabel.font = [UIFont systemFontOfSize:14.];
        textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [bgView addSubview:textLabel];
        
        CGRect timeFrame = CGRectMake(265., 8., 34., 18.);
        timeLabel = [[UILabel alloc] initWithFrame:timeFrame];
        timeLabel.textColor = [UIColor colorWithIntRed:173 green:174 blue:173];
        timeLabel.font = [UIFont systemFontOfSize:12.];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.backgroundColor = [UIColor clearColor];
        [bgView addSubview:timeLabel];
        
        CGFloat pinSize = 20.;
        pinView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timeFrame) - pinSize, CGRectGetMaxY(timeFrame) + 2., pinSize, pinSize)];
        pinView.image = [UIImage imageNamed:@"globe_green"];
        pinView.hidden = YES;
        [bgView addSubview:pinView];
        
        avatar = [[UIImageView alloc] initWithFrame:CGRectMake(8., 8., kAvatarSize, kAvatarSize)];
        avatar.layer.borderColor = [UIColor lightGrayColor].CGColor;
        avatar.layer.borderWidth = 1.0;
        avatar.layer.cornerRadius = 4.;
        avatar.layer.masksToBounds = YES;
        avatar.layer.shouldRasterize = YES;
        [bgView addSubview:avatar];
        
        
        thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(0., 0., kThumbnailSize, kThumbnailSize)];
        thumbnailView.contentMode = UIViewContentModeScaleAspectFit;
        thumbnailView.layer.borderColor = [UIColor blackColor].CGColor;
        thumbnailView.layer.borderWidth = 1.;
        [bgView addSubview:thumbnailView];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = CGRectMake(10., 0., self.bounds.size.width - 20., self.bounds.size.height);
    nameLabel.superview.frame = rect;
    [textLabel sizeToFit];
    
    CGRect thumbRect = thumbnailView.frame;
    thumbRect.origin.y = CGRectGetMaxY(avatar.frame);
    thumbRect.origin.x = CGRectGetMidX(rect) - thumbRect.size.width / 2.;
    thumbnailView.frame = CGRectIntegral(thumbRect);
    
    thumbnailView.hidden = thumbnailView.image == nil;
}

- (void) setUpdate:(StatusShareUpdate*)update
{
    self.nameLabel.text = [update.meta creatorId];
    self.textLabel.text = update.text;
    //Kinvey code usage: if a KCSLinkedAppdataStore is not used, then linked resources will be NSDictionaries of the image metadata rather than the UIImage itself
    if (update.attachment != nil && [update.attachment isKindOfClass:[UIImage class]]) {
        self.thumbnailView.image = update.attachment;
    } else {
        self.thumbnailView.image = nil;
    }
    
    NSDate* date = update.userDate;
    NSTimeInterval since = [[NSDate date] timeIntervalSinceDate:date];
    NSString* dateFormat = @"";
    if (since < 60) {
        dateFormat = @"now";
    } else if (since < 60 * 60) {
        dateFormat = [NSString stringWithFormat:@"%0.fm", since / 60];
    } else if ( since < 60 * 60 * 24) {
        dateFormat = [NSString stringWithFormat:@"%0.fh", since / (60 * 60)];
    } else {
        double days = since / (60 * 60 * 24);
        dateFormat = [NSString stringWithFormat:@"%0.fd", days];
    }
    self.timeLabel.text = dateFormat;
    self.pinView.hidden = update.location == nil;
    
    KCSCollection* users = [KCSCollection userCollection];
    KCSCachedStore* userStore = [KCSCachedStore storeWithOptions:[NSDictionary dictionaryWithObjectsAndKeys:users, KCSStoreKeyResource, [NSNumber numberWithInt:KCSCachePolicyLocalFirst], KCSStoreKeyCachePolicy, nil]];
    [userStore loadObjectWithID:[update.meta creatorId] withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (objectsOrNil && objectsOrNil.count > 0) {
            NSString* fbId = nil;
            KCSUser* user = [objectsOrNil objectAtIndex:0];
            NSString* name = user.username;
            NSDictionary *socialIdentity = [user getValueForAttribute:@"_socialIdentity"];
            if (socialIdentity != nil) {
                NSDictionary *facebookIdentity = [socialIdentity objectForKey:@"facebook"];
                if (facebookIdentity != nil) {
                    NSString* facebookName = [facebookIdentity objectForKey:@"name"];
                    if ((facebookName != nil) && ([facebookName length] > 0)) {
                        name = facebookName;
                    }
                    fbId = facebookIdentity[@"id"];
                }
            }
            self.nameLabel.text = name;
            
            NSUInteger size = [[UIScreen mainScreen]  scale] * kAvatarSize;
            if (fbId == nil) {
                GravatarStore* store = [GravatarStore storeWithOptions:@{GravatarStoreOptionSizeKey:@(size)}];
                [store queryWithQuery:name withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                    UIImage* image = [objectsOrNil objectAtIndex:0];
                    self.avatar.image = image;
                } withProgressBlock:nil];
            } else {
                NSString* imageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=%d&height=%d",fbId,size,size];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
                    if (imageData) {
                        UIImage* image = [UIImage imageWithData:imageData];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.avatar.image = image;
                        });
                    } else {
                        // if can't get facebook image, resort to gravatar
                        dispatch_async(dispatch_get_main_queue(), ^{
                            GravatarStore* store = [GravatarStore storeWithOptions:@{GravatarStoreOptionSizeKey:@(size)}];
                            [store queryWithQuery:name withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                                UIImage* image = [objectsOrNil objectAtIndex:0];
                                self.avatar.image = image;
                            } withProgressBlock:nil];
                        });
                    }
                });
            }
        }
    } withProgressBlock:nil];
}

@end
