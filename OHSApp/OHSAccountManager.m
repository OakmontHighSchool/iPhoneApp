//
//  OHSAccountManager.m
//  OHSApp
//
//  Created by Jon Janzen on 8/13/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import "OHSAccountManager.h"

@implementation OHSAccountManager

NSMutableArray *accounts;
NSString *filePath;

-(id)init {
    if(self = [super init]) {
        filePath = [[NSBundle mainBundle] pathForResource:@"accounts" ofType:@"json"];
        NSLog(@"Filepath: %@", filePath);
        accounts = [[NSMutableArray alloc] init];
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        NSString *fileString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"File data:%@",fileData);
        NSLog(@"File string:%@",fileString);
        NSArray *json = [NSJSONSerialization JSONObjectWithData:fileData options:kNilOptions error:nil];
        
        NSLog(@"Count: %lu",(unsigned long)[json count]);
        
        for(int i=0;i<[json count];i++) {
            NSDictionary *dict = [json objectAtIndex:i];
            OHSAccount *account = [[OHSAccount alloc] init];
            account.email = [dict objectForKey:@"email"];
            account.password = [dict objectForKey:@"password"];
            NSLog(@"%@,%@",account.email,account.password);
            [accounts addObject:account];
        }
        
        return self;
    } else {
        return nil;
    }
}

-(void)saveChangesFor:(OHSAccount *)account {
    
}

-(void)saveNewAccount:(OHSAccount *)account {
    [accounts addObject:account];
    [self saveFile];
}

-(void)saveFile {
    NSMutableArray *jsonAccounts = [[NSMutableArray alloc] init];
    NSLog(@"Accounts to save: %lu", (unsigned long)[accounts count]);
    for (int i=0;i<[accounts count];i++) {
        OHSAccount *account = [accounts objectAtIndex:i];
        NSArray *objects=[[NSArray alloc]initWithObjects:account.email,account.password,nil];
        NSArray *keys=[[NSArray alloc]initWithObjects:@"email",@"password",nil];
        NSDictionary *dict=[NSDictionary dictionaryWithObjects:objects forKeys:keys];
        [jsonAccounts addObject:dict];
    }
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:jsonAccounts options:NSJSONWritingPrettyPrinted error:nil];
    [jsonData writeToFile:filePath options:NSDataWritingAtomic error:nil];
    
}

@end
