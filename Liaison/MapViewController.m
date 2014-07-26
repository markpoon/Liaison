//
//  MapViewController.m
//  Liason
//
//  Created by Ascended on 2013-05-19.
//  Copyright (c) 2013 Ascended. All rights reserved.
//

#import "MapViewController.h"
#define METERS_PER_MILE 1609.344

@interface MapViewController ()

@end

@implementation MapViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.location.coordinate, .7*METERS_PER_MILE, .7*METERS_PER_MILE);
    [self.mapView setRegion:viewRegion animated:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwind:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
