//
//  OHSClassDetailViewControllerTableViewController.h
//  OHSApp
//
//  Created by Jon Janzen on 9/13/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHSClass.h"
#import "OHSAccount.h"
#import "OHSAssignment.h"
#import "TFHpple.h"
#import "OHSAssignmentViewController.h"

@interface OHSClassDetailViewController : UITableViewController<NSURLConnectionDelegate>

@property (nonatomic, strong) OHSClass *schoolClass;
@property (nonatomic, strong) OHSAccount *account;

@end
