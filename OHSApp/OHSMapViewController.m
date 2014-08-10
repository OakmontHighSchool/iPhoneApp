//
//  OHSMapView.m
//  OHSApp
//
//  Created by Jon Janzen on 8/10/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import "OHSMapViewController.h"

@implementation OHSMapViewController

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"school_map.jpg"]];
    tempImageView.frame = self.scrollView.bounds;
    self.imageView = tempImageView;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.scrollView.contentSize = CGSizeMake(320,758);
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.minimumZoomScale = 1.0  ;
    self.scrollView.maximumZoomScale = self.imageView.image.size.width / self.scrollView.frame.size.width;
    self.scrollView.zoomScale = 1.0;
    self.scrollView.delegate = self;
    
    [self.scrollView addSubview:self.imageView];
}

@end
