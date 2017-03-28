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
#import "ApiKey.h"
#import <Realm/Realm.h>
#import "ConnectivityTest.h"
#import "RLTVShow.h"
#import "RLMSeason.h"
#import "RLMEpisode.h"
#import <Reachability/Reachability.h>

@interface SeasonsViewController ()

@property NSMutableArray<Episode *> *allEpisodes;
@property Season *currentSeason;
@property Episode *singleEpisode;
@property NSNumberFormatter *formatter;
@property NSIndexPath *selectedSeason;
@property BOOL firstTime;
@property BOOL isConnected;
@property RLMRealm *realm;
@property Reachability *reachability;
@property BOOL haveData;
@property BOOL notifRec;
@property UIView *dropDown;
@property UIButton *showList;

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
    [self CreateDropDownList];
    _isConnected = [ConnectivityTest isConnected];
    _realm = [RLMRealm defaultRealm];
    _notifRec=NO;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SeasonControllCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:seasonControllCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SingleSeasonCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:singleSeasonCellIdentifier];
    _allEpisodes =[[NSMutableArray alloc]init];
    _firstTime=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
}

- (void)reachabilityDidChange:(NSNotification *)notification {
    
    _reachability = (Reachability *)[notification object];
    if(!_notifRec){
    if ([_reachability isReachable]) {
        NSLog(@"Reachable");
        _isConnected=[ConnectivityTest isConnected];
        if(!_haveData)
            [self getAllEpisodes];
        if([_dropDown alpha]==1.0){
            [_dropDown setAlpha:0.0];
        }
    } else {
        NSLog(@"Unreachable");
        _isConnected=[ConnectivityTest isConnected];
    }
        _notifRec=YES;
    }
    else{
        _notifRec=NO;
    }
        
}

-(void)setButtonTitle{
    NSMutableAttributedString *text =
    [[NSMutableAttributedString alloc]
     initWithString:[NSString stringWithFormat:@"Please Reconnect to proceed!"]];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor whiteColor]
                 range:NSMakeRange(0, 7)];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0]
                 range:NSMakeRange(7, 10)];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor whiteColor]
                 range:NSMakeRange(17, 11)];
    [_showList setAttributedTitle:text forState:UIControlStateNormal];
}

-(void)CreateDropDownList{
    CGRect dropDownFrame =CGRectMake(0, [[UIScreen mainScreen] bounds].size.height*3/5, [[UIScreen mainScreen] bounds].size.width, 64);
    _dropDown = [[UIView alloc ]initWithFrame:dropDownFrame];
    [_dropDown setBackgroundColor:[UIColor clearColor]];
    CGRect buttonFrame = CGRectMake(0, 0, [_dropDown bounds].size.width, [_dropDown bounds].size.height-1);
    _showList = [[UIButton alloc]init];
    _showList.frame = buttonFrame;
    [_showList setBackgroundColor:[UIColor clearColor]];
    _showList.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _showList.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self setButtonTitle];
    [_showList addTarget:self action:@selector(openWifiSettings:) forControlEvents:UIControlEventTouchUpInside];
    
    [_dropDown addSubview:_showList];
    [self.view addSubview:_dropDown];
    [_dropDown setAlpha:0.0];
}

- (IBAction)openWifiSettings:(id)sender{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"prefs:root=WIFI"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=WIFI"]];
    }
}


-(void)setNavBarTitle{
    self.navigationItem.title = _singleShow.name;
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor lightGrayColor]];
}

