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

NSString* const pictureDetailCellIdentifier= @"pictureCellIdentifier";



@implementation PictureDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_watchButton addTarget:self action:@selector(addToWatchList:) forControlEvents:UIControlEventTouchUpInside];
    [_favouriteButton addTarget:self action:@selector(addToFavoriteList:) forControlEvents:UIControlEventTouchUpInside];
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
    _listToPost.isFavorite=nil;
    _listToPost.isWatchlist=[NSNumber numberWithBool:YES];
    [self addToWatchlist];
}

-(IBAction)addToFavoriteList:(id)sender{
    _listToPost.isFavorite=[NSNumber numberWithBool:YES];
    _listToPost.isWatchlist=nil;
    [self addToFavourites];
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
    _listToPost.mediaID=singleMovie.movieID;
    _listToPost.mediaType=@"movie";
    _listToPost.isFavorite=[NSNumber numberWithBool:YES];
    _listToPost.isWatchlist=[NSNumber numberWithBool:YES];
    if(singleMovie){
        
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
    _listToPost.mediaID=singleShow.showID;
    _listToPost.mediaType=@"tv";
    _listToPost.isFavorite=[NSNumber numberWithBool:YES];
    _listToPost.isWatchlist=[NSNumber numberWithBool:YES];
    [self setWatchlistRestkit];
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
    [self setCellGradient];
}

-(void) setupWithEpisode:(Episode *) singleEpisode;{
    [self setHidenButtons];
    [self.poster sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://image.tmdb.org/t/p/w780/",singleEpisode.episodePoster]]
                   placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",singleEpisode.episodeName,@".png"]]];
    [_movieTitle setFont:[_movieTitle.font fontWithSize:27.0]];
    _movieTitle.text=@" ";
    [self setCellGradient];
    [_playButton setHidden:YES];
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

-(void)setWatchlistRestkit{
    RKObjectMapping *watchlistMapping = [RKObjectMapping mappingForClass:[ListPost class]];
    NSMutableIndexSet *statusCodesRK = [[NSMutableIndexSet alloc]initWithIndexSet:[NSIndexSet indexSetWithIndex:200]];
    [statusCodesRK addIndexes:[NSIndexSet indexSetWithIndex:401]];
    
    NSString *pathP = [NSString stringWithFormat:@"/3/account/%@/watchlist",[_userCredits objectForKey:@"userID"]];
    
    [watchlistMapping addAttributeMappingsFromDictionary:@{@"media_type":_listToPost.mediaType,
                                                           @"media_id": _listToPost.mediaID,
                                                           @"watchlist": _listToPost.isWatchlist
                                                           }];
    
    watchlistMapping.assignsNilForMissingRelationships=YES;
    
    RKRequestDescriptor *watchlistRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[watchlistMapping inverseMapping]
                                                                                             objectClass:[ListPost class]
                                                                                             rootKeyPath:nil
                                                                                            method:RKRequestMethodPOST];
    
    
    [[RKObjectManager sharedManager] addRequestDescriptor:watchlistRequestDescriptor];
}

-(void)addToWatchlist{
    NSString *pathP = [NSString stringWithFormat:@"/3/account/%@/watchlist",[_userCredits objectForKey:@"userID"]];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64",/*add your api*/
                                      @"session_id":[_userCredits objectForKey:@"sessionID"]
                                      };
    
    [[RKObjectManager sharedManager] postObject:_listToPost path:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];

}

-(void)addToFavourites{
    
}


@end
