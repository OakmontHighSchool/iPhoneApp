//
//  OHSArticleViewController.m
//  OHSApp
//
//  Created by Jon Janzen on 8/9/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import "OHSArticleViewController.h"
#import "OHSProgressBarManager.h"

@implementation OHSArticleViewController

OHSProgressBarManager *barManager;

-(void) viewDidLoad {
    [super viewDidLoad];
    barManager = [[OHSProgressBarManager alloc] initWithBar:self.progressBar andRefreshButton:self.navigationItem.rightBarButtonItem];
    [barManager startProgressBar];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    [self.webView setDelegate:self];
}

-(void)webView:(UIWebView *)myWebView didFailLoadWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet"
                                       message:[[[error userInfo] objectForKey:NSUnderlyingErrorKey] localizedDescription]
                                      delegate:nil
                             cancelButtonTitle:@"Ok"
                             otherButtonTitles:nil];
    [alert show];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [barManager finishProgressBar];
}

@end
