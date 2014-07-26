//
//  MapViewController.h
//  Liason
//
//  Created by Ascended on 2013-05-19.
//  Copyright (c) 2013 Ascended. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController

- (IBAction)unwind:(id)sender;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
