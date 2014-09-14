//
//  OHSClassesViewController.h
//  OHSApp
//
//  Created by Jon Janzen on 9/12/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFHpple.h"
#import "OHSClass.h"

@interface OHSClassesViewController : UITableViewController<NSURLConnectionDelegate>

@property (retain, nonatomic) NSMutableData *receivedData;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *password;

@end
