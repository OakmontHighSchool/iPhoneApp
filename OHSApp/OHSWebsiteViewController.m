//
//  OHSWebsiteViewController.m
//  OHSApp
//
//  Created by Jon Janzen on 8/10/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import "OHSWebsiteViewController.h"
#import "OHSProgressBarManager.h"

@implementation OHSWebsiteViewController

NSString *websiteUrl = @"http://ohs.rjuhsd.us";
OHSProgressBarManager *barManager;

-(void)viewDidLoad {
    [super viewDidLoad];
    barManager = [[OHSProgressBarManager alloc] initWithBar:self.progressBar andRefreshButton:self.navigationItem.rightBarButtonItem];
    [self.webView setDelegate:self];
    [self refresh];
}

- (void)refresh {
    [barManager startProgressBar];
    [self loadWebpage];
}

- (IBAction)actionButtonPressed:(id)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Open in Safari", @"Refresh", nil];
    [popup showInView:self.view];
}

-(void)loadWebpage {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:websiteUrl]]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:websiteUrl]];
    } else if(buttonIndex == 1) {
        [self refresh];
    }
}

-(void)webView:(UIWebView *)myWebView didFailLoadWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet"
                                       message:[[[error userInfo] objectForKey:NSUnderlyingErrorKey] localizedDescription]
                                      delegate:nil
                             cancelButtonTitle:@"Ok"
                             otherButtonTitles:nil];
    [alert show];
    [barManager finishProgressBar];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [barManager finishProgressBar];
}

@end
