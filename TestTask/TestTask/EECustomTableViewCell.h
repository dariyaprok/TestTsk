//
//  EECustomTableViewCell.h
//  TestTask
//
//  Created by админ on 10/6/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Person+Methods.h"

@class EECustomTableViewCell;


@protocol EECustomTableViewCellDelegate <NSObject>

-(void) didTapOnImageViewOnCell:(EECustomTableViewCell*)cell;

@end


@interface EECustomTableViewCell : UITableViewCell

@property (weak, nonatomic) id <EECustomTableViewCellDelegate> delegate;
@property (strong, nonatomic) Person *person;

- (UIImageView*) userImageView;

@end
