//
//  OHSClassesViewController.m
//  OHSApp
//
//  Created by Jon Janzen on 9/12/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import "OHSClassesViewController.h"

@implementation OHSClassesViewController

NSString *loginURLString = @"https://homelink.rjuhsd.us/LoginParent.aspx";
NSString *gradesURLString = @"https://homelink.rjuhsd.us/GradebookDetails.aspx";

NSMutableArray *classes;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self downloadClasses];
}

- (void)downloadClasses {
    NSURL *loginUrl = [NSURL URLWithString:loginURLString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:loginUrl];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    NSString *postString = [NSString stringWithFormat:@"portalAccountUsername=%@&portalAccountPassword=%@&checkCookiesEnables=true&checkSilverlightSupport=true&checkMobileDevice=false&checkStandaloneMode=false&checkTabletDevice=false",[self.account email],[self.account password]];
    NSData *data = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[data length]] forHTTPHeaderField:@"Content-Length"];
    self.receivedData = [[NSMutableData alloc] init];
    [[NSURLConnection connectionWithRequest:request delegate:self] start];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@" , error);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    //initialize convert the received data to string with UTF8 encoding
    NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    [self loadTableWithString: htmlSTR];
}

-(void)loadTableWithString: (NSString *)htmlStr {
    TFHpple *mainParser = [TFHpple hppleWithHTMLData:[htmlStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    classes = [[NSMutableArray alloc] init];
    
    int rowCount = 1;
    while(true) {
        NSString *trIdBase = [NSString stringWithFormat:@"//tr[@id = 'ctl00_MainContent_ctl27_DataDetails_ctl0%u_trGBKItem']",rowCount];
        NSArray *titleNodes = [mainParser searchWithXPathQuery:trIdBase];
        if([titleNodes count] > 0) {
            rowCount++;
            OHSClass *class = [[OHSClass alloc] init];
            class.name = [self textOfTdAt:0 parser:mainParser base:trIdBase];
            class.period = [self textOfTdAt:2 parser:mainParser base:trIdBase];
            class.teacherName = [self textOfTdAt:3 parser:mainParser base:trIdBase];
            class.percentage = [self textOfTdAt:4 parser:mainParser base:trIdBase];
            class.mark = [self textOfTdAt:6 parser:mainParser base:trIdBase];
            class.missingAssign = [self textOfTdAt:8 parser:mainParser base:trIdBase];
            class.lastUpdate = [self textOfTdAt:10 parser:mainParser base:trIdBase];
            [classes addObject:class];
        } else {
            break;
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
    return [classes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassItem" forIndexPath:indexPath];
    
    OHSClass *class = (classes)[indexPath.row];
    cell.textLabel.text = class.name;
    
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
    }
}

@end