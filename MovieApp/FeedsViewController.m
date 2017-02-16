//
//  ViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 16/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "FeedsViewController.h"
#import <RestKit/RestKit.h>
#import "Movie.h"
#import "Genre.h"
#import "FeedsCell.h"
#import "Feeds.h"
#import "RSSParser.h"
#import "RSSItem.h"
#import <LGSideMenuController/LGSideMenuController.h>
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>
#import "LeftViewController.h"


@interface FeedsViewController ()

@property NSMutableArray<Feeds *> *allFeeds;
@property Feeds *singleFeed;
@property BOOL isNavBarSet;

@end

@implementation FeedsViewController
{
    
    UITableViewController *leftViewController;
    UITableViewController *rightViewController;
    LGSideMenuController *sideMenuController;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    _tableView.separatorInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    
    _isNavBarSet=NO;
        
    [self.tableView registerNib:[UINib nibWithNibName:@"FeedCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:feedIdentifier];
    [self getFeeds];
    [self setupSearchbar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self automaticallyAdjustsScrollViewInsets];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)getFeeds{
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.boxofficemojo.com/data/rss.php?file=topstories.xml"]];
    [RSSParser parseRSSFeedForRequest:req success:^(NSArray *feedItems) {
        _allFeeds=[[NSMutableArray alloc] init];
        for (RSSItem *item in feedItems) {
            //            [_allFeeds addObject:[[Feeds alloc] initWithRSSItem:item]];
            _singleFeed = [[Feeds alloc]initWithRSSItem:item];
            if([_singleFeed.desc length]>15){
                [_allFeeds addObject:_singleFeed];
            }
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"ERROR while loading feeds: %@", error);
    }];
}

-(void)setupSearchbar{
    if(!_isNavBarSet){
    UIBarButtonItem *pieItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"PieIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(pushSideBar:)];
    self.navigationItem.leftBarButtonItem=pieItem;
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor lightGrayColor];
    UITextField *txtSearchField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, 330, 27)];
    txtSearchField.font = [UIFont systemFontOfSize:15];
    txtSearchField.backgroundColor = [UIColor darkGrayColor];
    txtSearchField.tintColor= [UIColor colorWithRed:42 green:45 blue:44 alpha:100];
    txtSearchField.textColor= [UIColor colorWithRed:216 green:216 blue:216 alpha:100];
    txtSearchField.textAlignment = NSTextAlignmentCenter;
    txtSearchField.placeholder = @"🔍 Search";
    txtSearchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txtSearchField.borderStyle=UITextBorderStyleRoundedRect;
        txtSearchField.userInteractionEnabled=NO;
    self.navigationItem.titleView =txtSearchField;
    _isNavBarSet=YES;
    }
}

-(IBAction)pushSideBar:(id)sender{
    [self.sideMenuController showLeftViewAnimated:YES completionHandler:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _allFeeds != nil ? [_allFeeds count] : 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedsCell *cell = (FeedsCell *)[tableView dequeueReusableCellWithIdentifier:feedIdentifier forIndexPath:indexPath];
    _singleFeed = [_allFeeds objectAtIndex:indexPath.row];
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setupFeedCell:_singleFeed];
    // Configure the cell...
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 252.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(FeedsCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _singleFeed =[_allFeeds objectAtIndex:indexPath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_singleFeed.link]];
}

@end
