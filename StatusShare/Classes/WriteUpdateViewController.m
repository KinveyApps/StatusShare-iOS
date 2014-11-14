//
//  WriteUpdateViewController.m
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


#import "WriteUpdateViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import <KinveyKit/CLLocation+Kinvey.h>

#import "StatusShareUpdate.h"
#import "UIColor+KinveyHelpers.h"

@interface WriteUpdateViewController ()
@property (nonatomic, retain) id<KCSStore> updateStore;
@property (nonatomic, retain) UIImage* attachedImage;
@property (nonatomic, retain) CLLocationManager* locationManager;
@end

@implementation WriteUpdateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    public = YES;
    
    //Kinvey use code: create a new collection with a linked data store
    // no KCSStoreKeyOfflineSaveDelegate is specified
    KCSCollection* collection = [KCSCollection collectionFromString:@"Updates" ofClass:[StatusShareUpdate class]];
    self.updateStore = [KCSLinkedAppdataStore storeWithOptions:@{ KCSStoreKeyResource : collection,
                                                                  KCSStoreKeyCachePolicy : @(KCSCachePolicyBoth),
                                                                  KCSStoreKeyOfflineUpdateEnabled : @(YES)}];
    [[KCSClient sharedClient] setOfflineDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardUpdated:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardUpdated:) name:UIKeyboardDidShowNotification object:nil];
    
    //Kinvey use code: watch for network reachability to change so we can update the UI make a post able to send. 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:KCSReachabilityChangedNotification object:nil];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];

    [self.locationManager stopUpdatingLocation];
    
    [self setLocationManager:nil];
    [self setUpdateTextView:nil];
    [self setMainView:nil];
    [self setBottomToolbar:nil];
    [self setBottomToolbar:nil];
    [self setPostButton:nil];
    [self setGeoButtonItem:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}

- (void) viewWillAppear:(BOOL)animated
{
//    [self.updateTextView becomeFirstResponder];
    
    //Kinvey use code: only enable the post button if Kinvey is reachable
    self.postButton.enabled = [[[KCSClient sharedClient] networkReachability] isReachable];
    
    self.geoButtonItem.enabled = [CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - network
- (void) reachabilityChanged:(NSNotification*) note
{
    self.postButton.enabled = [[[KCSClient sharedClient] networkReachability] isReachable];    
}

#pragma mark - Text View

- (void) keyboardUpdated:(NSNotification*)note
{
    CGRect endFrame = [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    endFrame = [self.view.superview.window convertRect:endFrame toView:self.view.superview];
    CGRect bottomFrame = self.bottomToolbar.frame;
    bottomFrame = CGRectMake(0, CGRectGetMinY(endFrame) - bottomFrame.size.height, bottomFrame.size.width, bottomFrame.size.height);
    self.bottomToolbar.frame = bottomFrame;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}



#pragma mark - Actions
- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)post:(id)sender
{
    if (self.updateTextView.text.length > 0) {
        StatusShareUpdate* update = [[StatusShareUpdate alloc] init];
        update.text = self.updateTextView.text;
        update.userDate = [NSDate date];
        if (self.attachedImage != nil) {
            update.attachment = self.attachedImage;
        }
        if (!public) {
            if (!update.meta) {
                update.meta = [[KCSMetadata alloc] init];
            }
            [update.meta setGloballyReadable:NO];
        }
        if (location && [CLLocationManager locationServicesEnabled]) {
            CLLocation* l = [self.locationManager location];
            update.location = l;
        }
        
        //Kinvey use code: add a new update to the updates collection
        [self.updateStore saveObject:update withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil == nil) {
                self.updateTextView.text = @"";
                [self cancel:nil];
            } else {
                BOOL wasNetworkError = [[errorOrNil domain] isEqual:KCSNetworkErrorDomain];
                NSString* title = wasNetworkError ? NSLocalizedString(@"There was a netowrk error.", @"network error title"): NSLocalizedString(@"An error occurred.", @"Generic error message");
                NSString* message = wasNetworkError ? NSLocalizedString(@"Please wait a few minutes and try again.", @"try again error message") : [errorOrNil localizedDescription];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                                message:message                                                           delegate:self 
                                                      cancelButtonTitle:NSLocalizedString(@"OK", @"OK") 
                                                      otherButtonTitles:nil];
                [alert show];
            }
        } withProgressBlock:nil];
    }
    
}

- (IBAction)takePicture:(id)sender 
{
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

#pragma mark - pictures

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    self.attachedImage = nil;
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissModalViewControllerAnimated:YES];
    self.attachedImage = image;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat scale = [self.view.window.screen scale];
        CGSize size = CGSizeMake(24., 24.);
        UIGraphicsBeginImageContextWithOptions(size, YES, scale);
        CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationHigh);
        [image drawInRect:CGRectMake(0., 0., size.width, size.height)];
        UIImage* thumb = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIImageView* thumbView = [[UIImageView alloc] initWithImage:thumb];
        thumbView.userInteractionEnabled = YES;
        UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithCustomView:thumbView];
        button.target = self;
        button.action = @selector(takePicture:);
        NSMutableArray* oldItems = [NSMutableArray arrayWithArray:self.bottomToolbar.items];
        [oldItems replaceObjectAtIndex:oldItems.count - 1 withObject:button];
        [self.bottomToolbar setItems:oldItems animated:YES];
    });
}

- (IBAction)togglePrivacy:(id)sender 
{
    public = !public;
    UIBarButtonItem* item = sender;
    [item setImage:[UIImage imageNamed:(public ? @"unlock" : @"lock")]];
}

- (IBAction)toggleGeolocation:(id)sender
{
    location = !location;
    UIBarButtonItem* item = sender;
    item.tintColor = location ? [[[UIColor greenColor] darkerColor] colorWithAlphaComponent:0.5]: nil;
    if (location) {
        if ([CLLocationManager locationServicesEnabled]) {
            //set up the location manger
            self.locationManager = [[CLLocationManager alloc] init];
            _locationManager.delegate = self; //we don't actually care about updates since only the current loc is used
            [_locationManager startUpdatingLocation];
        }
    } else {
        [_locationManager stopUpdatingLocation];
    }
}

#pragma mark - Offline Save Delegate

// don't save any queued saves that older than a day
- (BOOL) shouldSaveObject:(NSString *)objectId inCollection:(NSString *)collectionName lastAttemptedSaveTime:(NSDate *)saveTime
{
    NSTimeInterval oneDayAgo = 60 /* sec/min */ * 60 /* min/hr */ * 24 /* hr/day*/; //because NSTimeInterval in seconds
    if ([saveTime timeIntervalSinceNow] > oneDayAgo) {
        return NO;
    } else {
        return YES;
    }
}

@end
