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

@interface OHSNewsViewController ()

@end

@implementation OHSNewsViewController

- (IBAction)unwindToArticleOverview:(UIStoryboardSegue *)segue
{
    
}

- (IBAction)reloadArticles:(id)sender {
    [self downloadNewsArticles];
}

- (void)downloadNewsArticles
{
    // 1
    NSURL *newsUrl = [NSURL URLWithString:@"http://ohs.rjuhsd.us/site/default.aspx?PageID=1"];
    NSData *newsHtmlData = [NSData dataWithContentsOfURL:newsUrl];
    
    TFHpple *newsParser = [TFHpple hppleWithHTMLData:newsHtmlData];
    
    //Get all the titles into an array
    NSString *titleXpathQueryString = @"//div[@class='ui-widget app headlines']/div[@class='ui-widget-detail']/ul[@class='ui-articles']/li/div/h1/a/span/text()";
    NSArray *titleNodes = [newsParser searchWithXPathQuery:titleXpathQueryString];
    
    //Get all the links into an array, hopefully in the same order as above
    NSString *linkXpathQueryString = @"//div[@class='ui-widget app headlines']/div[@class='ui-widget-detail']/ul[@class='ui-articles']/li/div/h1/a/@href";
    NSArray *linkNodes = [newsParser searchWithXPathQuery:linkXpathQueryString];
    
    NSMutableArray *newArticles = [[NSMutableArray alloc] initWithCapacity:10];
    for(int i=0;i<[titleNodes count];i++) {
        OHSNewsArticle *article = [[OHSNewsArticle alloc] init];
        
        article.title = [[titleNodes objectAtIndex:i] content];
        
        article.link = [[linkNodes objectAtIndex:i] text];
        
        [newArticles addObject:article];
    }
    
    self.articles = newArticles;
    [self.tableView reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self downloadNewsArticles];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showArticle"]){
        //Get row id
        NSInteger rowId = [self.tableView indexPathForSelectedRow].row;
        //Get new view controller...
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        OHSArticleViewController *controller = (OHSArticleViewController *)navController.topViewController;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.articles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsItem" forIndexPath:indexPath];
    
    OHSNewsArticle *article = (self.articles)[indexPath.row];
    cell.textLabel.text = article.title;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
