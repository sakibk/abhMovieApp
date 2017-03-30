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
#import <Reachability/Reachability.h>


NSString* const pictureDetailCellIdentifier= @"pictureCellIdentifier";



@implementation PictureDetailCell{
    NSString *picturePath;
    Reachability *reachability;
    BOOL isConnected;
    BOOL notifRec;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_watchButton addTarget:self action:@selector(addToWatchList:) forControlEvents:UIControlEventTouchUpInside];
    [_favouriteButton addTarget:self action:@selector(addToFavoriteList:) forControlEvents:UIControlEventTouchUpInside];
    _realm =[RLMRealm defaultRealm];
    notifRec=NO;
    isConnected=[ConnectivityTest isConnected];
    [self.watchButton setImageEdgeInsets:UIEdgeInsetsMake(10, 13, 9, 5)];
    [self.favouriteButton setImageEdgeInsets:UIEdgeInsetsMake(8, 5, 9, 14)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
}

- (void)reachabilityDidChange:(NSNotification *)notification {
    
    reachability = (Reachability *)[notification object];
    if(!notifRec){
    if ([reachability isReachable]) {
        NSLog(@"Reachable");
        isConnected=[ConnectivityTest isConnected];
        [self setPicture:picturePath];
    } else {
        NSLog(@"Unreachable");
        isConnected=[ConnectivityTest isConnected];
    }
        notifRec=YES;
    }
    else
        notifRec=NO;
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

-(void)setPicture:(NSString*)picPath{
    [self.poster sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://image.tmdb.org/t/p/w780/",picPath]]
                   placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",@"noBackdropAvalible"]]];
}

-(void) setupWithMovie:(Movie *) singleMovie{
    [self setHidenButtons];
    if(singleMovie.backdropPath != nil)
    picturePath=[[NSString alloc] initWithString:singleMovie.backdropPath];
    [self setPicture:singleMovie.backdropPath];
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
    if(singleShow.backdropPath != nil)
    picturePath=[[NSString alloc] initWithString:singleShow.backdropPath];
    [self setPicture:singleShow.backdropPath];
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

-(void) setupWithSnapMovie:(Movie *) singleMovie{
    [_watchButton setHidden:YES];
    [_favouriteButton setHidden:YES];
    [_playButton setHidden:YES];
    if(singleMovie.backdropPath != nil)
        picturePath=[[NSString alloc] initWithString:singleMovie.backdropPath];
    [self setPicture:singleMovie.backdropPath];
    NSDate *releaseYear = singleMovie.releaseDate;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:releaseYear];
    NSInteger year = [components year];
    _movieTitle.text = [NSString stringWithFormat:@"%@(%ld)",singleMovie.title,(long)year];
    _singleMovie=singleMovie;
    [self setCellGradient];
    
}

-(void) setupWithActor:(Actor *)singleActor{
    if(singleActor.profilePath != nil)
        picturePath=[[NSString alloc] initWithString:singleActor.profilePath];
    [self setPicture:singleActor.profilePath];
    [_movieTitle setFont:[_movieTitle.font fontWithSize:27.0]];
    _movieTitle.text=singleActor.name;
    [_playButton setHidden:YES];
    [_favouriteButton setHidden:YES];
    [_watchButton setHidden:YES];
    [self setActorCellGradient];
}

-(void) setupWithEpisode:(Episode *) singleEpisode;{
    [self setHidenButtons];
    if(singleEpisode.episodePoster != nil)
        picturePath=[[NSString alloc] initWithString:singleEpisode.episodePoster];
    [self setPicture:singleEpisode.episodePoster];
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
