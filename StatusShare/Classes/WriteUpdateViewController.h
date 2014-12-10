//
//  WriteUpdateViewController.h
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


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <KinveyKit/KinveyKit.h>

@interface WriteUpdateViewController : UIViewController <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, KCSOfflineUpdateDelegate> {
    
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
