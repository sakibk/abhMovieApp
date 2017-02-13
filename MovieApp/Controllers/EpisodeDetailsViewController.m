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

@interface EpisodeDetailsViewController ()

@end

@implementation EpisodeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    // Do any additional setup after loading the view.
    [self.tableView registerNib:[UINib nibWithNibName:@"PictureDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:pictureDetailCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"CastCollectionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:castCollectionCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"EpisodeDetailsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:episodeDetailsCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"EpisodeOverviewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:episodeOverviewCellIdentifier];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _singleEpisode != nil ? 4 : 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            PictureDetailCell *cell = (PictureDetailCell*)[tableView dequeueReusableCellWithIdentifier:pictureDetailCellIdentifier forIndexPath:indexPath];
            [cell setupWithEpisode:_singleEpisode];
            return cell;
        }
            break;
        case 1:{
            EpisodeDetailsCell *cell =(EpisodeDetailsCell*)[tableView dequeueReusableCellWithIdentifier:episodeDetailsCellIdentifier forIndexPath:indexPath];
            [cell setEpisodeDetails:_singleEpisode];
            return cell;
        }
            break;
        case 2:{
            EpisodeOverviewCell *cell = (EpisodeOverviewCell*)[tableView dequeueReusableCellWithIdentifier:episodeOverviewCellIdentifier forIndexPath:indexPath];
            [cell setupOverviewWithText:_singleEpisode.overview];
            return cell;
        }
            break;
        case 3:{
            CastCollectionCell *cell = (CastCollectionCell*)[tableView dequeueReusableCellWithIdentifier:castCollectionCellIdentifier forIndexPath:indexPath];
            [cell setupWithEpisode:_singleEpisode];
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
    if (indexPath.row == 0) {
        return 222.0;
    }
    else if (indexPath.row == 1){
        return 114.0;
    }
    else if (indexPath.row == 2){
        return 100.0;
    }
    else if (indexPath.row == 3){
        return 293.0;
    }
    return 200.0;
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
