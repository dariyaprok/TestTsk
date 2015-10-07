//
//  EEImagePickerManager.m
//  TestTask
//
//  Created by админ on 10/6/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import "EEImagePickerManager.h"
#import "NSArray+EEContainsElementsOfArray.h"
@import MobileCoreServices;

@interface EEImagePickerManager() <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) void(^completitionHandler)(UIImage*, NSURL*);

@end

@implementation EEImagePickerManager
#pragma mark - initializers

+ (instancetype)sharedManager{
    static dispatch_once_t sharedManagerInstanceToken;
    static EEImagePickerManager *sharedManager = nil;
    dispatch_once(&sharedManagerInstanceToken, ^{
        sharedManager = [EEImagePickerManager new];
    });
    return sharedManager;
}

- (instancetype)init{
    self = [super init];
    
    if (self != nil) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
    }
    
    return self;
}

#pragma mark - public methods

- (void)presentAlertControllerWithCompletionBlock:(void(^)(UIImage*, NSURL*))block inViewController:(UIViewController *)viewController
{
    NSParameterAssert(block);
    NSParameterAssert(viewController);
    
    UIAlertController *imageChosingOptionsAlertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Chose option", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    UIAlertAction *choseFromLibraryAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Chose from Library", nil)
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction *action) {
                                                                       [self startPickingImageFromSourceType:UIImagePickerControllerSourceTypePhotoLibrary mediaTypes:[[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil] completitionHandler:block presentingViewController:viewController];
                                                                   }];
    
    UIAlertAction *makePhotoAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Make photo", nil)
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action) {
                                                                [self startPickingImageFromSourceType:UIImagePickerControllerSourceTypeCamera mediaTypes:[[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil] completitionHandler:block presentingViewController:viewController];
                                                            }];
    
    
    [imageChosingOptionsAlertController addAction:cancelAction];
    [imageChosingOptionsAlertController addAction:choseFromLibraryAction];
    [imageChosingOptionsAlertController addAction:makePhotoAction];
    
    
    [viewController presentViewController:imageChosingOptionsAlertController animated:YES completion:nil];
    
}

- (void)startPickingImageFromSourceType:(UIImagePickerControllerSourceType)type
                             mediaTypes:(NSArray *)mediaTypes
                    completitionHandler:(void (^)(UIImage*, NSURL*))block
               presentingViewController:(UIViewController *)presentingViewController{
    NSParameterAssert(presentingViewController);
    
    if ([UIImagePickerController isSourceTypeAvailable:type]){
        
        self.completitionHandler = block;
        
        self.imagePickerController.sourceType = type;
        if (mediaTypes != nil && [mediaTypes count] > 0 && [[UIImagePickerController availableMediaTypesForSourceType:type] containsElementsOfArray:mediaTypes])
            self.imagePickerController.mediaTypes = mediaTypes;
        self.imagePickerController.allowsEditing = NO;
        
        [presentingViewController presentViewController:_imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if (self.imagePickerController == picker){
        NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
        
        if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
            == kCFCompareEqualTo) {
            
            UIImage *originalImage = (UIImage *) [info objectForKey:
                                                  UIImagePickerControllerOriginalImage];
            NSURL *imageUrl = (NSURL*)[info valueForKey: UIImagePickerControllerReferenceURL];
            
            self.completitionHandler(originalImage, imageUrl);
        }
        [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    self.completitionHandler(nil, nil);
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

@end
