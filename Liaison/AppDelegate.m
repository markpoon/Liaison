//
//  AppDelegate.m
//  Liaison
//
//  Created by Ascended on 2013-06-06.
//  Copyright (c) 2013 Arete. All rights reserved.
//

#import "AppDelegate.h"
#import <RestKit/CoreData.h>
#import "LoginViewController.h"
#import "KDJKeychainItemWrapper.h"
#import "UsersViewController.h"
#import "Photo.h"
//#import "PhotoViewController.h"


@implementation AppDelegate
+ (void) initialize {
    if (self == [Photo class]) {
        ImageTransform *transformer = [[ImageTransform alloc] init];
        [NSValueTransformer setValueTransformer:transformer forName:@"ImageTransform"];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSError *error = nil;
    // Override point for customization after application launch.
    if ([CLLocationManager locationServicesEnabled]){
        self.locationManager = [[CLLocationManager alloc] init];;
        [self.locationManager startUpdatingLocation];
    }
    NSURL *baseURL = [NSURL URLWithString:@"http://0.0.0.0:9292"];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];
    // Enable Activity Indicator Spinner
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Liaison" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    // NSLog(@"managed object model: %@", managedObjectModel);
    // Initialize managed object store
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    objectManager.managedObjectStore = managedObjectStore;
//    NSLog(@"managed object store: %@", managedObjectStore);
    
    // Setup our object mappings
    /**
     Mapping by entity. Here we are configuring a mapping by targetting a Core Data entity with a specific
     name. This allows us to map back objects directly onto NSManagedObject instances --
     there is no backing model class!
     */
    
    RKEntityMapping *photoMapping = [RKEntityMapping mappingForEntityForName:@"Photo" inManagedObjectStore:managedObjectStore];
    photoMapping.identificationAttributes = @[ @"api_id" ];
    [photoMapping addAttributeMappingsFromDictionary:@{
     @"_id":            @"api_id",
     @"l":              @"love",
     @"image":         @"image"}];
//    [photoMapping addAttributeMappingsFromArray:@[@"image"]];
    
    RKResponseDescriptor *responseforPhoto = [RKResponseDescriptor responseDescriptorWithMapping:photoMapping pathPattern:@"/photo/:api_id" keyPath:@"photos" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:responseforPhoto];
    
    RKEntityMapping *userMapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:managedObjectStore];
    userMapping.identificationAttributes = @[ @"api_id" ];
    [userMapping addAttributeMappingsFromDictionary:@{
     @"_id":            @"api_id",
     @"n":              @"name",
     @"l":              @"love"}];
    // If source and destination key path are the same, we can simply add a string to the array
    [userMapping addAttributeMappingsFromArray:@[ @"latitude", @"longitude" ]];
    [userMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"photos" toKeyPath:@"photos" withMapping:photoMapping]];
    RKResponseDescriptor *responseforUser = [RKResponseDescriptor responseDescriptorWithMapping:userMapping pathPattern:@"/user/:api_id" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:responseforUser];
    
    RKResponseDescriptor *responseforUsers = [RKResponseDescriptor responseDescriptorWithMapping:userMapping pathPattern:@"/user/" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:responseforUsers];
    
    RKResponseDescriptor *responseforUserLogin = [RKResponseDescriptor responseDescriptorWithMapping:userMapping pathPattern:@"/login" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:responseforUserLogin];
        
    // Update date format so that we can parse Twitter dates properly
    // Wed Sep 29 15:31:08 +0000 2010
    [RKObjectMapping addDefaultDateFormatterForString:@"E MMM d HH:mm:ss Z y" inTimeZone:nil];

    // Register our mappings with the provider
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping pathPattern:@"/user/" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelOff);
    RKLogConfigureByName("RestKit/CoreData", RKLogLevelOff);
//    RKLogLevelInfo RKLogLevelTrace
    
    BOOL success = RKEnsureDirectoryExistsAtPath(RKApplicationDataDirectory(), &error);
    if (! success) {
        RKLogError(@"Failed to create Application Data Directory at path '%@': %@", RKApplicationDataDirectory(), error);
    }
    /**
     Complete Core Data stack initialization
     */
    [managedObjectStore createPersistentStoreCoordinator];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"Liaison.sqlite"];
    NSString *seedPath = [[NSBundle mainBundle] pathForResource:@"Liaison" ofType:@"sqlite"];
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:seedPath withConfiguration:nil options:nil error:&error];
//    NSLog(@"persistent store coordinator: %@", managedObjectStore.persistentStoreCoordinator);
    // NSLog(@"persistent store: %@", persistentStore);
    NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
    // Create the managed object contexts
    [managedObjectStore createManagedObjectContexts];
//    NSLog(@"managed object context: %@", managedObjectStore.mainQueueManagedObjectContext);

    
    // Configure a managed object cache to ensure we do not create duplicate objects
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
//    NSLog(@"mangaged object cache: %@", managedObjectStore.managedObjectCache);

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSArray*)deviceCoordinates {
    NSArray *coordinates = [NSArray arrayWithObjects: @(self.locationManager.location.coordinate.latitude), @(self.locationManager.location.coordinate.longitude), nil];
    return coordinates;
}
-(NSDictionary *)coordinatesDictionary{
    return [NSDictionary dictionaryWithObjects:@[self.deviceCoordinates]forKeys:@[@"coordinates"]];
}
-(NSString*)coordinatesString{
    return [[NSString alloc] initWithData:self.coordinatesJSON encoding:1];
}
-(NSData *)coordinatesJSON{
    NSError* error;
    return [NSJSONSerialization dataWithJSONObject:self.deviceCoordinates options:0 error:&error];
}
@end
