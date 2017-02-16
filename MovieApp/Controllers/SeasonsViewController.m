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
#import "EpisodeDetailsViewController.h"

@interface SeasonsViewController ()

@property NSMutableArray<Episode *> *allEpisodes;
@property Season *currentSeason;
@property Episode *singleEpisode;

@end

@implementation SeasonsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _tableView.delegate =self;
    _tableView.dataSource=self;
    [self setNavBarTitle];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SeasonControllCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:seasonControllCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SingleSeasonCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:singleSeasonCellIdentifier];
    _allEpisodes =[[NSMutableArray alloc]init];
    
}

-(void)setNavBarTitle{
    self.navigationItem.title = _singleShow.name;
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor lightGrayColor]];
}

-(void)setRestkit{
//    NSString *pathP=[NSString stringWithFormat:@"%@%@%@%@",@"/3/tv/",_singleShow.showID,@"/season/",_seasonID];
    
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
                                                pathPattern:nil
                                                keyPath:@"episodes"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:episodeResponseDescriptor];
}

-(void)getAllEpisodes{
    NSString *pathP=[NSString stringWithFormat:@"%@%@%@%@",@"/3/tv/",_singleShow.showID,@"/season/",_seasonID];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                      };
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _allEpisodes = [NSMutableArray arrayWithArray:mappingResult.array];
        [self setupShowID];
        [self.tableView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
}
-(void)setupShowID{
    for (Episode *ep in _allEpisodes) {
        ep.showID=_singleShow.showID;
    }
}

-(void)setupSeasonView{
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
    CGFloat tableViewCellHeight=60.0;
    return tableViewCellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SingleSeasonCell *cell = (SingleSeasonCell*)[tableView dequeueReusableCellWithIdentifier:singleSeasonCellIdentifier forIndexPath:indexPath];
    [cell setupWithEpisode:[_allEpisodes objectAtIndex:indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _singleEpisode=[_allEpisodes objectAtIndex:indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EpisodeDetailsViewController *episodeDetails = (EpisodeDetailsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"EpisodeDetails"];
    episodeDetails.singleEpisode=_singleEpisode;
    episodeDetails.showName=_singleShow.name;
    [self.navigationController pushViewController:episodeDetails animated:YES];
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
    _seasonID = [NSNumber numberWithLong:indexPath.row];
    [self getAllEpisodes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}


@end
