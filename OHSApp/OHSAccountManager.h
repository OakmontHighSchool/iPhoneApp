//
//  OHSAccountManager.h
//  OHSApp
//
//  Created by Jon Janzen on 8/13/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OHSAccount.h"

@interface OHSAccountManager : NSObject
-(void)saveChangesFor: (OHSAccount*)account;
-(void)saveNewAccount: (OHSAccount*)account;
-(void)reload;
-(void)removeObjectAtIndex: (NSInteger)index;
@property (strong, nonatomic) NSMutableArray *accounts;
@end
