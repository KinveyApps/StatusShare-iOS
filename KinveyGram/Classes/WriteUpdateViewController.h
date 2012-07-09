//
//  WriteUpdateViewController.h
//  KinveyGram
//
//  Copyright (c) 2012 Kinvey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteUpdateViewController : UIViewController <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
    BOOL public;
}

@property (weak, nonatomic) IBOutlet UITextView *updateTextView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postButton;


- (IBAction)cancel:(id)sender;
- (IBAction)post:(id)sender;
- (IBAction)takePicture:(id)sender;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolbar;
- (IBAction)togglePrivacy:(id)sender;

@end
