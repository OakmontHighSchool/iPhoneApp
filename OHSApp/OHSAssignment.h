//
//  OHSAssignment.h
//  OHSApp
//
//  Created by Jon Janzen on 9/13/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OHSAssignment : NSObject

@property (strong,nonatomic) NSString *desc;
@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSString *category;
@property (strong,nonatomic) NSString *score;
@property (strong,nonatomic) NSString *correct;
@property (strong,nonatomic) NSString *percent;
@property (strong,nonatomic) NSString *status;
@property (strong,nonatomic) NSString *dateCompleted;
@property (strong,nonatomic) NSString *dateDue;
@property (strong,nonatomic) NSString *gradingComplete;

@end
