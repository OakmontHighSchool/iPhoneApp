//
//  OHSLoginViewController.h
//  OHSApp
//
//  Created by Jon Janzen on 8/11/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OHSLoginViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

- (IBAction)unwindToArticleOverview:(UIStoryboardSegue *)segue;

@property (strong, nonatomic) NSMutableArray *accounts;

@end
