//
//  SeasonsViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 10/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "SeasonsViewController.h"
#import "Season.h"
#import "SingleSeasonCell.h"
#import "SeasonControllCell.h"
#import "Episode.h"
#import <RestKit/RestKit.h>

@interface SeasonsViewController ()

@property NSMutableArray<Episode *> *allEpisodes;
@property Season *currentSeason;

@end

@implementation SeasonsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView.delegate =self;
    _tableView.dataSource=self;
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SeasonControllCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:seasonControllCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SingleSeasonCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:singleSeasonCellIdentifier];
    _allEpisodes =[[NSMutableArray alloc]init];
    
}

-(void)setRestkit{
    NSString *pathP=[NSString stringWithFormat:@"%@%@%@%@",@"/3/tv/",_showID,@"/season/",_seasonID];
    
    RKObjectMapping *episodeMapping = [RKObjectMapping mappingForClass:[Episode class]];
    
    [episodeMapping addAttributeMappingsFromDictionary:@{@"air_date":@"airDate",
                                                         @"episode_number":@"episodeNumber",
                                                         @"still_path":@"episodePoster",
                                                         @"name":@"episodeName",
                                                         @"overview":@"overview",
                                                         @"season_number":@"seasonNumber",
                                                         @"vote_average":@"rating"
                                                         }];
    RKResponseDescriptor *episodeResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:episodeMapping
                                                 method:RKRequestMethodGET
                                                pathPattern:pathP
                                                keyPath:@"episodes"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:episodeResponseDescriptor];
}

-(void)getAllEpisodes{
    NSString *pathP=[NSString stringWithFormat:@"%@%@%@%@",@"/3/tv/",_showID,@"/season/",_seasonID];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                      };
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _allEpisodes = [NSMutableArray arrayWithArray:mappingResult.array];
        [self.tableView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
    }];
}

-(void)setupSeasonView{
    [self.collectionView reloadData];
    [self.tableView reloadData];
    [self setRestkit];
    [self getAllEpisodes];
    _currentSeason=_seasons.firstObject;
    [self setupSeasonYear];
}

-(void)setupSeasonYear{
    NSDate *releaseYear = [_currentSeason airDate];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:releaseYear];
    NSInteger year = [components year];
    _seasonYear.text =[NSString stringWithFormat:@"%ld",(long)year];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _allEpisodes !=nil ? [_allEpisodes count] : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SingleSeasonCell *cell = (SingleSeasonCell*)[tableView dequeueReusableCellWithIdentifier:singleSeasonCellIdentifier forIndexPath:indexPath];
    [cell setupWithEpisode:[_allEpisodes objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _seasonCount !=nil ? [_seasonCount intValue] : 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SeasonControllCell *cell = (SeasonControllCell *)[collectionView dequeueReusableCellWithReuseIdentifier:seasonControllCellIdentifier forIndexPath:indexPath];
    [cell sizeThatFits:CGSizeMake(30, 30)];
    [cell setupSeasonCellWithSeasonNumber:[[_seasons objectAtIndex:indexPath.row] seasonNumber]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _seasonID = [NSNumber numberWithLong:indexPath.row+1];
    [self getAllEpisodes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
