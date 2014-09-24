//
//  OHSTabBarViewController.m
//  OHSApp
//
//  Created by Jon Janzen on 9/23/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import "OHSTabBarViewController.h"

@interface OHSTabBarViewController ()

@end

@implementation OHSTabBarViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:1]];
}

@end
