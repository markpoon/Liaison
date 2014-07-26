//
//  Photo.h
//  Liaison
//
//  Created by Ascended on 2013-06-24.
//  Copyright (c) 2013 Arete. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString* api_id;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSNumber* love;
@property (nonatomic, retain) User * user;

@end

@interface ImageTransform : NSValueTransformer

@end