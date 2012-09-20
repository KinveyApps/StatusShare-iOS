//
//  WriteUpdateViewController.h
//  StatusShare
//
//  Copyright (c) 2012 Kinvey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <KinveyKit/KinveyKit.h>

@interface WriteUpdateViewController : UIViewController <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, KCSOfflineSaveDelegate> {
    
    BOOL public;
    BOOL location;
}

@property (weak, nonatomic) IBOutlet UITextView *updateTextView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *geoButtonItem;


- (IBAction)cancel:(id)sender;
- (IBAction)post:(id)sender;
- (IBAction)takePicture:(id)sender;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolbar;
- (IBAction)togglePrivacy:(id)sender;
- (IBAction)toggleGeolocation:(id)sender;


@end