-(void)setFormater{
    _formatter = [[NSNumberFormatter alloc] init];
    
    [_formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [_formatter setMaximumFractionDigits:1];
    [_formatter setRoundingMode: NSNumberFormatterRoundUp];
}

-(void)getAllEpisodes{
    NSString *pathP=[NSString stringWithFormat:@"%@%@%@%@",@"/3/tv/",_singleShow.showID,@"/season/",_seasonID];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": [ApiKey getApiKey]/*add your api*/
                                      };
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _allEpisodes = [NSMutableArray arrayWithArray:mappingResult.array];
        [self setupShowID];
        [self setupSeasonYear];
        [self setStoredEpisodes];
        [self.tableView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
}
-(void)setupShowID{
    for (Episode *ep in _allEpisodes) {
        ep.rating=[_formatter numberFromString:[_formatter stringFromNumber:ep.rating]];
        ep.showID=_singleShow.showID;
    }
}

-(void)setupSeasonView{
    [self setFormater];
    _isConnected = [ConnectivityTest isConnected];
    if(_isConnected)
        [self getAllEpisodes];
    else
        [self getStoredEpisodes];
    _currentSeason=_seasons.firstObject;
}

-(void)getStoredEpisodes{
    RLMResults<RLTVShow*> *tvs = [RLTVShow objectsWhere:@"showID = %@",_singleShow.showID];
    RLTVShow *tv = tvs.firstObject;
    _seasons = [[NSMutableArray alloc]init];
    for(RLMSeason *s in tv.seasons)
        [_seasons addObject:[[Season alloc]initWithSeason:s]];
    if(tv.seasons.firstObject!= nil){
        _allEpisodes = [[NSMutableArray alloc]init];
        RLMSeason *selectedSeason;
        if(_selectedSeason != nil){
         selectedSeason= [tv.seasons objectAtIndex:_selectedSeason.row];
        }
        else{
        selectedSeason= [tv.seasons objectAtIndex:1];
        }
        if(selectedSeason.seasonID!=nil){
            for(RLMEpisode *ep in selectedSeason.episodes)
                [_allEpisodes addObject:[[Episode alloc]initWithEpisode:ep]];
            _haveData=YES;
            [self setupShowID];
            [self setupSeasonYear];
            [_dropDown setAlpha:0.0];
            [self.tableView reloadData];
        }
        else{
            if([_seasons count]){
                RLMSeason *selectedSeason = [[RLMSeason alloc] initWithSeason:[_seasons objectAtIndex:_selectedSeason.row]];
                if(selectedSeason.episodes.firstObject!=nil){
                    for(RLMEpisode *ep in selectedSeason.episodes)
                        [_allEpisodes addObject:[[Episode alloc]initWithEpisode:ep]];
                    _haveData=YES;
                    [self setupShowID];
                    [self setupSeasonYear];
                    [_dropDown setAlpha:0.0];
                    [self.tableView reloadData];
                }
                else{
                    _haveData = NO;
                    [_dropDown setAlpha:1.0];
                }
            }
        }
    }
    else{
        _haveData=NO;
        [_dropDown setAlpha:1.0];
    }
    if([_allEpisodes count]){
        [_dropDown setAlpha:0.0];
    }
    else{
        [_dropDown setAlpha:1.0];
    }
    
}

-(void)setStoredEpisodes{
    RLMResults<RLTVShow*> *tvs = [RLTVShow objectsWhere:@"showID = %@",_singleShow.showID];
    RLTVShow *tv = tvs.firstObject;
    [_realm beginWriteTransaction];
    if([tv.seasons count]){
        RLMSeason *selectedSeason = [tv.seasons objectAtIndex:_selectedSeason.row];
        if(selectedSeason!=nil){
            if((selectedSeason.episodes.firstObject.episodeName != _allEpisodes.firstObject.episodeName)&& ([selectedSeason.episodes count] != [_allEpisodes count])){
            for(Episode *ep in _allEpisodes)
                [selectedSeason.episodes addObject:[[RLMEpisode alloc] initWithEpisode:ep]];
            [tv.seasons replaceObjectAtIndex:_selectedSeason.row  withObject:selectedSeason];
            }
        }
        else{
            if([_seasons count]){
                RLMSeason *selectedSeason = [[RLMSeason alloc] initWithSeason:[_seasons objectAtIndex:_selectedSeason.row]];
                if(selectedSeason.episodes.firstObject==nil){
                    
                    for(Episode *ep in _allEpisodes)
                        [selectedSeason.episodes addObject:[[RLMEpisode alloc] initWithEpisode:ep]];
                    [tv.seasons addObject:selectedSeason];
                }
            }
        }
    }
    [_realm addOrUpdateObject:tv];
    [_realm commitWriteTransaction];
}

-(void)setupSeasonYear{
    NSDate *releaseYear = [_currentSeason airDate];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:releaseYear];
    NSInteger year = [components year];
    if(_currentSeason!=0)
        _seasonYear.text =[NSString stringWithFormat:@"%ld",(long)year];
    else
        _seasonYear.text = [NSString stringWithFormat:@"Credits"];
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
    if(indexPath.row==1 && _firstTime){
        [cell.seasonNumber setTextColor:[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0]];
        _selectedSeason=indexPath;
        _firstTime=NO;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath !=_selectedSeason){
        SeasonControllCell *previusCell = (SeasonControllCell *)[_collectionView cellForItemAtIndexPath:_selectedSeason];
        SeasonControllCell *cell = (SeasonControllCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        
        [previusCell setupWhiteColor];
        [cell setupYellowColor];
        
        _selectedSeason=indexPath;
    }
    _seasonID = [NSNumber numberWithLong:indexPath.row];
    _currentSeason=[_seasons objectAtIndex:indexPath.row];
    
    [self setupSeasonYear];
    if(_isConnected)
        [self getAllEpisodes];
    else
        [self getStoredEpisodes];
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
