//
//  OHSAddAccountViewController.m
//  OHSApp
//
//  Created by Jon Janzen on 8/13/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import "OHSEditAccountViewController.h"

@implementation OHSEditAccountViewController

BOOL newAccount = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.account == nil) {
        newAccount = YES;
        self.account = [[OHSAccount alloc] init];
    }
    
    [self.nameField setText:self.account.name];
    [self.emailField setText:self.account.email];
    [self.passwordField setText:self.account.password];
    
    [self.nameField setDelegate:self];
    [self.emailField setDelegate:self];
    [self.passwordField setDelegate:self];
}

- (IBAction)buttonPress:(id)sender {
    [self dismissViewControllerAndSave:[[sender title] isEqualToString:@"Save"]];
}

-(BOOL)shouldDismissViewController:(BOOL)save {
    if(save) {
        return [self processAccount];
    } else {
        return YES;
    }
}

-(void)dismissViewControllerAndSave:(BOOL)save {
    if([self shouldDismissViewController:save]) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameField) {
        [self.emailField becomeFirstResponder];
    } else if(textField == self.emailField) {
        [self.passwordField becomeFirstResponder];
    } else if(textField == self.passwordField) {
        [self dismissViewControllerAndSave:YES];
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

-(BOOL) NSStringIsValidEmail:(NSString *)checkString {
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

@end
