//
//  OHSClassDetailViewControllerTableViewController.m
//  OHSApp
//
//  Created by Jon Janzen on 9/13/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import "OHSClassDetailViewController.h"
#import "OHSAssignmentViewController.h"

@implementation OHSClassDetailViewController

NSMutableArray *assignments;
UIAlertView *alert;
UIWebView *webView; //WebView for doing dirty things with

NSString *detailUrl = @"https://homelink.rjuhsd.us/GradebookDetails.aspx";

- (void)viewDidLoad {
    self.navigationItem.title = [self.schoolClass name];
    [self.progressBar setHidden:NO];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [self downloadClasses];
}

- (void)downloadClasses {
    [self startProgressBar];
    assignments = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
    
    webView = [[UIWebView alloc] init];
    [webView setDelegate:self];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:detailUrl]]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self loadIds];
}

-(void)loadIds {
    NSString *string = [NSString stringWithFormat:@"$('select option:contains(\\'%@\\')').prop({selected: true}).change();", self.schoolClass.name];
    [webView stringByEvaluatingJavaScriptFromString:string];
    [self performSelector:@selector(loadAssignments) withObject:nil afterDelay:1];
}

-(void)webView:(UIWebView *)myWebView didFailLoadWithError:(NSError *)error {
    [self finishProgressBar];
    alert = [[UIAlertView alloc] initWithTitle:@"No Internet"
                             message:[[[error userInfo] objectForKey:NSUnderlyingErrorKey] localizedDescription]
                             delegate:nil
                             cancelButtonTitle:@"Ok"
                             otherButtonTitles:nil];
    [alert show];
}

-(void)loadAssignments {
    NSString *base = @"$('#ctl00_MainContent_subGBS_tblEverything table[style=\"border-collapse:collapse;border-style:none;\"] table')[0].children[0].children";
    NSInteger count = [[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@.length",base]] integerValue];
    
    for(int i=1;i<=count-1;i++) {
        NSString *cellSelectorBase = [NSString stringWithFormat:@"%@[%u].children",base,i];
        OHSAssignment *assign = [[OHSAssignment alloc] init];
        assign.desc = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@[2].textContent",cellSelectorBase]];
        if(assign.desc.length > 7) {
            assign.desc = [assign.desc substringFromIndex:6];
            NSString *new = @"";
            for(int i=0;i<assign.desc.length;i++) {
                char c = [assign.desc characterAtIndex:i];
                if(c != '\n') {
                    new = [NSString stringWithFormat:@"%@%c",new,c];
                } else {
                    break;
                }
            }
            assign.desc = new;
        }
        assign.type = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@[3].textContent",cellSelectorBase]];
        assign.category = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@[4].textContent",cellSelectorBase]];
        NSString *first = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@[5].children[0].children[0].children[0].children[0].textContent",cellSelectorBase]];
        NSString *second = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@[5].children[0].children[0].children[0].children[2].textContent",cellSelectorBase]];
        assign.score = [NSString stringWithFormat:@"%@ / %@",first,second];
        assign.correct = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@[6].textContent",cellSelectorBase]];
        assign.percent = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@[7].textContent",cellSelectorBase]];
        assign.status = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@[8].textContent",cellSelectorBase]];
        assign.dateCompleted = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@[9].textContent",cellSelectorBase]];
        assign.dateDue = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@[10].textContent",cellSelectorBase]];
        assign.gradingComplete = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@[11].textContent",cellSelectorBase]];
        if(i != 1) {
            [assignments addObject:assign];
        }
    }
    
    [self.tableView reloadData];
    [self finishProgressBar];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [assignments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssignmentItem" forIndexPath:indexPath];
    
    OHSAssignment *assignment = (assignments)[indexPath.row];
    cell.textLabel.text = assignment.desc;
    cell.detailTextLabel.text = assignment.percent;
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"viewAssignment"]){
        //Get row id
        NSInteger rowId = [self.tableView indexPathForSelectedRow].row;
        //Get new view controller...
        OHSAssignmentViewController *controller = (OHSAssignmentViewController *)segue.destinationViewController;
        OHSAssignment *assignment = [assignments objectAtIndex:rowId];
        controller.assignment = assignment;
    }
}

- (IBAction)refreshButtonPress:(id)sender {
    [self downloadClasses];
}

-(void)startProgressBar {
    [self.progressBar setProgress:0 animated:NO];
    [self.progressBar setHidden:NO];
    [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.3];
}

-(void)finishProgressBar {
    [self.progressBar setProgress:1 animated:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(hideProgressBar) userInfo:nil repeats:NO];
}

-(void)hideProgressBar {
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.3;
    [self.progressBar.layer addAnimation:animation forKey:nil];
    
    self.progressBar.hidden = YES;
}

float progress;

-(void)increaseProgress {
    float progress = (self.progressBar.progress + 0.01f);
    [self.progressBar setProgress:progress animated:YES];
    if(progress < 0.95f) [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.4];
}

@end