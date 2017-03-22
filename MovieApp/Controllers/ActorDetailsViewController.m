//
//  ActorDetailsViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 08/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "ActorDetailsViewController.h"
#import <RestKit/RestKit.h>
#import "PictureDetailCell.h"
#import "AboutCell.h"
#import "FilmographyCell.h"
#import "OverviewdLineCell.h"
#import "MovieDetailViewController.h"
#import "Movie.h"
#import "TVShow.h"
#import "ApiKey.h"
#import "ConnectivityTest.h"
#import "RLMActor.h"
#import <Realm/Realm.h>

@interface ActorDetailsViewController ()

@property Actor *singleActor;

@property CGFloat actorPosterHeight;
@property CGFloat actorOverviewHeight;
@property CGFloat actorBirthHeight;
@property CGFloat actorLinkHeight;
@property CGFloat actorFilmographyHeight;
@property CGFloat noHeight;

@property CGFloat openedActorOverviewHeight;
@property NSMutableArray<NSNumber*> *cellOverviewHeights;
@property NSIndexPath *actorIndexPath;
@property BOOL isOpened;
@property int count;

@property BOOL hasBirth;
@property BOOL hasLink;

@property BOOL isConnected;
@property RLMRealm *realm;

@end

@implementation ActorDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    // Do any additional setup after loading the view.
    [self setupCells];
    [self setSizes];
    _isConnected = [ConnectivityTest isConnected];
    _realm = [RLMRealm defaultRealm];
    if(_isConnected)
        [self searchForActor];
    else
        [self getStoredActor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupCells{
    [self.tableView registerNib:[UINib nibWithNibName:@"PictureDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:pictureDetailCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"AboutCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:aboutCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"FilmographyCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:filmographyCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"OverviewdLineCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:overviewLineCellIdentifier];
}

-(void)setSizes{
    _actorPosterHeight = 250.0;
    _actorOverviewHeight = 245.0;
    _actorFilmographyHeight = 305.0;
    _actorLinkHeight=20.0;
    _actorBirthHeight=20.0;
    _noHeight=0.0;
    _isOpened=NO;
    _openedActorOverviewHeight=360.0;
    _hasBirth=NO;
    _hasLink=NO;
}

-(void)setNavBarTitle{
    self.navigationItem.title = _singleActor.name;
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor lightGrayColor]];
}

-(void)getStoredActor{
    RLMResults<RLMActor*> *acts = [RLMActor objectsWhere:@"actorID = %@",_singleActor.actorID];
    RLMActor *act = acts.firstObject;
    if(act.actorID != nil){
        _singleActor = [[Actor alloc]initWithActor:act];
    }
    else{
        //connect to proceed
    }
}

-(void)setStoredActor{
    RLMResults<RLMActor*> *acts = [RLMActor objectsWhere:@"actorID = %@",_singleActor.actorID];
    RLMActor *act = acts.firstObject;
    if(act.actorID == nil){
        act = [[RLMActor alloc] initWithActor:_singleActor];
    }
    [_realm beginWriteTransaction];
    [_realm addOrUpdateObject:act];
    [_realm commitWriteTransaction];
}

