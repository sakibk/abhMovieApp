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

@interface EpisodeDetailsViewController ()

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
    [self.tableView registerNib:[UINib nibWithNibName:@"PictureDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:pictureDetailCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"CastCollectionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:castCollectionCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"EpisodeDetailsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:episodeDetailsCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"EpisodeOverviewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:episodeOverviewCellIdentifier];
    [self setupSizes];
}

-(void)setupSizes{
    _episodePosterHeight=220.0;
    _episodeDetailsHeight=85.0;
    _episodeOverviewHeight=85.0;
    _episodeCastHeight=305;
}

-(void)setNavBarTitle{
    self.navigationItem.title =_showName;
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor lightGrayColor]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _singleEpisode != nil ? 4 : 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            PictureDetailCell *cell = (PictureDetailCell*)[tableView dequeueReusableCellWithIdentifier:pictureDetailCellIdentifier forIndexPath:indexPath];
            [cell setupWithEpisode:_singleEpisode];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
        case 1:{
            EpisodeDetailsCell *cell =(EpisodeDetailsCell*)[tableView dequeueReusableCellWithIdentifier:episodeDetailsCellIdentifier forIndexPath:indexPath];
            [cell setEpisodeDetails:_singleEpisode];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
        case 2:{
            EpisodeOverviewCell *cell = (EpisodeOverviewCell*)[tableView dequeueReusableCellWithIdentifier:episodeOverviewCellIdentifier forIndexPath:indexPath];
            [cell setupOverviewWithText:_singleEpisode.overview];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
        case 3:{
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
            return _episodePosterHeight;
            break;
        case 1:
            return _episodeDetailsHeight;
            break;
        case 2:
            return _episodeOverviewHeight;
            break;
        case 3:
            return _episodeCastHeight;
            break;
        default: return _noHeight;
            break;
    }

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
            return @"";
            break;
        case 3:
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    if(section==2 || section==3){
        UIView * lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 0,tableView.frame.size.width,1)];
        lineview.layer.borderColor = [UIColor yellowColor].CGColor;
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
