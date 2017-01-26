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
    
    RKObjectMapping *feedMapping = [RKObjectMapping mappingForClass:[Feeds class]];
    [feedMapping addAttributeMappingsFromDictionary:@{@"title": @"title",
                                                      @"description": @"desc",
                                                      @"link": @"link"
                                                      }];
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:feedMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/data/rss.php"
                                                keyPath:@"rss.channel.item"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    feedMapping.assignsDefaultValueForMissingAttributes=YES;
    
    [RKObjectManager boxOfficeManager].requestSerializationMIMEType =RKMIMETypeFormURLEncoded;
    [[RKObjectManager boxOfficeManager] setAcceptHeaderWithMIMEType:@"application/rss+xml"];
   
        [RKMIMETypeSerialization registerClass:[RKURLEncodedSerialization class] forMIMEType:@"application/rss+xml"];
    
        [[RKObjectManager boxOfficeManager] addResponseDescriptor:responseDescriptor];
    
    NSDictionary *queryParameters = @{
                                      @"file": @"topstories.xml"/*add your api*/
                                      };
    
    [[RKObjectManager boxOfficeManager] getObjectsAtPath:@"/data/rss.php" parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _allFeeds=[[NSMutableArray alloc]initWithArray:mappingResult.array];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedsCell *cell = (FeedsCell *)[tableView dequeueReusableCellWithIdentifier:feedIdentifier forIndexPath:indexPath];
    _singleFeed = [_allFeeds objectAtIndex:indexPath.row];
    [cell setupFeedCell:_singleFeed];
    // Configure the cell...
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_allFeeds count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


@end
