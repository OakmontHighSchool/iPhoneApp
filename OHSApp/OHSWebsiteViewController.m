//
//  OHSWebsiteViewController.m
//  OHSApp
//
//  Created by Jon Janzen on 8/10/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import "OHSWebsiteViewController.h"

@implementation OHSWebsiteViewController

-(void)viewDidLoad
{
    [self loadWebpage];
}

- (IBAction)refreshButtonPressed:(id)sender {
    [self loadWebpage];
}

- (IBAction)actionButtonPressed:(id)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Open with Safari", nil];
    [popup showInView:self.view];
}

-(void)loadWebpage {
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ohs.rjuhsd.us"]]];
}

@end
