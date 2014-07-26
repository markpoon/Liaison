//
//  UsersViewCellController.h
//  Liaison
//
//  Created by Ascended on 2013-06-19.
//  Copyright (c) 2013 Arete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface UsersViewCellController : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) Photo *photo;
@property (weak, nonatomic) IBOutlet UILabel *love;
- (IBAction)loveThisPhoto:(id)sender;

@end
