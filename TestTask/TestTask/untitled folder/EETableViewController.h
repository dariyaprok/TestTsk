//
//  EETableViewController.h
//  
//
//  Created by админ on 10/6/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EECustomTableViewCell.h"

@interface EETableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, EECustomTableViewCellDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (EECustomTableViewCell* )cellWithIndex: (NSInteger) index;
@end
