//
//  UsersViewController.h
//  Liason
//
//  Created by Ascended on 2013-05-16.
//  Copyright (c) 2013 Ascended. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsersViewController : UICollectionViewController < UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

-(void)fetchUsers:(NSString*)path;
-(NSDictionary*)getDeviceLocation;
-(void)reload;

@end
