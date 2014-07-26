//
//  PhotoViewController.h
//  Liaison
//
//  Created by Ascended on 2013-06-27.
//  Copyright (c) 2013 Arete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface PhotoViewController : UIViewController
@property (strong, nonatomic) Photo* photo;
@property (atomic) IBOutlet UIImageView *imageView;
@property (atomic) IBOutlet UILabel *love;
- (IBAction)loveThisPhoto:(id)sender;


@end