-(void)searchForActor{
    
    NSString *pathP = [NSString stringWithFormat:@"/3/person/%@",_actorID];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": [ApiKey getApiKey]/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _singleActor=mappingResult.array.firstObject;
        [self setStoredActor];
        [self setNavBarTitle];
        [self setOverviewLineHeights];
        [self.tableView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
    
    
}

-(void)setOverviewLineHeights{
    _cellOverviewHeights = [[NSMutableArray alloc]init];
    if(_singleActor.birthDate!= nil || _singleActor.birthPlace!=nil || ![_singleActor.birthPlace isEqualToString:@""]){
        CGFloat afterHeight=[self heightForView:[NSString stringWithFormat:@"%@%@",_singleActor.birthPlace,_singleActor.birthDate] :[UIFont systemFontOfSize:15.0] :[UIScreen mainScreen].bounds.size.width-104];
        [_cellOverviewHeights addObject:[NSNumber numberWithFloat:afterHeight+3]];
    }
    if(_singleActor.homePage!= nil || ![_singleActor.homePage isEqualToString:@""]){
        CGFloat afterHeight=[self heightForView:[NSString stringWithFormat:@"%@",_singleActor.homePage] :[UIFont systemFontOfSize:15.0] :[UIScreen mainScreen].bounds.size.width-104];
        [_cellOverviewHeights addObject:[NSNumber numberWithFloat:afterHeight+6]];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _singleActor != nil ? 3 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:{
            int count = 1;
            if(_singleActor.homePage !=nil || ![_singleActor.homePage isEqualToString:@""]){
                count++;
                _hasLink=YES;
            }
            if(_singleActor.birthDate !=nil || _singleActor.birthPlace != nil || ![_singleActor.birthPlace isEqualToString:@""]){
                count++;
                _hasBirth=YES;
            }
            _count=count;
            return count;
        }
            break;
        case 2:
            return 1;
            break;
        default: return 0;
            break;
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return nil;
            break;
        case 1:
            return @"";
            break;
        case 2:
            return @"Filmography";
            break;
        default: return @"";
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section !=2){
        return 20;
    }
    else
        return 0.0001;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    if(section==2){
        UIView * lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 0,tableView.frame.size.width,1)];
        lineview.layer.borderColor = [UIColor lightGrayColor].CGColor;
        lineview.layer.borderWidth = 0.5;
        [view addSubview:lineview];
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, tableView.frame.size.width/2, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    NSString *string =[self stringForSection:section];
    [label setText:string];
    [view addSubview:label];
    [label setTextColor:[UIColor whiteColor]];
    [view setBackgroundColor:[UIColor blackColor]]; //your background color...
    return view;
}

