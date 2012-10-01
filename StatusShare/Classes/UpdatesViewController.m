//
//  UpdatesViewController.m
//  StatusShare
//
//  Copyright (c) 2012 Kinvey. All rights reserved.
//

#import "UpdatesViewController.h"
#import <KinveyKit/KinveyKit.h>

#import "KinveyFriendsUpdate.h"
#import "UpdateCell.h"

#import "AuthorViewController.h"

#import "GravatarStore.h"
#import "UIColor+KinveyHelpers.h"

@implementation UpdatesCell
@end

@interface UpdatesViewController ()
@property (nonatomic, retain) NSArray* updates;
@property (nonatomic, retain) KCSCachedStore* updateStore;

- (void) updateList;
@end

@implementation UpdatesViewController
@synthesize updates;
@synthesize updateStore;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithIntRed:220 green:220 blue:220];
    
    KCSCollection* collection = [KCSCollection collectionFromString:@"Updates" ofClass:[KinveyFriendsUpdate class]];
    self.updateStore = [KCSLinkedAppdataStore storeWithOptions:[NSDictionary dictionaryWithObjectsAndKeys:collection, KCSStoreKeyResource, [NSNumber numberWithInt:KCSCachePolicyBoth], KCSStoreKeyCachePolicy, nil]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(startCompose:)];
    UIBarButtonItem* logoutButton = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Logout", @"Logout button") style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    self.navigationItem.leftBarButtonItem = logoutButton;
    
    [self updateList];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (KinveyFriendsUpdate*) updateAtIndex:(NSUInteger)index
{
    return [self.updates objectAtIndex:index];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[AuthorViewController class]]) {
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        KinveyFriendsUpdate* update = [self updateAtIndex:indexPath.row];
        
        [segue.destinationViewController setAuthor:[update.meta creatorId]];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.updates == nil ? 0 : [self.updates count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48. + 16. + ([[self.updates objectAtIndex:indexPath.row] attachment] != nil ? 250. : 0.);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UpdateCell *thisCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!thisCell) {
        
        thisCell = [[UpdateCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    KinveyFriendsUpdate* update = [self updateAtIndex:indexPath.row];
    [thisCell setUpdate:update];
    
   
    return thisCell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"segueToAuthor" sender:tableView];
}

#pragma mark - Text Field
- (BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)refresh
{
    [self updateList];
}

#pragma mark - Compose
- (void) startCompose:(id)sender
{
    [self performSegueWithIdentifier:@"coverWithWrite" sender:sender];
}

#pragma mark - Kinvey Methods

- (void) updateList
{
    KCSQuery* query = [KCSQuery query];
    KCSQuerySortModifier* sortByDate = [[KCSQuerySortModifier alloc] initWithField:@"userDate" inDirection:kKCSDescending];
    [query addSortModifier:sortByDate]; //sort the return by the date field
    [query setLimitModifer:[[KCSQueryLimitModifier alloc] initWithLimit:10]]; //just get back 10 results
    [updateStore queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (objectsOrNil) {
            [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
            self.updates = objectsOrNil;
            [self.tableView reloadData];
        }
    } withProgressBlock:nil];
}

- (void) logout
{
    self.updates = [NSArray array]; //clear array so that the previous user's data is cached if a different user logins in immediately
    [[[KCSClient sharedClient] currentUser] logout];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
