//
//  EpisodeDetailsViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 11/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "EpisodeDetailsViewController.h"
#import "PictureDetailCell.h"
#import "CastCollectionCell.h"
#import "EpisodeDetailsCell.h"
#import "EpisodeOverviewCell.h"
#import "ActorDetailsViewController.h"
#import <RestKit/RestKit.h>
#import "TrailerVideos.h"
#import "TrailerViewController.h"
#import "AboveImageCell.h"

@interface EpisodeDetailsViewController ()

@property CGFloat aboveEpisodePosterHeight;
@property CGFloat episodePosterHeight;
@property CGFloat episodeOverviewHeight;
@property CGFloat episodeDetailsHeight;
@property CGFloat episodeCastHeight;
@property CGFloat noHeight;

@end

@implementation EpisodeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    [self setNavBarTitle];
    // Do any additional setup after loading the view.
    [self.tableView registerNib:[UINib nibWithNibName:@"AboveImageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:aboveImageCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"PictureDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:pictureDetailCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"CastCollectionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:castCollectionCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"EpisodeDetailsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:episodeDetailsCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"EpisodeOverviewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:episodeOverviewCellIdentifier];
    [self setupSizes];
    [self getTrailers];
}

-(void)setupSizes{
    _aboveEpisodePosterHeight=60.0;
    _episodePosterHeight=230.0;
    _episodeDetailsHeight=85.0;
    _episodeOverviewHeight=85.0;
    _episodeCastHeight=330.0;
    _noHeight=0.00001;
}

-(void)setNavBarTitle{
    self.navigationItem.title =_showName;
}

-(void)getTrailers{
    
    NSString *pathP=[NSString stringWithFormat:@"%@%@%@%@%@%@%@",@"/3/tv/",_singleEpisode.showID,@"/season/",_singleEpisode.seasonNumber,@"/episode/",_singleEpisode.episodeNumber,@"/videos"];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                      };
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _singleEpisode.trailers=[[NSMutableArray alloc]initWithArray:mappingResult.array];
        [_tableView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _singleEpisode != nil ? 5 : 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            AboveImageCell *cell = (AboveImageCell*)[tableView dequeueReusableCellWithIdentifier:aboveImageCellIdentifier forIndexPath:indexPath];
            [cell setupTitleWithString:[NSString stringWithFormat:@"Season %@   Episode %@",_singleEpisode.seasonNumber,_singleEpisode.episodeNumber]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
        case 1:{
            PictureDetailCell *cell = (PictureDetailCell*)[tableView dequeueReusableCellWithIdentifier:pictureDetailCellIdentifier forIndexPath:indexPath];
            [cell setupWithEpisode:_singleEpisode];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
        case 2:{
            EpisodeDetailsCell *cell =(EpisodeDetailsCell*)[tableView dequeueReusableCellWithIdentifier:episodeDetailsCellIdentifier forIndexPath:indexPath];
            [cell setEpisodeDetails:_singleEpisode];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
        case 3:{
            EpisodeOverviewCell *cell = (EpisodeOverviewCell*)[tableView dequeueReusableCellWithIdentifier:episodeOverviewCellIdentifier forIndexPath:indexPath];
            [cell setupOverviewWithText:_singleEpisode.overview];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
        case 4:{
            CastCollectionCell *cell = (CastCollectionCell*)[tableView dequeueReusableCellWithIdentifier:castCollectionCellIdentifier forIndexPath:indexPath];
            [cell setupWithEpisode:_singleEpisode];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.delegate=self;
            return cell;
        }
            break;
        default:
            break;
    }
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return _aboveEpisodePosterHeight;
            break;
        case 1:
            return _episodePosterHeight;
            break;
        case 2:
            return _episodeDetailsHeight;
            break;
        case 3:
            return _episodeOverviewHeight;
            break;
        case 4:
            return _episodeCastHeight;
            break;
        default: return _noHeight;
            break;
    }
    
}

-(NSString*)stringForSection:(long)section{
    switch (section) {
        case 0:
            return @"";
            break;
        case 1:
            return @"Trailer";
            break;
        case 2:
            return @"";
            break;
        case 3:
            return @"";
            break;
        case 4:
            return @"Cast";
            break;
        default: return @"";
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section==0 || section==1 || section == 4){
        return 0.0001;
    }
    else
        return 10.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return 0.0001;
        }
        case 1:{
            return 30.0;
        }
            break;
        case 2:{
            return 5.0;
        }
            break;
        case 3:{
            return 5.0;
        }
            break;
        case 4:{
            return 30.0;
        }
            break;
        default:return 30.0;
            break;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section!=0 || section!=2 ){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
        if(section==3 || section==4){
            UIView * lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 0,tableView.frame.size.width,1)];
            lineview.layer.borderColor = [UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0].CGColor;
            lineview.layer.borderWidth = 0.5;
            [view addSubview:lineview];
        }
        UILabel *label;
        if(section!=1){
            label= [[UILabel alloc] initWithFrame:CGRectMake(10, 10, tableView.frame.size.width/2, 18)];
            [label setFont:[UIFont boldSystemFontOfSize:14]];
        }
        else{
            label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width/2, 18)];
            [label setFont:[UIFont systemFontOfSize:17]];
        }
        NSString *string =[self stringForSection:section];
        [label setText:string];
        [view addSubview:label];
        [label setTextColor:[UIColor whiteColor]];
        [view setBackgroundColor:[UIColor blackColor]]; //your background color...
        return view;
    }
    else
        return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_singleEpisode.trailers.firstObject)
        if(indexPath.section==1 && indexPath.row == 0){
            NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TrailerViewController *trailer = [storyboard instantiateViewControllerWithIdentifier:@"TrailerView"];
            trailer.episodeTrailer=_singleEpisode.trailers.firstObject;
            trailer.isEpisode=YES;
            trailer.episodeOverview=_singleEpisode.overview;
            [viewControllers addObject:trailer];
            [[self navigationController] setViewControllers:viewControllers animated:YES];
        }
}

- (void)openActorWithID:(NSNumber *)actorID{
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActorDetailsViewController *actorDetails = [storyboard instantiateViewControllerWithIdentifier:@"ActorDetails"];
    actorDetails.actorID = actorID;
    
    [viewControllers removeLastObject];
    [viewControllers addObject:actorDetails];
    [[self navigationController] setViewControllers:viewControllers animated:YES];
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
