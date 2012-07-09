//
//  UpdateCell.m
//  KinveyGram
//
//  Copyright (c) 2012 Kinvey. All rights reserved.
//

#import "UpdateCell.h"

#import <QuartzCore/QuartzCore.h>

#import "KinveyFriendsUpdate.h"

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
@synthesize nameLabel, textLabel, timeLabel, avatar, thumbnailView;

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
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(265., 8., 34., 18.)]; //width - 
        timeLabel.textColor = [UIColor colorWithIntRed:173 green:174 blue:173];
        timeLabel.font = [UIFont systemFontOfSize:12.];
        timeLabel.textAlignment = UITextAlignmentRight;
        timeLabel.backgroundColor = [UIColor clearColor];
        [bgView addSubview:timeLabel];
        
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

- (void) setUpdate:(KinveyFriendsUpdate*)update
{
    self.nameLabel.text = update.author;
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
    
    KCSCollection* users = [KCSCollection collectionFromString:@"friends" ofClass:[KCSEntityDict class]];
    KCSCachedStore* userStore = [KCSCachedStore storeWithOptions:[NSDictionary dictionaryWithObjectsAndKeys:users, KCSStoreKeyResource, [NSNumber numberWithInt:KCSCachePolicyLocalFirst], KCSStoreKeyCachePolicy, nil]];
    [userStore loadObjectWithID:update.author withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (objectsOrNil && objectsOrNil.count > 0) {
            KCSEntityDict* user = [objectsOrNil objectAtIndex:0];
            NSString* name = [user getValueForProperty:@"userName"];
            nameLabel.text = name;
            
            NSUInteger size = [[UIScreen mainScreen]  scale] * kAvatarSize;
            GravatarStore* store = [GravatarStore storeWithOptions:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:size], GravatarStoreOptionSizeKey, nil]];
            [store queryWithQuery:name withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                UIImage* image = [objectsOrNil objectAtIndex:0];
                self.avatar.image = image;
            } withProgressBlock:nil];
        }
    } withProgressBlock:nil];
}

@end
