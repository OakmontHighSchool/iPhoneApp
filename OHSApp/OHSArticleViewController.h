//
//  OHSArticleViewController.h
//  OHSApp
//
//  Created by Jon Janzen on 8/9/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OHSArticleViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property(nonatomic) NSString *url;

@end
