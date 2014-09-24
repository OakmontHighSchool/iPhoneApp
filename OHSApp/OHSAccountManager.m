//
//  OHSAccountManager.m
//  OHSApp
//
//  Created by Jon Janzen on 8/13/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import "OHSAccountManager.h"

@implementation OHSAccountManager

NSString *filePath;

-(id)init {
    if(self = [super init]) {
        [self reload];
        return self;
    } else {
        return nil;
    }
}

-(void)reload {
    NSString* dirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = @"profiles.js";
    filePath = [dirPath stringByAppendingPathComponent:fileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
    //filePath = [[NSBundle mainBundle] pathForResource:@"accounts" ofType:@"json"];
    _accounts = [[NSMutableArray alloc] init];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:fileData options:kNilOptions error:nil];
    
    for(int i=0;i<[json count];i++) {
        NSDictionary *dict = [json objectAtIndex:i];
        OHSAccount *account = [[OHSAccount alloc] init];
        account.email = [dict objectForKey:@"email"];
        account.password = [dict objectForKey:@"password"];
        account.name = [dict objectForKey:@"name"];
        if(account.name == nil) {
            account.name = @"";
        }
        [_accounts addObject:account];
    }
}

-(void)saveChangesFor:(OHSAccount *)account {
    
}

-(void)removeObjectAtIndex:(NSInteger)index {
    [self.accounts removeObjectAtIndex:index];
    [self saveFile];
}

-(void)saveNewAccount:(OHSAccount *)account {
    [_accounts addObject:account];
    [self saveFile];
}

-(void)saveFile {
    NSMutableArray *jsonAccounts = [[NSMutableArray alloc] init];
    for (int i=0;i<[_accounts count];i++) {
        OHSAccount *account = [_accounts objectAtIndex:i];
        NSArray *objects=[[NSArray alloc]initWithObjects:account.email,account.password,account.name,nil];
        NSArray *keys=[[NSArray alloc]initWithObjects:@"email",@"password",@"name",nil];
        NSDictionary *dict=[NSDictionary dictionaryWithObjects:objects forKeys:keys];
        [jsonAccounts addObject:dict];
    }
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:jsonAccounts options:NSJSONWritingPrettyPrinted error:nil];
    [jsonData writeToFile:filePath options:NSDataWritingAtomic error:nil];
    
}

@end
