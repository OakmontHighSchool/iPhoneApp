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
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ohs.rjuhsd.us"]]];
}

@end
