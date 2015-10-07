//
//  EEPersonInformationViewController.h
//  TestTask
//
//  Created by админ on 10/6/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Person+Methods.h"

@class EEPersonInformationViewController;

@protocol EEPersonInformationViewControllerDelegate <NSObject>

@optional
-(void) donePersonInformationViewController: (EEPersonInformationViewController*)viewController;
-(void) cancelPersonInformationViewController: (EEPersonInformationViewController*)viewController;

@end


@interface EEPersonInformationViewController : UIViewController

@property (strong, nonatomic) Person *currentPerson;
@property (weak, nonatomic) id<EEPersonInformationViewControllerDelegate> delegate;

@end


