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

NSString* const identifier= @"MovieCellIdentifier";

@implementation MoviesCell


- (void)awakeFromNib {
    [super awakeFromNib];
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
                       placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",singleMovie.title,@".png"]]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd LLLL yyyy"];
    
    self.backgroundColor = [UIColor grayColor];
    _releaseDateLabel.text = [dateFormatter stringFromDate:singleMovie.releaseDate];
    
    _ratingLabel.text = [NSString stringWithFormat:@"%@",singleMovie.rating];
    
    if( singleMovie.genreIds.count!=0){
    _genID = [singleMovie.genreIds objectAtIndex:0];
    
    
    for (Genre *gen in  singleMovie.genres) {
        if (gen.genreID == _genID) {
            singleMovie.singleGenre=gen.genreName;
        }
    }
        _genreLabel.text=singleMovie.singleGenre;
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
    NSDate *releaseYear = singleShow.airDate;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:releaseYear];
    NSInteger year = [components year];
    
    _title.text = [NSString stringWithFormat:@"%@(%ld)",singleShow.name,(long)year];
    
    [_coverImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://image.tmdb.org/t/p/w185/",singleShow.posterPath]]
                   placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",singleShow.name,@".png"]]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    
    self.backgroundColor = [UIColor grayColor];
    _releaseDateLabel.text = [NSString stringWithFormat:@"(TV Series %@-)",[dateFormatter stringFromDate:singleShow.airDate]];
    
    _ratingLabel.text = [NSString stringWithFormat:@"%@",singleShow.rating];
    
        if( singleShow.genreIds.count!=0){
    _genID = [singleShow.genreIds objectAtIndex:0];
    for (Genre *gen in  singleShow.genres) {
        if (gen.genreID == _genID) {
            singleShow.singleGenre=gen.genreName;
        }
    }
    
    _genreLabel.text=singleShow.singleGenre;
        }
        else{
            _genreLabel.text=@"N/A";
        }
    
    [self setCellGradient];
}

@end
