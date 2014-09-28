//
//  OHSClassesViewController2.m
//  OHSApp
//
//  Created by Jon Janzen on 9/27/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import "OHSClassesViewController2.h"

@implementation OHSClassesViewController2

NSArray* array;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self downloadClasses];
}

- (void)downloadClasses {
    array = [[NSArray alloc] init];
    
    NSData *classData = [NSData dataWithContentsOfURL:<#(NSURL *)#>];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [array count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassItem" forIndexPath:indexPath];
    OHSClass* class = [array objectAtIndex:indexPath.row];
    cell.textLabel.text = class.name;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
