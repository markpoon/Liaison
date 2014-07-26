//
//  UserViewController.h
//  Liaison
//
//  Created by Ascended on 2013-06-26.
//  Copyright (c) 2013 Arete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserViewController : UIViewController <UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (assign, nonatomic) NSInteger index;
@property (atomic) User* user;
@property (atomic) NSArray* photos;
- (IBAction)chatWithUser:(id)sender;

@end
