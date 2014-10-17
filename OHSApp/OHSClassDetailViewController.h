//
//  OHSClassDetailViewControllerTableViewController.h
//  OHSApp
//
//  Created by Jon Janzen on 9/13/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHSClass.h"

@interface OHSClassDetailViewController : UITableViewController<UIWebViewDelegate>

@property (nonatomic, strong) OHSClass *schoolClass;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@end
