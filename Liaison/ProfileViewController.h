//
//  ProfileViewController.h
//  Liaison
//
//  Created by Ascended on 2013-06-19.
//  Copyright (c) 2013 Arete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"


@interface ProfileViewController : UITableViewController<UITextFieldDelegate, NSFetchedResultsControllerDelegate>

@property (atomic) User* user;

- (IBAction)unwind:(id)sender;

@end
