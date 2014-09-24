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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    NSString *password = self.emailField.text;
    NSString *name = self.nameField.text;
    
    if([self NSStringIsValidEmail:email] && password.length) {
        OHSAccount *account = [[OHSAccount alloc] init];
        account.email = email;
        account.password = password;
        account.name = name;
        [account save];
        return YES;
    } else {
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
