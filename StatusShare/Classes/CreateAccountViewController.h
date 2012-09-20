//
//  CreateAccountViewController.h
//  StatusShare
//
//  Copyright (c) 2012 Kinvey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormViewController.h"

@interface CreateAccountViewController : FormViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *passwordRepeat;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
- (IBAction)createNewAccount:(id)sender;
@end
