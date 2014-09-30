//
//  OHSNavigationController.m
//  OHSApp
//
//  Created by Jon Janzen on 9/29/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import "OHSNavigationController.h"

@implementation OHSNavigationController

- (UIViewController *)viewControllerForUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    NSLog(@"OHSNavController fired");
    
    for(UIViewController *vc in self.viewControllers){
        // Always use -canPerformUnwindSegueAction:fromViewController:withSender:
        // to determine if a view controller wants to handle an unwind action.
        if ([vc canPerformUnwindSegueAction:action fromViewController:fromViewController withSender:sender]) {
            NSLog(@"ITS HAPPENING");
            return vc;
        }
    }
    
    return [super viewControllerForUnwindSegueAction:action fromViewController:fromViewController withSender:sender];
}

@end
