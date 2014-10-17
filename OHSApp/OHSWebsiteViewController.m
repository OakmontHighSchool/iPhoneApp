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

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.webView setDelegate:self];
    [self loadWebpage];
}

- (IBAction)refreshButtonPressed:(id)sender {
    [self loadWebpage];
}

- (IBAction)actionButtonPressed:(id)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Open in Safari", nil];
    [popup showInView:self.view];
}

-(void)loadWebpage {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:websiteUrl]]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:websiteUrl]];
    }
}

-(void)webView:(UIWebView *)myWebView didFailLoadWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet"
                                       message:[[[error userInfo] objectForKey:NSUnderlyingErrorKey] localizedDescription]
                                      delegate:nil
                             cancelButtonTitle:@"Ok"
                             otherButtonTitles:nil];
    [alert show];
}

@end
