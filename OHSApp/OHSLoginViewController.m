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
    self.accounts = [[NSMutableArray alloc] initWithCapacity:2];
    
    /*OHSAccount *account = [[OHSAccount alloc] init];
    account.email = @"odin.viking@email.com";
    account.password = @"NOTACHANCE";
    [self.accounts addObject:account];
    
    account = [[OHSAccount alloc] init];
    account.email = @"first.last@email.com";
    account.password = @"NOTACHANCE";
    [self.accounts addObject:account];*/
    
    [self.tableView reloadData];
}

BOOL isEditing = NO;

- (IBAction)unwindToArticleOverview:(UIStoryboardSegue *)segue
{
    //Necessary for some reason
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.accounts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountsItem" forIndexPath:indexPath];
    
    OHSAccount *account = (self.accounts)[indexPath.row];
    cell.textLabel.text = account.email;
    
    return cell;
}

@end
