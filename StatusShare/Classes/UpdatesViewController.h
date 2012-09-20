//
//  UpdatesViewController.h
//  StatusShare
//
//  Copyright (c) 2012 Kinvey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"

@interface UpdatesCell : UITableViewCell 
@end

@interface UpdatesViewController : PullRefreshTableViewController <UITextFieldDelegate>

@end
