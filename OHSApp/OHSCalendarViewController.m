//
//  OHSCalendarViewController.m
//  OHSApp
//
//  Created by Jon Janzen on 8/10/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import "OHSCalendarViewController.h"

@implementation OHSCalendarViewController

-(void)viewDidLoad
{
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ohs.rjuhsd.us/Page/2"]]];
}
@end
