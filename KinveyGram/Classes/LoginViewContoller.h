//
//  LoginViewContoller.h
//  KinveyGram
//
//  Copyright (c) 2012 Kinvey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormViewController.h"

@interface LoginViewContoller : FormViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;

- (IBAction)login:(id)sender;

@end
