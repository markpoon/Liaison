//
//  LoginViewController.h
//  Liason
//
//  Created by Ascended on 2013-05-16.
//  Copyright (c) 2013 Ascended. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Security/Security.h>

@interface LoginViewController : UITableViewController <UITextFieldDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *loginViewEmail;
@property (weak, nonatomic) IBOutlet UITextField *loginViewPassword;
@property (weak, nonatomic) IBOutlet UITableViewCell *logoCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *SubmitButton;

-(void)toUsers;
-(void)checkForUser;

@end
