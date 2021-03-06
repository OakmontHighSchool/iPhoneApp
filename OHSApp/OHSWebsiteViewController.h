//
//  OHSWebsiteViewController.h
//  OHSApp
//
//  Created by Jon Janzen on 8/10/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OHSWebsiteViewController : UIViewController <UIActionSheetDelegate,UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@end
