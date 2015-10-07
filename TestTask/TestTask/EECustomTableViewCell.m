//
//  EECustomTableViewCell.m
//  TestTask
//
//  Created by админ on 10/6/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import "EECustomTableViewCell.h"
#import "UIImage+EEAssets.h"
#import "NSDate+EEToString.h"

@interface EECustomTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nameAndLastNameLable;
@property (weak, nonatomic) IBOutlet UILabel *dateOfCreationLable;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@end

@implementation EECustomTableViewCell

#pragma mark - lifeCycle methods
-(void) awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap)];
    [self.userImageView addGestureRecognizer:tap];
}

#pragma mark - private methods
-(void)didTap {
    [self.delegate didTapOnImageViewOnCell:self];
}

#pragma mark - public methods
- (UIImage *)userImage {
    return self.userImageView;
}

#pragma mark - property methods
- (void)setPerson:(Person *)person {
    _person = person;
    self.nameAndLastNameLable.text = [person fullName];
    self.dateOfCreationLable.text = [person.dateAdded transformToString] ;
    if(person.photoUrl != nil) {
        [UIImage imageFromAssetsWithURL:[[NSURL alloc]initWithString:person.photoUrl] andCompletitionBlock:^(UIImage *image) {
            self.userImageView.image = image;
        }];
    }
    else {
        self.userImageView.image = [UIImage imageNamed:@"defaultImage"];
    }
}

@end
