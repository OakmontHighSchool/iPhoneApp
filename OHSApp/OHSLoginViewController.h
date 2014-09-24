//
//  OHSLoginViewController.h
//  OHSApp
//
//  Created by Jon Janzen on 8/11/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHSAccountManager.h"
#import "OHSClassesViewController.h"

@interface OHSLoginViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

- (IBAction)unwindToAccountsView:(UIStoryboardSegue *)segue;

@property (strong, nonatomic) OHSAccountManager *accountManager;

@end
