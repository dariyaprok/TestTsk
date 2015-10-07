//
//  EEPersonInformationViewController.m
//  TestTask
//
//  Created by админ on 10/6/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//


#import "EEPersonInformationViewController.h"
#import "UIImage+EEAssets.h"
#import "EEImagePickerManager.h"

@interface EEPersonInformationViewController()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) NSURL *photoUrl;

@end

@implementation EEPersonInformationViewController

#pragma mark - lifeCycle methods
- (void)viewDidLoad {
    self.nameTextField.text = self.currentPerson.name;
    self.lastNameTextField.text = self.currentPerson.lastname;
    if (_currentPerson.photoUrl)
        self.photoUrl = [[NSURL alloc] initWithString:self.currentPerson.photoUrl];


        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnPhotoImageView)];
        [self.photoImageView addGestureRecognizer:tap];
}

#pragma mark - IBAction methods
- (IBAction)cancelPressed:(id)sender {
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(cancelPersonInformationViewController:)]) {
        [self.delegate cancelPersonInformationViewController:self];
    }
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)donePressed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(donePersonInformationViewController:)]) {
        [self fillPerson];
        [self.delegate donePersonInformationViewController:self];
    }
}

#pragma mark - private methods
-(void)tappedOnPhotoImageView {
    [[EEImagePickerManager sharedManager] presentAlertControllerWithCompletionBlock:^(UIImage *image, NSURL *url) {
        if (image != nil) {
            if (url == nil)
                [image saveImageToAssetsWithCompletitionBlock:^(NSURL *savedUrl, NSError *error) {
                    if (savedUrl != nil && error == nil)
                        self.photoUrl = savedUrl;
                }];
            else
                self.photoUrl = url;
        }
    } inViewController:self];
}

- (void) fillPerson {
    self.currentPerson.name = self.nameTextField.text;
    self.currentPerson.lastname = self.lastNameTextField.text;
    self.currentPerson.photoUrl = self.photoUrl.absoluteString;
}

#pragma mark - properties method
- (void)setPhotoUrl:(NSURL *)photoUrl {
    _photoUrl = photoUrl;
    [UIImage imageFromAssetsWithURL:_photoUrl andCompletitionBlock:^(UIImage *image) {
        if(image != nil)
            self.photoImageView.image = image;
    }];
}
@end