-(NSString*)stringForSection:(long)section{
    switch (section) {
        case 0:
            return nil;
            break;
        case 1:
            return @"";
            break;
        case 2:
            return @"Filmography";
            break;
        default: return @"";
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:{
            PictureDetailCell *cell = (PictureDetailCell *)[tableView dequeueReusableCellWithIdentifier:pictureDetailCellIdentifier forIndexPath:indexPath];
            [cell setupWithActor:_singleActor];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
        case 1:{
            if(indexPath.row==0 && _count>1){
                if(_hasBirth){
                    return [self setupOverviewBirthForTableView:tableView :indexPath];
                }
                else if (_hasLink){
                    return [self setupOverviewLinkForTableView:tableView :indexPath];
                }
            }
            else if (indexPath.row ==1 && _count>2){
                if (_hasLink){
                    return [self setupOverviewLinkForTableView:tableView :indexPath];
                }
            }
            else{
                AboutCell *cell = (AboutCell *)[tableView dequeueReusableCellWithIdentifier:aboutCellIdentifier forIndexPath:indexPath];
                [cell setupWithActor:_singleActor];
                cell.delegate = self;
                _actorIndexPath=indexPath;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                if(_isOpened){
                    [cell.fullBioButton setTitle:@"Read less" forState:UIControlStateNormal];
                }
                else{
                    [cell.fullBioButton setTitle:@"Read full bio" forState:UIControlStateNormal];
                }
                return cell;
            }
        }
            break;
        case 2:{
            FilmographyCell *cell = (FilmographyCell *)[tableView dequeueReusableCellWithIdentifier:filmographyCellIdentifier forIndexPath:indexPath];
            [cell setupWithActor:_singleActor];
            cell.delegate=self;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
        default:
            break;
    }
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    // Configure the cell...
    
    return cell;
}

-(OverviewLineCell *)setupOverviewLinkForTableView:(UITableView*)tableView :(NSIndexPath*)indexPath{
    OverviewLineCell *cell = (OverviewLineCell *)[tableView dequeueReusableCellWithIdentifier:overviewLineCellIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setupActorLink:_singleActor.homePage];
    CGFloat afterHeight=[self heightForView:_singleActor.homePage :[UIFont systemFontOfSize:15.0] :cell.contentLabel.frame.size.width];
    [_cellOverviewHeights addObject:[NSNumber numberWithFloat:afterHeight]];
    return cell;
}

-(OverviewLineCell *)setupOverviewBirthForTableView:(UITableView*)tableView :(NSIndexPath*)indexPath{
    OverviewLineCell *cell = (OverviewLineCell *)[tableView dequeueReusableCellWithIdentifier:overviewLineCellIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setupActorBirth:_singleActor.birthDate :_singleActor.birthPlace];
    CGFloat afterHeight=[self heightForView:[NSString stringWithFormat:@"%@%@",_singleActor.birthDate,_singleActor.birthPlace] :[UIFont systemFontOfSize:15.0] :cell.contentLabel.frame.size.width];
    [_cellOverviewHeights addObject:[NSNumber numberWithFloat:afterHeight]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0 && indexPath.row==0){
        return _actorPosterHeight;
    }
    else if(indexPath.section==1){
        if (_count>1){
            if(indexPath.row==_count-1)
                return _openedActorOverviewHeight;
            else{
                if(indexPath.row==0)
                    return [[_cellOverviewHeights objectAtIndex:0]floatValue]+4;
                else
                    return [[_cellOverviewHeights objectAtIndex:indexPath.row] floatValue];
            }
        }
        else return _openedActorOverviewHeight;
    }
    else if(indexPath.section==2 && indexPath.row==0){
        return _actorFilmographyHeight;
    }
    else
        return _noHeight;
}

-(void)colideColapse{
    AboutCell *cell = (AboutCell*)[_tableView cellForRowAtIndexPath:_actorIndexPath];
    CGFloat beforeHeight = cell.fullBiography.bounds.size.height;
    CGFloat OverviewHeight=[self heightForView:[_singleActor biography] :[UIFont systemFontOfSize:15.0] :cell.fullBiography.frame.size.width];
    NSArray* rowsToReload = [NSArray arrayWithObjects:_actorIndexPath, nil];
    if(!_isOpened){
        _openedActorOverviewHeight=_actorOverviewHeight + (OverviewHeight - beforeHeight);
        if(_openedActorOverviewHeight<_actorOverviewHeight)
            _openedActorOverviewHeight=_actorOverviewHeight;
        _isOpened=YES;
        
    }
    else{
        _openedActorOverviewHeight=_actorOverviewHeight;
        _isOpened=NO;
    }
    
    [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    [self tableView:_tableView heightForRowAtIndexPath:[indexPaths objectAtIndex:0]];
}

-(CGFloat)heightForView :(NSString*)text :(UIFont *)font : (CGFloat)width{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, CGFLOAT_MAX)];
    [label setNumberOfLines:0];
    [label setLineBreakMode: NSLineBreakByWordWrapping];
    [label setFont:font];
    [label setText:text];
    [label sizeToFit];
    return  label.frame.size.height;
}

- (void)MediaWithCast:(Cast *)castForMedia{
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MovieDetailViewController *movieDetails= [storyboard instantiateViewControllerWithIdentifier:@"MovieDetails"];
    
    if([castForMedia.mediaType isEqualToString:@"movie"]){
        Movie *movie = [[Movie alloc]init];
        movie.movieID = castForMedia.castWithID;
        movie.title=castForMedia.castMovieTitle;
        movie.posterPath=castForMedia.castImagePath;
        movie.releaseDate=castForMedia.releaseDate;
        movieDetails.isMovie=YES;
        movieDetails.movieID=movie.movieID;
        movieDetails.singleMovie=movie;
    }
    else if([castForMedia.mediaType isEqualToString:@"tv"])
    {
        TVShow *show = [[TVShow alloc]init];
        show.showID = castForMedia.castWithID;
        show.name = castForMedia.castMovieTitle;
        show.posterPath = castForMedia.castImagePath;
        show.airDate = castForMedia.releaseDate;
        movieDetails.isMovie=NO;
        movieDetails.movieID = show.showID;
        movieDetails.singleShow=show;
    }
    
    [viewControllers removeLastObject];
    [viewControllers removeLastObject];
    [viewControllers addObject:movieDetails];
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
