//
//  UpdateCell.h
//  StatusShare
//
//  Copyright (c) 2012 Kinvey. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAvatarSize 48.

@class KinveyFriendsUpdate;

@interface UpdateCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic)
IBOutlet UILabel *textLabel;

@property (retain, nonatomic) UILabel* timeLabel;

@property (retain, nonatomic) UIImageView* avatar;
@property (retain, nonatomic) UIImageView* thumbnailView;
@property (retain, nonatomic) UIImageView* pinView;

- (void) setUpdate:(KinveyFriendsUpdate*)update;

@end
