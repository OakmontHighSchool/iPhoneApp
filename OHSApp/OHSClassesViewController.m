//
//  OHSClassesViewController.m
//  OHSApp
//
//  Created by Jon Janzen on 9/12/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import "OHSClassesViewController.h"
#import "TFHpple.h"
#import "OHSClass.h"
#import "OHSClassDetailViewController.h"
#import "OHSAccountsViewController.h"

@implementation OHSClassesViewController

NSString *loginURLString = @"https://homelink.rjuhsd.us/LoginParent.aspx";
NSString *logoutURLString = @"https://homelink.rjuhsd.us/Logout.aspx";

NSMutableArray *classes;
NSString *loadedDataFor;
bool loadInProgress = false;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(![loadedDataFor isEqualToString:[self.account accountAsString]]) {
        [self downloadClasses];
    }
}

UIAlertView *alert;

- (void)downloadClasses {
    if(loadInProgress) {
        return;
    }
    classes = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
    [self startProgressBar];
    [NSData dataWithContentsOfURL:[NSURL URLWithString:logoutURLString]]; //Logout (if necessary) to allow login
    [self.progressBar setProgress:0.15 animated:YES];
    NSURL *loginUrl = [NSURL URLWithString:loginURLString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:loginUrl];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    NSString *postString = [NSString stringWithFormat:@"portalAccountUsername=%@&portalAccountPassword=%@&checkCookiesEnables=true&checkSilverlightSupport=true&checkMobileDevice=false&checkStandaloneMode=false&checkTabletDevice=false",[self.account email],[self.account password]];
    NSData *data = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[data length]] forHTTPHeaderField:@"Content-Length"];
    self.receivedData = [[NSMutableData alloc] init];
    [self.progressBar setProgress:0.3 animated:YES];
    [[NSURLConnection connectionWithRequest:request delegate:self] start];
    loadedDataFor = [self.account accountAsString];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
    float progress = self.progressBar.progress;
    if(progress < 0.95) {
        [self.progressBar setProgress:(progress+=.01) animated:YES];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self finishProgressBar];
    alert = [[UIAlertView alloc] initWithTitle:@"No Internet"
                                       message:[[[error userInfo] objectForKey:NSUnderlyingErrorKey] localizedDescription]
                                      delegate:self
                             cancelButtonTitle:@"Ok"
                             otherButtonTitles:nil];
    [alert show];
    loadedDataFor = @""; //Force reload next time.
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //convert the received data to string with UTF8 encoding
    NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    [self loadTableWithString: htmlSTR];
}

-(void)loadTableWithString: (NSString *)htmlStr {
    TFHpple *mainParser = [TFHpple hppleWithHTMLData:[htmlStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    int rowCount = 1;
    while(true) {
        NSString *trIdBase = [NSString stringWithFormat:@"//tr[@id = 'ctl00_MainContent_ctl27_DataDetails_ctl0%u_trGBKItem']",rowCount];
        NSArray *titleNodes = [mainParser searchWithXPathQuery:trIdBase];
        if([titleNodes count] > 0) {
            rowCount++;
            OHSClass *class = [[OHSClass alloc] init];
            class.name = [self textOfTdAt:1 parser:mainParser base:trIdBase];
            class.period = [self textOfTdAt:3 parser:mainParser base:trIdBase];
            class.teacherName = [self textOfTdAt:4 parser:mainParser base:trIdBase];
            class.percentage = [self textOfTdAt:5 parser:mainParser base:trIdBase];
            class.mark = [self textOfTdAt:6 parser:mainParser base:trIdBase];
            class.missingAssign = [self textOfTdAt:8 parser:mainParser base:trIdBase];
            class.lastUpdate = [self textOfTdAt:10 parser:mainParser base:trIdBase];
            [classes addObject:class];
        } else {
            if(rowCount == 1) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Credentials"
                    message:@"Either your email and password are wrong or Aeries is unavailable."
                    delegate:self
                    cancelButtonTitle:@"OK"
                    otherButtonTitles:@"Edit Account",nil];
                [alert show];
                loadedDataFor = @""; //Force reload next time.
            }
            break;
        }
    }
    
    [self.tableView reloadData];
    [self finishProgressBar];
}

- (NSString *)textOfTdAt:(NSInteger)i parser:(TFHpple *)hppleParser base:(NSString *)trIdBase {
    NSString *path = [NSString stringWithFormat:@"%@/td",trIdBase];
    if(i == 1) {
        path = [NSString stringWithFormat:@"%@/a",path];
    } else if(i == 5) {
        path = [NSString stringWithFormat:@"%@[%ld]/span",path,(long)i];
    } else {
        path = [NSString stringWithFormat:@"%@[%ld]",path,(long)i];
    }
    return [[[hppleParser searchWithXPathQuery:path] objectAtIndex:0] text];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [classes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassItem" forIndexPath:indexPath];
    
    OHSClass *class = (classes)[indexPath.row];
    cell.textLabel.text = class.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%%",class.percentage];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"viewClass"]){
        //Get row id
        NSInteger rowId = [self.tableView indexPathForSelectedRow].row;
        //Get new view controller...
        OHSClassDetailViewController *controller = (OHSClassDetailViewController *)segue.destinationViewController;
        OHSClass *class = [classes objectAtIndex:rowId];
        controller.schoolClass = class;
        controller.account = self.account;
    }
}

- (IBAction)refreshButtonClick:(id)sender {
    [self downloadClasses];
}

-(void)startProgressBar {
    loadInProgress = true;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.progressBar setProgress:0 animated:NO];
    [self.progressBar setHidden:NO];
}

-(void)finishProgressBar {
    [self.progressBar setProgress:1 animated:YES];
    loadInProgress = false;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(hideProgressBar) userInfo:nil repeats:NO];
}

-(void)hideProgressBar {
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.3;
    [self.progressBar.layer addAnimation:animation forKey:nil];
    
    self.progressBar.hidden = YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
    if(buttonIndex==1) {
        [(OHSAccountsViewController*)self.navigationController.visibleViewController triggerEditAccount:self.account];
    }
}

@end
