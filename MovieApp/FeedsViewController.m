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


@interface FeedsViewController ()

@property NSMutableArray<Feeds *> *allFeeds;
@property Feeds *singleFeed;

@end

@implementation FeedsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    _tableView.separatorInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
        
    [self.tableView registerNib:[UINib nibWithNibName:@"FeedCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:feedIdentifier];
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self automaticallyAdjustsScrollViewInsets];
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
//        cell.contentView.backgroundColor = [UIColor clearColor];
        UIView *RoundedCornerView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 10.0, 409.0, 232.0)];
        RoundedCornerView.backgroundColor = [UIColor blackColor];
        RoundedCornerView.layer.masksToBounds = NO;
        RoundedCornerView.layer.cornerRadius = 3.0;
        [cell.contentView addSubview:RoundedCornerView];
        [cell.contentView sendSubviewToBack:RoundedCornerView];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _singleFeed =[_allFeeds objectAtIndex:indexPath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_singleFeed.link]];
}

@end
