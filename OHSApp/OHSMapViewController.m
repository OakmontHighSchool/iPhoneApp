//
//  OHSMapView.m
//  OHSApp
//
//  Created by Jon Janzen on 8/10/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import "OHSMapViewController.h"

@implementation OHSMapViewController

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.minimumZoomScale=1.0;
    self.scrollView.maximumZoomScale=6.0;
    self.scrollView.delegate=self;
}

- (IBAction)actionButtonPressed:(id)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Save Image", nil];
    [popup showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        UIImageWriteToSavedPhotosAlbum(self.imageView.image, nil, nil, nil);
    }
}

@end
