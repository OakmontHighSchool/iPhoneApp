//
//  OHSAssignmentViewController.m
//  OHSApp
//
//  Created by Jon Janzen on 9/14/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import "OHSAssignmentViewController.h"

@interface OHSAssignmentViewController ()

@end

@implementation OHSAssignmentViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setCell:0 inSection:0 withString:[self.assignment desc] allowSelection:NO];
    
    [self addToCell:0 inSection:1 withString:[self.assignment percent] allowSelection:NO];
    [self addToCell:1 inSection:1 withString:[self.assignment type] allowSelection:NO];
    [self addToCell:2 inSection:1 withString:[self.assignment score] allowSelection:NO];
    
    [self addToCell:0 inSection:2 withString:[self.assignment dateCompleted] allowSelection:NO];
    [self addToCell:1 inSection:2 withString:[self.assignment dateDue] allowSelection:NO];
    [self addToCell:2 inSection:2 withString:[self.assignment gradingComplete] allowSelection:NO];
}

-(void)addToCell:(int)index inSection:(int)section withString:(NSString *)toAdd allowSelection:(BOOL)allowSelection {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:section];
    NSString *old = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    NSString *new = [NSString stringWithFormat:@"%@: %@",old,toAdd];
    [self setCell:index inSection:section withString:new allowSelection:allowSelection];
}

-(void)setCell:(int)index inSection:(int)section withString:(NSString *)str allowSelection:(BOOL)allowSelection {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:section];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.text = str;
    cell.userInteractionEnabled = allowSelection;
}

@end
