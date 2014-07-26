//
//  UsersViewCellController.m
//  Liaison
//
//  Created by Ascended on 2013-06-19.
//  Copyright (c) 2013 Arete. All rights reserved.
//

#import "UsersViewCellController.h"
#import "Base64.h"


@implementation UsersViewCellController

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)setPhoto:(Photo *)photo{
    if(_photo != photo) {
        _photo = photo;
    }
    UIImage* image = nil;
    if ([_photo.image class] == [UIImage class]){
        image = _photo.image;
    }else{
        image = [UIImage imageWithData:[NSData dataWithBase64EncodedString:_photo.image]];}
    
    self.imageView.image = image;
    self.love.text = [_photo.love stringValue];
}

- (IBAction)loveThisPhoto:(id)sender {
}
@end
