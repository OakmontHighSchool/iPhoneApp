//
//  OHSNewsViewController.h
//  OHSApp
//
//  Created by Jon Janzen on 7/20/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OHSNewsViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *articles;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

- (IBAction)reloadArticles:(id)sender;

@end
