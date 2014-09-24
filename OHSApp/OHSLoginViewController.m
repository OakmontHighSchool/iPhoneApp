//
//  OHSLoginViewController.m
//  OHSApp
//
//  Created by Jon Janzen on 8/11/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import "OHSLoginViewController.h"
#import "OHSAccount.h"

@implementation OHSLoginViewController

- (void)viewDidLoad {
    self.accountManager = [[OHSAccountManager alloc] init];
    [self.tableView reloadData];
}

BOOL isEditing = NO;

- (IBAction)unwindToAccountsView:(UIStoryboardSegue *)segue
{
    [self reloadTable];
}

- (IBAction)editButtonPressed:(id)sender {
    isEditing = !isEditing;
    [self setEditing:isEditing animated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
    if (editing) {
        [self.editButton setTitle:@"Done"];
    } else {
        [self.editButton setTitle:@"Edit"];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (void)reloadTable {
    [self.accountManager reload];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.accountManager.accounts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountsItem" forIndexPath:indexPath];
    
    OHSAccount *account = (self.accountManager.accounts)[indexPath.row];
    cell.textLabel.text = account.email;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.accountManager removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"viewClasses"]){
        //Get row id
        NSInteger rowId = [self.tableView indexPathForSelectedRow].row;
        //Get new view controller...
        OHSClassesViewController *controller = (OHSClassesViewController *)segue.destinationViewController;
        controller.account = [self.accountManager.accounts objectAtIndex:rowId];
    }
}

@end
