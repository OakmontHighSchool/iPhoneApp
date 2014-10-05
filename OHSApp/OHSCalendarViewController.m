//
//  OHSCalendarViewController.m
//  OHSApp
//
//  Created by Jon Janzen on 8/10/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import "OHSCalendarViewController.h"

@implementation OHSCalendarViewController

NSString *calendarUrl = @"http://ohs.rjuhsd.us/Page/2";

-(void)viewDidLoad {
    [super viewDidLoad];
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
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:calendarUrl]]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:calendarUrl]];
    }
}

@end
