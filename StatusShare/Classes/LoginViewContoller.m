//
//  LoginViewContoller.m
//  StatusShare
//
//  Copyright (c) 2012 Kinvey. All rights reserved.
//

#import "LoginViewContoller.h"

#import <KinveyKit/KinveyKit.h>
#import <FacebookSDK/FacebookSDK.h>

#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface LoginViewContoller()
@end

@implementation LoginViewContoller
@synthesize loginButton;
@synthesize userNameTextField;
@synthesize passwordTextField;
@synthesize createAccountButton;
@synthesize facebookLoginButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [self setLoginButton:nil];
    [self setUserNameTextField:nil];
    [self setPasswordTextField:nil];
    [self setCreateAccountButton:nil];
    [self setFacebookLoginButton:nil];
    [super viewDidUnload];
}


- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    
    ///Kinvey-Use code: if the user is already logged in, go straight to the main part of the app via segue
    if ([KCSUser hasSavedCredentials] == YES) {
        [self performSegueWithIdentifier:@"toTable" sender:self];
    }
}

#pragma mark - TextField Stuff
- (UIView*) button
{
    return self.loginButton;
}
      
- (void) validate
{
    self.loginButton.enabled = self.userNameTextField.text.length > 0 && self.passwordTextField.text.length > 0; 
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self validate];
    return NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self validate];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self validate];
    if (textField == self.userNameTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        if (self.loginButton.enabled) {
            [self login:self.loginButton];
        }
    }
    return YES;
}


#pragma mark - Actions
- (void) disableButtons:(NSString*) message;
{
    self.loginButton.enabled = NO;
    self.createAccountButton.enabled = NO; 
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = message;
}

- (void) reenableButtons
{
    [self validate];
    self.createAccountButton.enabled = YES;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void) handeLogin:(NSError*)errorOrNil
{
    [self reenableButtons];
    if (errorOrNil != nil) {
        BOOL wasUserError = [errorOrNil domain] == KCSUserErrorDomain;
        NSString* title = wasUserError ? NSLocalizedString(@"Invalid Credentials", @"credentials error title") : NSLocalizedString(@"An error occurred.", @"Generic error message");
        NSString* message = wasUserError ? NSLocalizedString(@"Wrong username or password. Please check and try again.", @"credentials error message") : [errorOrNil localizedDescription];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message                                                           delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        //clear fields on success
        self.userNameTextField.text = @"";
        self.passwordTextField.text = @"";
        //logged in went okay - go to the table
        [self performSegueWithIdentifier:@"toTable" sender:self];
    }
 
}

- (IBAction)login:(id)sender
{
    [self disableButtons:NSLocalizedString(@"Logging in", @"Logging In Message")];
    
    ///Kinvey-Use code: login with the typed credentials
    [KCSUser loginWithUsername:self.userNameTextField.text password:self.passwordTextField.text withCompletionBlock:^(KCSUser *user, NSError *errorOrNil, KCSUserActionResult result) {
        [self handeLogin:errorOrNil];
    }];
}

- (IBAction)loginWithFacebook:(id)sender
{
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    FBSession* session = [delegate session];

    // if the session isn't open, let's open it now and present the login UX to the user
    if (!session.isOpen) {
        [session openWithCompletionHandler:^(FBSession *session,
                                             FBSessionState status,
                                             NSError *error) {
            if (status == FBSessionStateOpen) {
                NSString* accessToken = session.accessToken;
                [KCSUser loginWithFacebookAccessToken:accessToken withCompletionBlock:^(KCSUser *user, NSError *errorOrNil, KCSUserActionResult result) {
                    [self handeLogin:errorOrNil];
                }];
            }
        }];
    }
}
      
- (IBAction)createAccount:(id)sender
{
    [self performSegueWithIdentifier:@"pushToCreateAccount" sender:self];
}
@end
