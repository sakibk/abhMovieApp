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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FeedCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:feedIdentifier];
    
NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.boxofficemojo.com/data/rss.php?file=topstories.xml"]];
    [RSSParser parseRSSFeedForRequest:req success:^(NSArray *feedItems) {
        _allFeeds=[[NSMutableArray alloc] init];
        for (RSSItem *item in feedItems) {
//            [_allFeeds addObject:[[Feeds alloc] initWithRSSItem:item]];
            _singleFeed = [[Feeds alloc]initWithRSSItem:item];
            [_allFeeds addObject:_singleFeed];
        }
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"ERROR while loading feeds: %@", error);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _allFeeds != nil ? [_allFeeds count] : 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor blackColor]];
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedsCell *cell = (FeedsCell *)[tableView dequeueReusableCellWithIdentifier:feedIdentifier forIndexPath:indexPath];
    _singleFeed = [_allFeeds objectAtIndex:indexPath.row];
    [cell setupFeedCell:_singleFeed];
    // Configure the cell...
    
    return cell;
}



@end
