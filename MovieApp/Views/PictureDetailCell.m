//
//  PictureDetailTableViewCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 26/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "PictureDetailCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TVShow.h"
#import "TrailerViewController.h"
#import <RestKit/RestKit.h>
#import "RLUserInfo.h"
#import "ConnectivityTest.h"

NSString* const pictureDetailCellIdentifier= @"pictureCellIdentifier";



@implementation PictureDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_watchButton addTarget:self action:@selector(addToWatchList:) forControlEvents:UIControlEventTouchUpInside];
    [_favouriteButton addTarget:self action:@selector(addToFavoriteList:) forControlEvents:UIControlEventTouchUpInside];
    _realm =[RLMRealm defaultRealm];
    [self.watchButton setImageEdgeInsets:UIEdgeInsetsMake(10, 13, 9, 5)];
    [self.favouriteButton setImageEdgeInsets:UIEdgeInsetsMake(8, 5, 9, 14)];
}

-(void)setHidenButtons{
    _isLoged=[[NSUserDefaults standardUserDefaults] boolForKey:@"isLoged"];
    if(!_isLoged){
        [_watchButton setHidden:YES];
        [_favouriteButton setHidden:YES];
    }
    else{
        _userCredits=[[NSUserDefaults standardUserDefaults] objectForKey:@"SessionCredentials"];
    }
}

-(IBAction)addToWatchList:(id)sender{
    
    [self.delegate addWatchlist];
}

-(IBAction)addToFavoriteList:(id)sender{
    
    [self.delegate addFavorite];
}

-(void) setupWithMovie:(Movie *) singleMovie{
    [self setHidenButtons];
    [self.poster sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://image.tmdb.org/t/p/w780/",singleMovie.backdropPath]]
                   placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",singleMovie.title,@".png"]]];
    
    NSDate *releaseYear = singleMovie.releaseDate;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:releaseYear];
    NSInteger year = [components year];
    _movieTitle.text = [NSString stringWithFormat:@"%@(%ld)",singleMovie.title,(long)year];
    _singleMovie=singleMovie;
    RLMResults<RLUserInfo*> *users= [RLUserInfo objectsWhere:@"userID = %@", [_userCredits objectForKey:@"userID"]];
    if([users count]){
        RLUserInfo *user =[users firstObject];
        if([[[user watchlistMovies] valueForKey:@"movieID"] containsObject:singleMovie.movieID]){
            [self watchIt];
        }
        else{
            [self unWatchIt];
        }
        
        if([[[user favoriteMovies] valueForKey:@"movieID"] containsObject:singleMovie.movieID]){
            [self favoureIt];
        }
        else{
            [self unFavoureIt];
        }
    }
    [self setCellGradient];
    
}

-(void) setupWithShow:(TVShow *) singleShow{
    [self setHidenButtons];
    [self.poster sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://image.tmdb.org/t/p/w780/",singleShow.backdropPath]]
                   placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",singleShow.name,@".png"]]];
    
    NSDate *releaseYear = singleShow.firstAirDate;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:releaseYear];
    NSInteger year = [components year];
    _movieTitle.text = [NSString stringWithFormat:@"%@(%ld)",singleShow.name,(long)year];
    [_playButton setHidden:YES];
    RLMResults<RLUserInfo*> *users= [RLUserInfo objectsWhere:@"userID = %@", [_userCredits objectForKey:@"userID"]];
    if([users count]){
        RLUserInfo *user =[users firstObject];
        if([[[user watchlistShows] valueForKey:@"showID"] containsObject:singleShow.showID]){
            [self watchIt];
        }
        else{
            [self unWatchIt];
        }
        if([[[user favoriteShows] valueForKey:@"showID"] containsObject:singleShow.showID]){
            [self favoureIt];
        }
        else{
            [self unFavoureIt];
        }
        
    }
    
    [self setCellGradient];
}

-(void) setupWithActor:(Actor *)singleActor{
    
    [self.poster sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://image.tmdb.org/t/p/w780/",singleActor.profilePath]]
                   placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",singleActor.name,@".png"]]];
    [_movieTitle setFont:[_movieTitle.font fontWithSize:27.0]];
    _movieTitle.text=singleActor.name;
    [_playButton setHidden:YES];
    [_favouriteButton setHidden:YES];
    [_watchButton setHidden:YES];
    [self setActorCellGradient];
}

-(void) setupWithEpisode:(Episode *) singleEpisode;{
    [self setHidenButtons];
    [self.poster sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://image.tmdb.org/t/p/w780/",singleEpisode.episodePoster]]
                   placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",singleEpisode.episodeName,@".png"]]];
    [_movieTitle setFont:[_movieTitle.font fontWithSize:27.0]];
    _movieTitle.text=@" ";
    if(singleEpisode.trailers.firstObject!=nil){
        [_playButton setHidden:NO];
    }
    else{
        [_playButton setHidden:YES];
    }
    [_favouriteButton setHidden:YES];
    [_watchButton setHidden:YES];
}

-(void)setCellGradient{
    if (![self.poster.layer sublayers]) {
        CAGradientLayer *gradientMask = [CAGradientLayer layer];
        gradientMask.frame = self.bounds;
        gradientMask.colors = @[(id)[UIColor clearColor].CGColor,
                                (id)[UIColor blackColor].CGColor];
        gradientMask.locations = @[@0.00, @0.95];
        
        [self.poster.layer insertSublayer:gradientMask atIndex:0];
    }
}

-(void)setActorCellGradient{
    if (![self.poster.layer sublayers]) {
        CAGradientLayer *gradientMask = [CAGradientLayer layer];
        gradientMask.frame = self.bounds;
        gradientMask.colors = @[(id)[UIColor clearColor].CGColor,
                                (id)[UIColor blackColor].CGColor];
        gradientMask.locations = @[@0.00, @1.00];
        
        [self.poster.layer insertSublayer:gradientMask atIndex:0];
    }
}


-(void)favoureIt{
    [_favouriteButton setImage:[UIImage imageNamed:@"MainFav"] forState:UIControlStateNormal];
}

-(void)unFavoureIt{
    [_favouriteButton setImage:[UIImage imageNamed:@"MainNonFav"] forState:UIControlStateNormal];
}

-(void)watchIt{
    [_watchButton setImage:[UIImage imageNamed:@"MainWatch"] forState:UIControlStateNormal];
}

-(void)unWatchIt{
    [_watchButton setImage:[UIImage imageNamed:@"MainNonWatch"] forState:UIControlStateNormal];
}


@end
