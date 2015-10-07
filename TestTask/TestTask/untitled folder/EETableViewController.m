//
//  EETableViewController.m
//
//
//  Created by админ on 10/6/15.
//
//

#import "EETableViewController.h"
#import "EEFullScreenImageViewController.h"
#import "EETransitionToFullScreenImageViewController.h"
#import "Person+Methods.h"
#import <MagicalRecord/MagicalRecord.h>
#import "UIImage+EEAssets.h"
#import "EEPersonInformationViewController.h"
#import "EEPersonViewingViewControoller.h"


@interface EETableViewController () <EEPersonInformationViewControllerDelegate>

@property (strong, nonatomic)NSArray *persons;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (nonatomic)NSInteger indexOfSelectedCell;
@property (nonatomic) BOOL editNotAdd;
@property (strong, nonatomic) Person *selectedPerson;
@property (nonatomic) BOOL isEditing;
@property (strong, nonatomic) NSString *sortedType;

@end

@implementation EETableViewController

#pragma mark - constants
static const NSString *EEAddNewPersonSegue = @"EEAddNewPersonSegue";
static const NSString *EEShowFullScreenImageViewControllerSegue = @"EEShowFullScreenImageViewController";
static const NSString *EEPushPersonViewingViewControollerSegue = @"EEPushPersonViewingViewControollerSegue";

#pragma mark - public methods
- (EECustomTableViewCell* )cellWithIndex: (NSInteger) index {
    return (EECustomTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

#pragma mark - EEPersonInformationViewControllerDelegate methods
-(void) donePersonInformationViewController: (EEPersonInformationViewController*)viewController {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        Person *localPerson = [viewController.currentPerson MR_inContext:localContext];
        localPerson.name = viewController.currentPerson.name;
        localPerson.lastname = viewController.currentPerson.lastname;
        localPerson.photoUrl = viewController.currentPerson.photoUrl;
        localPerson.dateAdded = [NSDate date];
    } completion:^(BOOL contextDidSave, NSError *error) {
        [self loadPersons];
        [self.tableView reloadData];
    }];
}

-(void) cancelPersonInformationViewController: (EEPersonInformationViewController*)viewController {
    if (!self.isEditing)
        [viewController.currentPerson MR_deleteEntity];
}

#pragma mark - Lifecycle methods

- (void)viewDidLoad {
    self.sortedType = @"name";
    [self loadPersons];
    self.isEditing = NO;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}


#pragma mark - UITableViewDelegate methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EECustomTableViewCell *cell = (EECustomTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    self.selectedPerson = cell.person;
    if (!self.isEditing)
        [self performSegueWithIdentifier:EEPushPersonViewingViewControollerSegue sender:self];
    else
        [self performSegueWithIdentifier:EEAddNewPersonSegue sender:self];
    
}


#pragma mark - UITableViewDataSource methods
- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EECustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EECustomTableViewCell"];
    if(!cell) {
        NSArray* nibFileWithCell = [[NSBundle mainBundle] loadNibNamed:@"EECustomTableViewCell" owner:self options:nil];
        cell = [nibFileWithCell objectAtIndex:0];
    }
    Person *currentPerson = (Person*)self.persons[indexPath.row];
    cell.delegate = self;
    cell.person = currentPerson;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.persons.count;

}

- (void)tableView: (UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [((Person*)self.persons[indexPath.row]) MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        [self loadPersons];
        [self.tableView reloadData];
    }
}

#pragma mark - EECustomTableViewCellDelegateMethods
-(void) didTapOnImageViewOnCell:(EECustomTableViewCell *)cell {
    self.indexOfSelectedCell = [self.tableView indexPathForCell:cell].row;
    [self performSegueWithIdentifier:EEShowFullScreenImageViewControllerSegue sender:self];
}

#pragma mark - UINavigationControllerDelegate methods
- (id<UIViewControllerAnimatedTransitioning>) navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (fromVC == self && [toVC isKindOfClass:[EEFullScreenImageViewController class]]) {
        return [[EETransitionToFullScreenImageViewController alloc] init];
    }
    else {
        return nil;
    }
}

#pragma mark - private nethods
-(void)loadPersons {
    self.persons = [Person MR_findAllSortedBy:self.sortedType ascending:YES];
}



#pragma mark - IBAction methods
- (IBAction) sortedButtonPressed:(UISegmentedControl*)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.sortedType = @"name";
            break;
        case 1:
            self.sortedType = @"lastname";
            break;
        case 2:
            self.sortedType = @"dateAdded";
            break;
    }
    [self loadPersons];
    [self.tableView reloadData];
}

- (IBAction)editPressed:(id)sender {
    if(!self.isEditing) {
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editPressed:)]];
        self.navigationItem.rightBarButtonItem = nil;
    }
    else {
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed:)]];
        self.navigationItem.rightBarButtonItem = self.addButton;
    }
    self.isEditing = !self.isEditing;
}

#pragma mark - segue methods
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString: EEShowFullScreenImageViewControllerSegue]) {
        EEFullScreenImageViewController* destinationViewController = segue.destinationViewController;
        destinationViewController.currentIndex = self.indexOfSelectedCell;
        destinationViewController.image = [((EECustomTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.indexOfSelectedCell inSection:0]]) userImageView].image;
    }
    //TODO : rename segue identifier
    else if([segue.identifier isEqualToString: EEAddNewPersonSegue]) {
        EEPersonInformationViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.delegate = self;
        destinationViewController.currentPerson = self.isEditing ? self.selectedPerson : [Person MR_createEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    else if ([segue.identifier isEqualToString: EEPushPersonViewingViewControollerSegue]) {
        EEPersonViewingViewControoller *destinationViewController = segue.destinationViewController;
        destinationViewController.currentPerson = self.selectedPerson;
    }
}
@end
