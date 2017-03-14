//
//  OverviewTableViewCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 26/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "OverviewCell.h"
#import <RestKit/RestKit.h>
#import "Crew.h"
#import "RatingViewController.h"

NSString * const OverviewCellIdentifier=@"overviewCellIdentifier";

@implementation OverviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setHidenButtons{
    _isLoged=[[NSUserDefaults standardUserDefaults] boolForKey:@"isLoged"];
    if(!_isLoged){
        [_rateButton setHidden:YES];
        [_lineSeparator setHidden:YES];
    }
    else{
        _userCredits=[[NSUserDefaults standardUserDefaults] objectForKey:@"SessionCredentials"];
        [_rateButton addTarget:self action:@selector(rateMedia:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)setupUser{
    _userCredits = [[NSUserDefaults standardUserDefaults] objectForKey:@"SessionCredentials"];
    RLMResults<RLUserInfo*> *users= [RLUserInfo objectsWhere:@"userID = %@", [_userCredits objectForKey:@"userID"]];
    if([users count]){
        _user = [users firstObject];
    }
}

-(IBAction)rateMedia:(id)sender{
    [self.delegate rateMedia];
}

-(void) setupWithMovie :(Movie*) singleMovie{
    [self setHidenButtons];
    _setupMovie=singleMovie;
    [self setupOverview];
    
}

-(void)setupOverview{
    [self setupUser];
    if([[[_user ratedMovies] valueForKey:@"movieID"] containsObject:_setupMovie.movieID]){
        [_rateButton setImage:[UIImage imageNamed:@"YellowRatingsButton"] forState:UIControlStateNormal];
    }
    
    _rating.text = [NSString stringWithFormat:@"%@",_setupMovie.rating];
    _overview.text = _setupMovie.overview;
}

-(void) setupWithShow :(TVShow*) singleShow{
    [self setHidenButtons];
    _setupShow=singleShow;
    [self setupShowOverview];
}

-(void)setupShowOverview{
    [self setupUser];
    if([[[_user ratedShows] valueForKey:@"showID"] containsObject:_setupShow.showID]){
        [_rateButton setImage:[UIImage imageNamed:@"YellowRatingsButton"] forState:UIControlStateNormal];
    }
    
    _rating.text = [NSString stringWithFormat:@"%@",_setupShow.rating];
    _overview.text = _setupShow.overview;
    
}

@end
