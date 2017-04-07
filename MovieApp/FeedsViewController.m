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
#import "ConnectivityTest.h"
#import <Realm/Realm.h>
#import "RLMFeeds.h"
#import "RLMStoredObjects.h"
#import <Reachability/Reachability.h>
#import "PushOnFirebase.h"


@interface FeedsViewController ()

@property NSMutableArray<RLMFeeds *> *allFeeds;
@property RLMArray<RLMFeeds*> *storedFeeds;
@property RLMFeeds *singleFeed;
@property BOOL isNavBarSet;
@property BOOL isConnected;
@property RLMRealm *realm;
@property RLMStoredObjects *storedObjetctFeeds;

@end

@implementation FeedsViewController
{
    
    UITableViewController *leftViewController;
    UITableViewController *rightViewController;
    LGSideMenuController *sideMenuController;
    Reachability *reachability;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _realm = [RLMRealm defaultRealm];
    _tableView.separatorInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    _storedObjetctFeeds = [[RLMStoredObjects alloc]init];
    _isNavBarSet=NO;
    _isConnected =[ConnectivityTest isConnected];
    [self.tableView registerNib:[UINib nibWithNibName:@"FeedCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:feedIdentifier];
    if(_isConnected){
        [self getFeeds];
    }
    else{
        [self getStoredFeeds];
    }
    [self setupSearchbar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
    
}

- (void)reachabilityDidChange:(NSNotification *)notification {
    
    if (!reachability) {
        reachability = (Reachability *)[notification object];
        
        if ([reachability isReachable]) {
            NSLog(@"Reachable");
            [self getFeeds];
        } else {
            NSLog(@"Unreachable");
            [self getStoredFeeds];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self automaticallyAdjustsScrollViewInsets];
}

-(void)viewDidAppear:(BOOL)animated{
    self.sideMenuController.leftViewSwipeGestureEnabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)getFeeds{
    RLMResults<RLMStoredObjects*> *objs= [RLMStoredObjects allObjects];
    if([objs count]){
        _storedObjetctFeeds = objs.firstObject;
    }
    else{
        _storedObjetctFeeds.objectID= @"0";
        [_realm beginWriteTransaction];
        [_realm addObject:_storedObjetctFeeds];
        [_realm commitWriteTransaction];
    }
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.boxofficemojo.com/data/rss.php?file=topstories.xml"]];
    [RSSParser parseRSSFeedForRequest:req success:^(NSArray *feedItems) {
        _allFeeds=[[NSMutableArray alloc] init];
        [_realm beginWriteTransaction];
        [_realm deleteObjects:[RLMFeeds allObjects]];
        
        for (RSSItem *item in feedItems) {
            _singleFeed = [[RLMFeeds alloc]initWithRSSItem:item];
            if([_singleFeed.desc length]>15){
                [_allFeeds addObject:_singleFeed];
                [_realm addObject:_singleFeed];
            }
        }
        [_realm commitWriteTransaction];

        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"ERROR while loading feeds: %@", error);
    }];
}
-(void)getStoredFeeds{
    _allFeeds=[[NSMutableArray alloc] init];
    for(RLMFeeds *oneFeed in [RLMFeeds allObjects]){
        [_allFeeds addObject:oneFeed];
    }
    [self.tableView reloadData];
}

-(void)setupSearchbar{
    if(!_isNavBarSet){
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        UIBarButtonItem *pieItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"PieIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(pushSideBar:)];
        self.navigationItem.leftBarButtonItem=pieItem;
        self.navigationItem.leftBarButtonItem.tintColor=[UIColor lightGrayColor];
        UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-150, 27)];
        [iv setBackgroundColor:[UIColor clearColor]];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, iv.frame.size.width, 27)];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.font=[UIFont systemFontOfSize:18];
        titleLabel.text=@"News feeds";
        titleLabel.textColor=[UIColor whiteColor];
        [iv addSubview:titleLabel];
        self.navigationItem.titleView = iv;
        _isNavBarSet=YES;
    }
}

-(IBAction)pushSideBar:(id)sender{
    [self.sideMenuController showLeftViewAnimated:YES completionHandler:nil];
//        [self testNotification];
//        [PushOnFirebase pushMoviesOnFirebase];
}

-(void)testNotification{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:10];
    localNotification.repeatInterval = NSCalendarUnitWeekOfYear;
    localNotification.soundName = @"sub.caf";
    localNotification.alertBody = @"Come out and check out upcoming movies";
    localNotification.timeZone = [NSTimeZone systemTimeZone];
    localNotification.alertTitle = @"Upcoming Movies";
    localNotification.alertAction = @"Details";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1;
    localNotification.category = @"reminderCategory";
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
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
