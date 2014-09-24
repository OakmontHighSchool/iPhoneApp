//
//  OHSAddAccountViewController.h
//  OHSApp
//
//  Created by Jon Janzen on 8/13/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHSAccount.h"

@interface OHSEditAccountViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) OHSAccount *account;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;

@end
