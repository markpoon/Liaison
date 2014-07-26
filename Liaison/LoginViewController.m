//
//  LoginViewController.m
//  Liason
//
//  Created by Ascended on 2013-05-16.
//  Copyright (c) 2013 Ascended. All rights reserved.
//

#import "LoginViewController.h"
#import "KDJKeychainItemWrapper.h"

@interface LoginViewController()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation LoginViewController
@synthesize fetchedResultsController = _fetchedResultsController;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _logoCell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkForUser)];
    tapped.numberOfTapsRequired = 1;
    [_SubmitButton addGestureRecognizer:tapped];
    
    // Set debug logging level. Set to 'RKLogLevelTrace' to see JSON payload
    RKLogConfigureByName("RestKit/Network", RKLogLevelDebug);
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"api_id" ascending:NO];
    fetchRequest.sortDescriptors = @[descriptor];
    
    // Setup fetched results
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
    [self.fetchedResultsController setDelegate:self];
    // cache login/password input
    KDJKeychainItemWrapper* keys = [[KDJKeychainItemWrapper alloc] initWithIdentifier:@"Liaison" accessGroup:nil];
    self.loginViewEmail.text = [keys objectForKey:@"acct"];
    self.loginViewPassword.text = [keys objectForKey:@"v_Data"];
}
- (void)checkForUser
{
    // cache login/password input
    
    KDJKeychainItemWrapper* keys = [[KDJKeychainItemWrapper alloc] initWithIdentifier:@"Liaison" accessGroup:nil];
    [keys setObject:self.loginViewEmail.text forKey:@"acct"];
    [keys setObject:self.loginViewPassword.text forKey:@"v_Data"];
    [[RKObjectManager sharedManager].HTTPClient setAuthorizationHeaderWithUsername:[keys objectForKey:@"acct"] password:[keys objectForKey:@"v_Data"]];
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/login" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self performSelector:@selector(toUsers)];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];
}
-(void)toUsers{
    [self performSegueWithIdentifier:@"segueToUsers" sender:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    }

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _loginViewPassword){
        [self checkForUser];
    }else{
        [_loginViewPassword becomeFirstResponder];
    }
    return YES;
}
#pragma mark NSFetchedResultsControllerDelegate methods

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    
}

@end
