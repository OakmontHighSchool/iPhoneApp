//
//  NSObject+OHSProgressBarManager.m
//  OHSApp
//
//  Created by Jon Janzen on 10/17/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import "OHSProgressBarManager.h"

@implementation OHSProgressBarManager

UIProgressView *bar;

-(id)initWithBar:(UIProgressView*)_bar {
    self = [super init];
    if(self) {
        bar = _bar;
    }
    return self;
}

-(void)startProgressBar {
    [bar setProgress:0 animated:NO];
    [bar setHidden:NO];
    [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.3];
}

-(void)finishProgressBar {
    [bar setProgress:1 animated:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(hideProgressBar) userInfo:nil repeats:NO];
}

-(void)hideProgressBar {
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.3;
    [bar.layer addAnimation:animation forKey:nil];
    
    bar.hidden = YES;
}

float progress;

-(void)increaseProgress {
    float progress = (bar.progress + 0.01f);
    [bar setProgress:progress animated:YES];
    if(progress < 0.95f) [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.4];
}

@end
