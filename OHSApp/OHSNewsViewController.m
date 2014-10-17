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

@implementation OHSNewsViewController

- (IBAction)reloadArticles:(id)sender {
    [self downloadNewsArticles];
}

UIAlertView *alert;

- (void)downloadNewsArticles {
    [self startProgressBar];
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
        [alert dismissWithClickedButtonIndex:0 animated:YES];
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
    [self finishProgressBar];
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
        url = [NSString stringWithFormat:@"%@%@", @"http://ohs.rjuhsd.us", url];
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
