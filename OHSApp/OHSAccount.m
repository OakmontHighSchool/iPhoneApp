//
//  OHSAccount.m
//  OHSApp
//
//  Created by Jon Janzen on 8/11/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import "OHSAccount.h"
#import "OHSAccountManager.h"
#import "TFHpple.h"

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

-(BOOL)getClasses {
    NSURL *newsUrl = [NSURL URLWithString:@"http://ohs.rjuhsd.us/site/default.aspx?PageID=1"];
    NSData *newsHtmlData = [NSData dataWithContentsOfURL:newsUrl];
    
    TFHpple *newsParser = [TFHpple hppleWithHTMLData:newsHtmlData];
    
    NSString *baseXpathQueryString = @"//div[@class='ui-widget app headlines']/div[@class='ui-widget-detail']/ul[@class='ui-articles']/li/div/h1/a";
    
    //Get all the titles into an array
    NSArray *titleNodes = [newsParser searchWithXPathQuery:baseXpathQueryString];
    
    return NO;
}

-(void)save {
    OHSAccountManager *manager = [[OHSAccountManager alloc] init];
    [manager saveNewAccount:self];
}

@end
