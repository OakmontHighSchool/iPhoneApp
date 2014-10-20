//
//  OHSLoginViewController.h
//  OHSApp
//
//  Created by Jon Janzen on 8/11/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHSAccountManager.h"

@interface OHSAccountsViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) OHSAccountManager *accountManager;

-(void)triggerEditAccount:(OHSAccount*)account;

@end
