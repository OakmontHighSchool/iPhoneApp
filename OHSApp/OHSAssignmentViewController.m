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
    
    self.navigationItem.title = [self.assignment description];
    
    [self setCell:0 section:0 toAdd:[self.assignment percent]];
    [self setCell:1 section:0 toAdd:[self.assignment type]];
    [self setCell:2 section:0 toAdd:[self.assignment score]];
    
    [self setCell:0 section:1 toAdd:[self.assignment dateCompleted]];
    [self setCell:1 section:1 toAdd:[self.assignment dateDue]];
    [self setCell:2 section:1 toAdd:[self.assignment gradingComplete]];
}

-(void)setCell:(int)index section:(int)section toAdd:(NSString *)toAdd {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:section];
    NSString *old = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    NSString *new = [NSString stringWithFormat:@"%@: %@",old,toAdd];
    [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text = new;
}

@end
