//
//  AppDelegate.h
//  Liaison
//
//  Created by Ascended on 2013-06-06.
//  Copyright (c) 2013 Arete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *locationManager;
- (NSArray *)deviceCoordinates;
- (NSDictionary *)coordinatesDictionary;
- (NSString *)coordinatesString;
- (NSData *)coordinatesJSON;


@end
