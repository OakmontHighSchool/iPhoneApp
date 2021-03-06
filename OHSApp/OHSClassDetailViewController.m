//
//  OHSClassDetailViewControllerTableViewController.m
//  OHSApp
//
//  Created by Jon Janzen on 9/13/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import "OHSClassDetailViewController.h"
#import "OHSAssignmentViewController.h"
#import "OHSProgressBarManager.h"

@implementation OHSClassDetailViewController

NSMutableArray *assignments;
UIAlertView *alert;
UIWebView *webView; //WebView for doing dirty things with
NSString *hasDataFor = @"";

NSString *detailUrl = @"https://homelink.rjuhsd.us/GradebookDetails.aspx";
OHSProgressBarManager *barManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [self.schoolClass name];
    barManager = [[OHSProgressBarManager alloc] initWithBar:self.progressBar andRefreshButton:self.navigationItem.rightBarButtonItem];
    webView = [[UIWebView alloc] init];
    [webView setDelegate:self];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(![hasDataFor isEqualToString:[NSString stringWithFormat:@"%@%@",self.schoolClass.name,self.account.name]]) {
        [self downloadClasses];
    }
}

- (void)downloadClasses {
    [barManager startProgressBar];
    hasDataFor = @"";
    assignments = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:detailUrl]]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *ajaxInject=@"$('#ctl00_MainContent_subGBS_upEverything').bind('DOMSubtreeModified', function(event){ window.location = 'fail://doneLoading'; $('#ctl00_MainContent_subGBS_upEverything').unbind(); });";
    [webView stringByEvaluatingJavaScriptFromString:ajaxInject]; //Inject payload
    NSRange lastDash = [self.schoolClass.name rangeOfString:@"-" options:NSBackwardsSearch];
    NSString *fixedName = [self.schoolClass.name substringWithRange:NSMakeRange(0,lastDash.location-1)];
    NSString *string = [NSString stringWithFormat:@"$('select option:contains(\\'%@\\')').prop({selected: true}).change();", fixedName];
    [webView stringByEvaluatingJavaScriptFromString:string];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    BOOL shouldNot = ![request.URL.absoluteString hasPrefix:@"fail"];
    if([request.URL.absoluteString isEqualToString:@"fail://doneLoading"]) {
        [self loadAssignments];
    }
    return shouldNot;
}

-(void)webView:(UIWebView *)myWebView didFailLoadWithError:(NSError *)error {
    [barManager finishProgressBar];
    alert = [[UIAlertView alloc] initWithTitle:@"No Internet"
                             message:[[[error userInfo] objectForKey:NSUnderlyingErrorKey] localizedDescription]
                             delegate:nil
                             cancelButtonTitle:@"Ok"
                             otherButtonTitles:nil];
    [alert show];
}

NSString *rowSelectorBase = @"$('#ctl00_MainContent_subGBS_tblEverything table[style=\"border-collapse:collapse; border-style:none;\"] table:first > tbody > tr[style!=\"display: none;\"]')";

-(void)loadAssignments {
    NSInteger count = [[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@.length",rowSelectorBase]] integerValue];
    
    for(int i=1;i<=count-1;i++) {
        NSString *cellSelectorBase = [NSString stringWithFormat:@"%@[%u].children",rowSelectorBase,i];
        OHSAssignment *assign = [[OHSAssignment alloc] init];
        assign.desc = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@[2].textContent",cellSelectorBase]];
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
        [assignments addObject:assign];
    }
    
    [self.tableView reloadData];
    [barManager finishProgressBar];
    hasDataFor = [NSString stringWithFormat:@"%@%@",self.schoolClass.name,self.account.name];
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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@",assignment.score,assignment.percent];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"enable_grade_icons"] == nil || [[NSUserDefaults standardUserDefaults] boolForKey:@"enable_grade_icons"]) {
        UIImage* image;
        int percent = [assignment.percent intValue];
        
        if(percent >= 90) { //A
            image = [UIImage imageNamed:@"levelA"];
        } else if(percent >= 80) { //B
            image = [UIImage imageNamed:@"levelB"];
        } else if(percent >= 70) { //C
            image = [UIImage imageNamed:@"levelC"];
        } else if(percent >= 60) { //D
            image = [UIImage imageNamed:@"levelD"];
        } else { // <= F
            image = [UIImage imageNamed:@"levelF"];
        }
        
        cell.imageView.image = image;
    } else {
        cell.imageView.image = nil;
    }
    
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

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [webView setDelegate:NULL];
    }
    [super viewWillDisappear:animated];
}

@end