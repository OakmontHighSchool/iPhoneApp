//
//  OHSMapView.h
//  OHSApp
//
//  Created by Jon Janzen on 8/10/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OHSMapViewController : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end
