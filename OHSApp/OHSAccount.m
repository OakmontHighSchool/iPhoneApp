//
//  OHSAccount.m
//  OHSApp
//
//  Created by Jon Janzen on 8/11/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import "OHSAccount.h"
#import "OHSAccountManager.h"

@implementation OHSAccount

-(id)initWithAccountNumber: (NSInteger)ID {
    if ((self = [super init]) && (ID >= 0)) {
        *self.identifier = ID;
        return self;
    } else {
        return nil;
    }
}

-(id)initNewAccount {
    if( self = [super init] ) {
        *self.identifier = -1;
        return self;
    } else {
        return nil;
    }
}

-(void)save {
    OHSAccountManager *manager = [[OHSAccountManager alloc] init];
    [manager saveNewAccount:self];
}

-(void)update {
    OHSAccountManager *manager = [[OHSAccountManager alloc] init];
    [manager saveChangesFor:self index:self.index];
}

-(NSString*)accountAsString {
    return [NSString stringWithFormat:@"%@:%@",self.name,self.email];
}

@end
