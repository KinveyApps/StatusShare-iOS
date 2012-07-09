//
//  CreateAccountViewController.m
//  KinveyGram
//
//  Copyright (c) 2012 Kinvey. All rights reserved.
//

#import "CreateAccountViewController.h"

#import <KinveyKit/KinveyKit.h>

#import "KinveyFriend.h"

#define kMinPasswordLength 4
#define kMinUsernameLength 4

@implementation CreateAccountViewController
@synthesize userName;
@synthesize password;
@synthesize passwordRepeat;
@synthesize createButton;


- (void)viewDidUnload {
    [self setUserName:nil];
    [self setPassword:nil];
    [self setPasswordRepeat:nil];
    [self setCreateButton:nil];
    [super viewDidUnload];
}

- (IBAction)createNewAccount:(id)sender 
{
    NSString* username = userName.text;
    
    //Kinvey-Use code: create a new user
    [KCSUser userWithUsername:userName.text password:password.text withCompletionBlock:^(KCSUser *user, NSError *errorOrNil, KCSUserActionResult result) {
        if (errorOrNil == nil) {
            //In addition to creating the user that is used for login-purposes, this app also creates a public "user" entity that is for display in the table
            KinveyFriend* newUser = [[KinveyFriend alloc] init];
            newUser.kinveyId = user.kinveyObjectId;
            newUser.userName = user.username;
            [newUser saveToCollection:[KCSCollection collectionFromString:@"friends" ofClass:[KinveyFriend class]] withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                //do nothing - assume it goes through ok
                //for a real app, you should cache this information and resend when appropriate until it is accepted
                [self.navigationController popViewControllerAnimated:YES];
            } withProgressBlock:nil];
        } else {
            BOOL wasUserError = [errorOrNil domain] == KCSUserErrorDomain;
            NSString* title = wasUserError ? [NSString stringWithFormat:NSLocalizedString(@"Could not create new user with username %@", @"create username error title"), username]: NSLocalizedString(@"An error occurred.", @"Generic error message");
            NSString* message = wasUserError ? NSLocalizedString(@"Please choose a different username.", @"create username error message") : [errorOrNil localizedDescription];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                            message:message                                                           delegate:self 
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK") 
                                                  otherButtonTitles:nil];
            [alert show];

        }
    }];
}



#pragma mark - Text Field Stuff
- (UIView*) button
{
    return self.createButton;
}

- (void) validate
{
    if (password.text.length > kMinPasswordLength && [password.text isEqualToString:passwordRepeat.text] && userName.text.length > kMinUsernameLength) {
        createButton.enabled = YES;
    } else {
        createButton.enabled = NO;
    }
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
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
    return YES;
}
@end
