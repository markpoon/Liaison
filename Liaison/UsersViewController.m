//
//  UsersViewController.m
//  Liason
//
//  Created by Ascended on 2013-05-16.
//  Copyright (c) 2013 Ascended. All rights reserved.
//

#import "UsersViewController.h"
#import "UsersViewCellController.h"
#import "UserViewController.h"
#import "AppDelegate.h"
#import "User.h"

@interface UsersViewController ()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation UsersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController setToolbarHidden:YES animated:NO];
    RKLogConfigureByName("RestKit/Network", RKLogLevelDebug);
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"api_id" ascending:NO];
    fetchRequest.sortDescriptors = @[descriptor];
    // Setup fetched results
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
    [self.fetchedResultsController setDelegate:self];
    [self fetchUsers:@"/user/"];
    }
-(void)fetchUsers:(NSString *)path{
    [[RKObjectManager sharedManager] getObjectsAtPath:path parameters:self.getDeviceLocation success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self reload];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to load api, error: %@", error);
    }];
}
- (void)reload{
    NSError* error = nil;
    [self.fetchedResultsController performFetch:&error];
    [self.collectionView reloadData];
    if (error) {
        NSLog(@"Failed to reload core-data, error: %@", error);
    }
}
- (NSDictionary *)getDeviceLocation{
    AppDelegate* appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    return @{@"coordinates":appdelegate.coordinatesString};
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Fetched results controller
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{

}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
        break;
    
    case NSFetchedResultsChangeDelete:
        [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
        break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UICollectionView* collectionView = self.collectionView;
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [collectionView insertItemsAtIndexPaths:@[newIndexPath]];
            break;

        case NSFetchedResultsChangeDelete:
            [collectionView deleteItemsAtIndexPaths:@[indexPath]];
            break;

        case NSFetchedResultsChangeUpdate:
//            [self configureCell:[collectionView cellForItemAtIndexPath:indexPath] atIndexPath:indexPath];
            break;

        case NSFetchedResultsChangeMove:
            [collectionView deleteItemsAtIndexPaths:@[indexPath]];
            [collectionView insertItemsAtIndexPaths:@[newIndexPath]];
            break;
        }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [[self.fetchedResultsController fetchedObjects] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UsersViewCellController *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Thumbnail" forIndexPath:indexPath];
    User* thisUser = [self.fetchedResultsController objectAtIndexPath:indexPath];
    Photo* photo = [thisUser.photos anyObject];
    cell.photo = photo;
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.row % 3) == 0){
        return CGSizeMake(320, 185);
    }else{
        return CGSizeMake(160, 255);
    }
}

- (void) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            /* start special animation */
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            /* start special animation */
            break;
            
        default:
            break;
    };
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
    User* user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"segueToUser" sender:user];

}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"segueToUser"]){
        UserViewController* viewController = segue.destinationViewController;
        viewController.user = sender;
    }
}
//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//}


@end
