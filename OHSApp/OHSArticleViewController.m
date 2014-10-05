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
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

@end
