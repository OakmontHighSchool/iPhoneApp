//
//  OHSClassDetailViewControllerTableViewController.m
//  OHSApp
//
//  Created by Jon Janzen on 9/13/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import "OHSClassDetailViewController.h"

@interface OHSClassDetailViewController ()

@end

@implementation OHSClassDetailViewController

NSMutableArray *assignments;

NSString *detailUrl = @"https://homelink.rjuhsd.us/GradebookDetails.aspx";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [self.schoolClass name];
    [self downloadClasses];
}

- (void)downloadClasses {
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:detailUrl]];
    [self loadIdsWithString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
}

NSMutableData *receivedData;

-(void)loadIdsWithString: (NSString *)htmlStr {
    TFHpple *mainParser = [TFHpple hppleWithHTMLData:[htmlStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    assignments = [[NSMutableArray alloc] init];
    
    NSString *viewState = [[[mainParser searchWithXPathQuery:@"//input[@id='__VIEWSTATE']/@value"] objectAtIndex:0] text];
    //NSLog(@"%@",viewState);
    
    NSString *selBase = @"//select[@id='ctl00_MainContent_subGBS_dlGN']/option";
    
    NSArray *classNames = [mainParser searchWithXPathQuery:selBase];
    
    BOOL skipRequest = NO;
    
    for(int i=0;i<[classNames count];i++) {
        NSArray *classIds = [mainParser searchWithXPathQuery:[NSString stringWithFormat:@"%@[%d]/@value",selBase,i+1]];
        NSString *stupidTitle = [[classNames objectAtIndex:i]text];
        NSString *stupidId = [[classIds objectAtIndex:0]text];
        if(![stupidTitle hasPrefix:@"<<"]) {
            if (!([stupidTitle rangeOfString:[self.schoolClass name]].location == NSNotFound)) {
                self.schoolClass.aeriesID = stupidId;
                if(i == 0) {
                    skipRequest = YES;
                }
            }
        }
    }
    
    if(skipRequest) {
        [self loadTableWithString:htmlStr];
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:detailUrl]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    NSString *postString = [NSString stringWithFormat:@"ctl00$MainContent$subGBS$dlGN=%@&__EVENTTARGET=ctl00&MainContent&subGBS&dlGN&__VIEWSTATE=%@",[self.schoolClass aeriesID],viewState];
    NSData *data = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[data length]] forHTTPHeaderField:@"Content-Length"];
    receivedData = [[NSMutableData alloc] init];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@" , error);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //initialize convert the received data to string with UTF8 encoding
    NSString *htmlSTR = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    [self loadTableWithString: htmlSTR];
}

-(void)loadTableWithString: (NSString *)htmlStr {
    TFHpple *mainParser = [TFHpple hppleWithHTMLData:[htmlStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *rowsBase = @"//table[@id='ctl00_MainContent_subGBS_tblEverything']//div[@id='ctl00_MainContent_subGBS_upEverything']/table[2]/tr/td/table/tr";
    
    NSArray *rows = [mainParser searchWithXPathQuery:rowsBase];
    
    for(int i=1;i<=[rows count];i++) {
        NSString *cellsSelector = [NSString stringWithFormat:@"%@[%u]/td",rowsBase,i];
        NSArray *cells = [mainParser searchWithXPathQuery:cellsSelector];
        OHSAssignment *assign = [[OHSAssignment alloc] init];
        assign.description = [[[cells objectAtIndex:2] text] substringFromIndex:7];
        assign.type = [[cells objectAtIndex:3] text];
        assign.category = [[cells objectAtIndex:4] text];
        assign.score = [[cells objectAtIndex:5] text];
        assign.correct = [[cells objectAtIndex:6] text];
        assign.percent = [[cells objectAtIndex:7] text];
        assign.status = [[cells objectAtIndex:8] text];
        assign.dateCompleted = [[cells objectAtIndex:9] text];
        assign.dateDue = [[cells objectAtIndex:10] text];
        assign.gradingComplete = [[cells objectAtIndex:11] text];
        if(i != 1) {
            [assignments addObject:assign];
        }
    }
    
    [self.tableView reloadData];
}

- (NSString *)textOfTdAt:(NSInteger)i parser:(TFHpple *)hppleParser base:(NSString *)trIdBase {
    NSString *path = [NSString stringWithFormat:@"%@/td",trIdBase];
    if(i == 0) {
        path = [NSString stringWithFormat:@"%@/a",path];
    } else {
        path = [NSString stringWithFormat:@"%@[%ld]",path,(long)i];
    }
    return [[[hppleParser searchWithXPathQuery:path] objectAtIndex:0] text];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [assignments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssignmentItem" forIndexPath:indexPath];
    
    OHSAssignment *assignment = (assignments)[indexPath.row];
    cell.textLabel.text = assignment.description;
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"viewAssignment"]){
        //Get row id
        NSInteger rowId = [self.tableView indexPathForSelectedRow].row;
        //Get new view controller...
        OHSAssignmentViewController *controller = (OHSAssignmentViewController *)segue.destinationViewController;
        OHSAssignment *assignment = [assignments objectAtIndex:rowId];
        controller.assignment = assignment;
    }
}

@end
