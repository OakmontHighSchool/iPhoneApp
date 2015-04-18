//
//  OHSNewsViewController.m
//  OHSApp
//
//  Created by Jon Janzen on 7/20/14.
//  Copyright (c) 2014 Oakmont High School. All rights reserved.
//

#import "OHSNewsViewController.h"
#import "OHSNewsArticle.h"
#import "TFHpple.h"
#import "OHSArticleViewController.h"
#import "OHSProgressBarManager.h"

@implementation OHSNewsViewController

- (IBAction)reloadArticles:(id)sender {
    [self downloadNewsArticles];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    barManager = [[OHSProgressBarManager alloc] initWithBar:self.progressBar andRefreshButton:self.navigationItem.rightBarButtonItem];
}

UIAlertView *alert;
OHSProgressBarManager *barManager;

- (void)downloadNewsArticles {
    [barManager startProgressBar];
    NSURL *newsUrl = [NSURL URLWithString:@"http://ohs.rjuhsd.us/site/default.aspx?PageID=1"];
    NSData *newsHtmlData = [NSData dataWithContentsOfURL:newsUrl];
    
    TFHpple *newsParser = [TFHpple hppleWithHTMLData:newsHtmlData];
    
    NSString *baseXpathQueryString = @"//div[@class='ui-widget app headlines']/div[@class='ui-widget-detail']/ul[@class='ui-articles']/li/div/h1/a";
    NSString *titleXpathQueryString = [NSString stringWithFormat:@"%@%@",baseXpathQueryString,@"/span/text()"];
    NSString *linkXpathQueryString = [NSString stringWithFormat:@"%@%@",baseXpathQueryString,@"/@href"];
    
    //Get all the titles into an array
    NSArray *titleNodes = [newsParser searchWithXPathQuery:titleXpathQueryString];
    
    //Get all the links into an array, hopefully in the same order as above
    NSArray *linkNodes = [newsParser searchWithXPathQuery:linkXpathQueryString];
    
    NSMutableArray *newArticles = [[NSMutableArray alloc] initWithCapacity:10];
    if(titleNodes.count <= 0) {
        [barManager finishProgressBar];
        alert = [[UIAlertView alloc] initWithTitle:@"No Internet"
                                           message:@"Please connect your device to the internet."
                                          delegate:nil
                                 cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
        [alert show];
        return;
    }
    for(int i=0;i<[titleNodes count];i++) {
        OHSNewsArticle *article = [[OHSNewsArticle alloc] init];
        article.title = [[titleNodes objectAtIndex:i] content];
        article.link = [[linkNodes objectAtIndex:i] text];
        [newArticles addObject:article];
    }
    
    self.articles = newArticles;
    [self.tableView reloadData];
    [barManager finishProgressBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self downloadNewsArticles];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showArticle"]){
        //Get row id
        NSInteger rowId = [self.tableView indexPathForSelectedRow].row;
        //Get new view controller...
        OHSArticleViewController *controller = (OHSArticleViewController *)segue.destinationViewController;
        OHSNewsArticle *article = [self.articles objectAtIndex:rowId];
        //Get the link url
        NSString *url = article.link;
        //Remove the rubish at the beginning
        url = [url substringFromIndex:5];
        //Add the proper domain
        url = [NSString stringWithFormat:@"%@%@", @"http://www.rjuhsd.us", url];
        controller.url = url;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.articles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsItem" forIndexPath:indexPath];
    
    OHSNewsArticle *article = (self.articles)[indexPath.row];
    cell.textLabel.text = article.title;
    
    return cell;
}

@end
