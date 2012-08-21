//
//  WriteUpdateViewController.m
//  KinveyGram
//
//  Copyright (c) 2012 Kinvey. All rights reserved.
//

#import "WriteUpdateViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import <KinveyKit/CLLocation+Kinvey.h>

#import "KinveyFriendsUpdate.h"
#import "UIColor+KinveyHelpers.h"

@interface WriteUpdateViewController ()
@property (nonatomic, retain) id<KCSStore> updateStore;
@property (nonatomic, retain) UIImage* attachedImage;
@property (nonatomic, retain) CLLocationManager* locationManager;
@end

@implementation WriteUpdateViewController
@synthesize bottomToolbar;
@synthesize updateTextView;
@synthesize mainView;
@synthesize postButton;
@synthesize geoButtonItem;
@synthesize updateStore;
@synthesize attachedImage;
@synthesize locationManager;


- (void)viewDidLoad
{
    [super viewDidLoad];
    public = YES;
    
    //Kinvey use code: create a new collection with a linked data store
    // no KCSStoreKeyOfflineSaveDelegate is specified
    KCSCollection* collection = [KCSCollection collectionFromString:@"Updates" ofClass:[KinveyFriendsUpdate class]];
    self.updateStore = [KCSLinkedAppdataStore storeWithOptions:@{ KCSStoreKeyResource : collection, KCSStoreKeyCachePolicy : @(KCSCachePolicyBoth), KCSStoreKeyUniqueOfflineSaveIdentifier : @"WriteUpdateViewController" , KCSStoreKeyOfflineSaveDelegate : self }];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardUpdated:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //Kinvey use code: watch for network reachability to change so we can update the UI make a post able to send. 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kKCSReachabilityChangedNotification object:nil];
    
    if ([CLLocationManager locationServicesEnabled]) {
        //set up the location manger
        self.locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self; //we don't actually care about updates since only the current loc is used
        [locationManager startUpdatingLocation];
    }
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
    [self.updateTextView becomeFirstResponder];
    
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
    endFrame = [self.mainView.superview.window convertRect:endFrame toView:self.mainView.superview];
    CGRect textFrame = mainView.frame;
    textFrame.size.height = CGRectGetMinY(endFrame) - CGRectGetMinY(textFrame);
    self.mainView.frame = textFrame;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}



#pragma mark - Actions
- (IBAction)cancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)post:(id)sender
{
    if (self.updateTextView.text.length > 0) {
        KinveyFriendsUpdate* update = [[KinveyFriendsUpdate alloc] init];
        update.text = updateTextView.text;
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
            update.location = [l kinveyValue];
        }
        
        //Kinvey use code: add a new update to the updates collection
        [updateStore saveObject:update withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil == nil) {
                updateTextView.text = @"";
                [self cancel:nil];
            } else {
                BOOL wasNetworkError = [errorOrNil domain] == KCSNetworkErrorDomain;
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
    
    [self presentModalViewController:imagePicker animated:YES];
}

#pragma mark - pictures

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    self.attachedImage = nil;
    [self dismissModalViewControllerAnimated:YES];
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
}

#pragma mark - Offline Save Delegate

// don't save any queued saves that older than a day
- (BOOL) shouldSave:(id<KCSPersistable>)entity lastSaveTime:(NSDate *)timeSaved
{
    NSTimeInterval oneDayAgo = 60 /* sec/min */ * 60 /* min/hr */ * 24 /* hr/day*/; //because NSTimeInterval in seconds
    if ([timeSaved timeIntervalSinceNow] < oneDayAgo) {
        return NO;
    } else {
        return YES;
    }
}
@end
