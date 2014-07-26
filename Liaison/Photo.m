//
//  Photo.m
//  Liaison
//
//  Created by Ascended on 2013-06-24.
//  Copyright (c) 2013 Arete. All rights reserved.
//

#import "Photo.h"
#import "User.h"
#import "Base64.h"

@implementation Photo
@dynamic api_id, image, love, user;
@end

@implementation ImageTransform

+ (Class)transformedValueClass {
	return [NSData class];}

+ (BOOL)allowsReverseTransformation {
	return YES;}

- (NSData*)transformedValue:(id)value {
    NSData* data = [NSData dataWithBase64EncodedString:value];
	return data;}

- (UIImage*)reverseTransformedValue:(NSData*)data {
    UIImage* image = [UIImage imageWithData:data];
    return image;}
@end