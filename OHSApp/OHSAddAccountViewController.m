//
//  OHSAddAccountViewController.m
//  OHSApp
//
//  Created by Jon Janzen on 8/13/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import "OHSAddAccountViewController.h"

@implementation OHSAddAccountViewController

BOOL newAccount = NO;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.account == nil) {
        newAccount = YES;
        self.account = [[OHSAccount alloc] init];
    }
    
    [self.nameField setText:self.account.name];
    [self.emailField setText:self.account.email];
    [self.passwordField setText:self.account.password];
    
    [self.emailField setDelegate:self];
    [self.passwordField setDelegate:self];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if([[sender title] isEqualToString:@"Save"]) {
        return [self processAccount];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailField) {
        [self.passwordField becomeFirstResponder];
    } else if(textField == self.passwordField) {
        if([self processAccount]) {
            [self performSegueWithIdentifier:@"AccountSave" sender:textField];
        }
    }
    return YES;
}

-(BOOL)processAccount {
    NSString *email = self.emailField.text;
    NSString *password = self.passwordField.text;
    NSString *name = self.nameField.text;
    
    if([self NSStringIsValidEmail:email] && password.length) {
        self.account.email = email;
        self.account.password = password;
        self.account.name = name;
        if(newAccount) {
            [self.account save];
        } else {
            [self.account update];
        }
        return YES;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Credentials"
                                                        message:@"Please check that you have entered a valid email and a password to continue"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

@end
