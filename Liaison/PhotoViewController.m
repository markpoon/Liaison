//
//  PhotoViewController.m
//  Liaison
//
//  Created by Ascended on 2013-06-27.
//  Copyright (c) 2013 Arete. All rights reserved.
//

#import "PhotoViewController.h"
#import "Base64.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

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
    self.view.backgroundColor=[UIColor greenColor];
    if ([_photo.image class] == [UIImage class]){
        [self.imageView setImage:_photo.image];
    }else{
        [self.imageView setImage:[UIImage imageWithData:[NSData dataWithBase64EncodedString:_photo.image]]];}
    self.love.text=[_photo.love stringValue];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loveThisPhoto:(id)sender {
}
@end
