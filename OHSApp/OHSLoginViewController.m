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
    
    OHSAccount *account = [[OHSAccount alloc] init];
    account.email = @"odin.viking@email.com";
    account.password = @"NOTACHANCE";
    [self.accounts addObject:account];
    
    account = [[OHSAccount alloc] init];
    account.email = @"first.last@email.com";
    account.password = @"NOTACHANCE";
    [self.accounts addObject:account];
    
    [self.tableView reloadData];
}

- (IBAction)editButtonPressed:(id)sender {
    [self setEditing:YES animated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
    if (editing) {
        self.addButton.enabled = NO;
    } else {
        self.addButton.enabled = YES;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return NO;
        }
    }
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
