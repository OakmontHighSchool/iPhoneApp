//
//  OHSArticleViewController.h
//  OHSApp
//
//  Created by Jon Janzen on 8/9/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OHSArticleViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@property(nonatomic) NSString *url;

@end
