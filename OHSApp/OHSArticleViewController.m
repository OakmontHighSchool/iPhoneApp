//
//  OHSArticleViewController.m
//  OHSApp
//
//  Created by Jon Janzen on 8/9/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import "OHSArticleViewController.h"

@implementation OHSArticleViewController

-(void) viewDidLoad {
    [super viewDidLoad];
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

@end
