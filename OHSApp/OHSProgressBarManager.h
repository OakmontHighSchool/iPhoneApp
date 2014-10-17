//
//  NSObject+OHSProgressBarManager.h
//  OHSApp
//
//  Created by Jon Janzen on 10/17/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OHSProgressBarManager : NSObject

-(id)initWithBar:(UIProgressView*)_bar;
-(void)startProgressBar;
-(void)finishProgressBar;

@end
