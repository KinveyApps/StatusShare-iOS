//
//  FormViewController.m
//  StatusShare
//
//  Copyright (c) 2012 Kinvey. All rights reserved.
//

#import "FormViewController.h"
#import "UIColor+KinveyHelpers.h"

@implementation FormViewBackgroundView

- (void) drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    NSArray* colors = [NSArray arrayWithObjects:(id) [UIColor colorWithIntRed:21 green:78 blue:176].CGColor, (id) [UIColor colorWithIntRed:25 green:89 blue:189].CGColor, nil];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef fillGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, NULL);
    CGContextDrawLinearGradient(ctx, fillGradient, CGPointMake(0, CGRectGetMinY(rect)), CGPointMake(0, CGRectGetMaxY(rect)), 0);
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(fillGradient);
    
    CGContextRestoreGState(ctx);
}

@end

@interface FormViewController ()
@property (retain, nonatomic) UITapGestureRecognizer* tapToDismiss;

@end

@implementation FormViewController
@synthesize tapToDismiss;
@synthesize scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resize:) name:UIKeyboardDidChangeFrameNotification object:nil];
    self.tapToDismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    self.tapToDismiss.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:self.tapToDismiss];
}
- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [self setTapToDismiss:nil];
    [self.view removeGestureRecognizer:tapToDismiss];

    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self.navigationController action:@selector(popViewControllerAnimated:)];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Keyboard managment
- (UIView*) button 
{
    return nil;
}

- (void) resize:(NSNotification*)note
{
    CGRect rect = [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    rect = [self.view.window convertRect:rect toView:self.scrollView];
    CGFloat y = rect.origin.y >= self.view.bounds.size.height ? 0 : CGRectGetMaxY([self button].frame) + 5 - rect.origin.y;
    [self.scrollView setContentOffset:CGPointMake(0, y) animated:YES];
}


- (void) dismissKeyboard
{
    [self.view endEditing:YES];
}

@end
