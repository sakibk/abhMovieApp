//
//  MoviesCollectionViewCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 17/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "MoviesCell.h"
#import "Movie.h"
#import "Genre.h"
#import <RestKit/RestKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ConnectivityTest.h"

NSString* const identifier= @"MovieCellIdentifier";

@implementation MoviesCell
{
    NSNumberFormatter *formatter;
    BOOL isConnected;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setFormater];
    isConnected = [ConnectivityTest isConnected];
}

-(void)setFormater{
    formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:1];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
}


-(void) setupMovieCell:(Movie *) singleMovie{
    _isLoged=[[NSUserDefaults standardUserDefaults] boolForKey:@"isLoged"];
    if(!_isLoged){
        [_watchlisted setHidden:YES];
        [_favoured setHidden:YES];
    }
    NSDate *releaseYear = singleMovie.releaseDate;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:releaseYear];
    NSInteger year = [components year];
    
    _title.text = [NSString stringWithFormat:@"%@(%ld)",singleMovie.title,(long)year];
    
    [_coverImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://image.tmdb.org/t/p/w185/",singleMovie.posterPath]]
                   placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",@"noPosterAvalible"]]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd LLLL yyyy"];
    
    self.backgroundColor = [UIColor grayColor];
    _releaseDateLabel.text = [dateFormatter stringFromDate:singleMovie.releaseDate];
    
    _ratingLabel.text = [NSString stringWithFormat:@"%@",[formatter stringFromNumber:singleMovie.rating]];
    
    if( singleMovie.singleGenre){

        _genreLabel.text=singleMovie.singleGenre;
    }
    else if ([singleMovie.genres count]){
        for(Genre *g in singleMovie.genres){
            if(singleMovie.genreIds.firstObject==g.genreID)
                _genreLabel.text=g.genreName;
        }
    }
    else{
        _genreLabel.text=@"N/A";
    }
    [self setCellGradient];
}

-(void)setCellGradient{
    if (![self.coverImage.layer sublayers]) {
        CAGradientLayer *gradientMask = [CAGradientLayer layer];
        gradientMask.frame = self.bounds;
        gradientMask.colors = @[(id)[UIColor clearColor].CGColor,
                                (id)[UIColor blackColor].CGColor];
        gradientMask.locations = @[@0.00, @0.90];
        
        [self.coverImage.layer insertSublayer:gradientMask atIndex:0];
    }
}

-(void) setupShowCell:(TVShow *) singleShow{
    _isLoged=[[NSUserDefaults standardUserDefaults] boolForKey:@"isLoged"];
    if(!_isLoged){
        [_watchlisted setHidden:YES];
        [_favoured setHidden:YES];
    }
    NSDate *releaseYear = singleShow.firstAirDate;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:releaseYear];
    NSInteger year = [components year];
    
    _title.text = [NSString stringWithFormat:@"%@(%ld)",singleShow.name,(long)year];
    
    [_coverImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://image.tmdb.org/t/p/w185/",singleShow.posterPath]]
                   placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",@"noPosterAvalible"]]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    
    self.backgroundColor = [UIColor grayColor];
    _releaseDateLabel.text = [NSString stringWithFormat:@"(TV Series %@)",[dateFormatter stringFromDate:singleShow.firstAirDate]];
    
    _ratingLabel.text = [NSString stringWithFormat:@"%@",[formatter stringFromNumber:singleShow.rating]];
    
    if(singleShow.singleGenre){
        _genreLabel.text=singleShow.singleGenre;
    }
    else if ([singleShow.genres count]){
        for(Genre *g in singleShow.genres){
            if(singleShow.genreIds.firstObject==g.genreID)
                _genreLabel.text=g.genreName;
        }
    }
    else{
        _genreLabel.text=@"N/A";
    }
    
    [self setCellGradient];
}

-(void)favoureIt{
    [_favoured setImage:[UIImage imageNamed:@"YellowFavoritesButton"]];
}

-(void)unFavoureIt{
    [_favoured setImage:[UIImage imageNamed:@"NonLikedMedia"]];
}

-(void)watchIt{
    [_watchlisted setImage:[UIImage imageNamed:@"YellowWatchlistButton"]];
}

-(void)unWatchIt{
    [_watchlisted setImage:[UIImage imageNamed:@"NonWatchedMedia"]];
}

@end
