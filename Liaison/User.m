//
//  User.m
//  Liaison
//
//  Created by Ascended on 2013-06-07.
//  Copyright (c) 2013 Arete. All rights reserved.
//

#import "User.h"


@implementation User
@dynamic age, latitude, longitude, love, name, photos, api_id;

-(NSArray*)coordinates:(NSString *)value{
    return @[self.latitude, self.longitude];}
@end
