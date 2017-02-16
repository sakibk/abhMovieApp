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

NSString* const pictureDetailCellIdentifier= @"pictureCellIdentifier";



@implementation PictureDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}


-(void) setupWithMovie:(Movie *) singleMovie{
    
    [self.poster sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://image.tmdb.org/t/p/w780/",singleMovie.backdropPath]]
                       placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",singleMovie.title,@".png"]]];
    
    NSDate *releaseYear = singleMovie.releaseDate;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:releaseYear];
    NSInteger year = [components year];
    _movieTitle.text = [NSString stringWithFormat:@"%@(%ld)",singleMovie.title,(long)year];
    _singleMovie=singleMovie;
    if(singleMovie){
        
    }
    [self setCellGradient];
    
}

-(void) setupWithShow:(TVShow *) singleShow{
    
    [self.poster sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://image.tmdb.org/t/p/w780/",singleShow.backdropPath]]
                   placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",singleShow.name,@".png"]]];
    
    NSDate *releaseYear = singleShow.firstAirDate;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:releaseYear];
    NSInteger year = [components year];
    _movieTitle.text = [NSString stringWithFormat:@"%@(%ld)",singleShow.name,(long)year];
    [_playButton setHidden:YES];
    [self setCellGradient];
}

-(void) setupWithActor:(Actor *)singleActor{
    
    [self.poster sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://image.tmdb.org/t/p/w780/",singleActor.profilePath]]
                   placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",singleActor.name,@".png"]]];
    [_movieTitle setFont:[_movieTitle.font fontWithSize:27.0]];
    _movieTitle.text=singleActor.name;
    [_playButton setHidden:YES];
    [self setCellGradient];
}

-(void) setupWithEpisode:(Episode *) singleEpisode;{
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



@end
