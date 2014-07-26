//
//  UserViewController.m
//  Liaison
//
//  Created by Ascended on 2013-06-26.
//  Copyright (c) 2013 Arete. All rights reserved.
//

#import "UserViewController.h"
#import "PhotoViewController.h"

@interface UserViewController ()

@end

@implementation UserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photos = [self.user.photos allObjects];
    self.title = self.user.name;
    NSDictionary *options = [NSDictionary dictionaryWithObject:
                             [NSNumber numberWithInteger:UIPageViewControllerSpineLocationNone] forKey: UIPageViewControllerOptionSpineLocationKey];
    UIPageViewController* pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    PhotoViewController *initialViewController = [self viewControllerAtIndex:0];
    [pageViewController setViewControllers:@[initialViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    pageViewController.dataSource = self;
    pageViewController.delegate = self;
    pageViewController.view.frame = self.view.bounds;
    pageViewController.view.opaque = YES;
    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    [pageViewController didMoveToParentViewController:self];
    self.view.gestureRecognizers = pageViewController.gestureRecognizers;
}

- (PhotoViewController *)viewControllerAtIndex:(NSUInteger)index {
    PhotoViewController* contentController = [self.storyboard instantiateViewControllerWithIdentifier:@"photoView"];
    contentController.photo = [self.photos objectAtIndex:index];
    return contentController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController{
    if(self.index == 0){ self.index = _photos.count-1; } else { self.index--; }
    return [self viewControllerAtIndex:self.index];}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController{
    if(self.index == _photos.count-1){ return 0; } else { self.index++;}
    return [self viewControllerAtIndex:self.index];}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];}

- (IBAction)chatWithUser:(id)sender {

}
@end
