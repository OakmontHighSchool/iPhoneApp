//
//  OHSAddAccountViewController.m
//  OHSApp
//
//  Created by Jon Janzen on 8/13/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import "OHSAddAccountViewController.h"

@interface OHSAddAccountViewController ()

@end

@implementation OHSAddAccountViewController

OHSAccount *account;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.emailField setDelegate:self];
    [self.passwordField setDelegate:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self processAccount];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailField) {
        [self.passwordField becomeFirstResponder];
    } else if(textField == self.passwordField) {
        [self processAccount];
    }
    return YES;
}

-(void)processAccount {
    account = [[OHSAccount alloc] init];
    account.email = self.emailField.text;
    account.password = self.passwordField.text;
    [account save];
}

@end
