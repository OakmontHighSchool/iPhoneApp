//
//  OHSWebsiteViewController.m
//  OHSApp
//
//  Created by Jon Janzen on 8/10/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import "OHSWebsiteViewController.h"

@implementation OHSWebsiteViewController

NSString *websiteUrl = @"http://ohs.rjuhsd.us";

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
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:websiteUrl]]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:websiteUrl]];
    }
}

@end
