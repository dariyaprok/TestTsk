//
//  EEPersonViewingViewControoller.m
//  TestTask
//
//  Created by админ on 10/7/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import "EEPersonViewingViewControoller.h"
#import "UIImage+EEAssets.h"
#import "NSDate+EEToString.h"

@interface EEPersonViewingViewControoller()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation EEPersonViewingViewControoller

#pragma mark - lifeCycle methods
-(void)viewDidLoad {
    self.fullNameLabel.text = [self.currentPerson fullName];
    self.dateLabel.text = [self.currentPerson.dateAdded transformToString];
    if(self.currentPerson.photoUrl) {
        [UIImage imageFromAssetsWithURL:[[NSURL alloc] initWithString:self.currentPerson.photoUrl] andCompletitionBlock:^(UIImage *image) {
            if(image!=nil)
                self.photoImageView.image = image;
        }];
    }
}


@end

