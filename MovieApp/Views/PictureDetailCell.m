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
}

-(void) setupWithShow:(TVShow *) singleShow{
    
    [self.poster sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://image.tmdb.org/t/p/w780/",singleShow.backdropPath]]
                   placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",singleShow.name,@".png"]]];
    
    NSDate *releaseYear = singleShow.firstAirDate;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:releaseYear];
    NSInteger year = [components year];
    _movieTitle.text = [NSString stringWithFormat:@"%@(%ld)",singleShow.name,(long)year];
}

-(void) setupWithActor:(Actor *)singleActor{
    
    [self.poster sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://image.tmdb.org/t/p/w185/",singleActor.profilePath]]
                   placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",singleActor.name,@".png"]]];
    _movieTitle.text=singleActor.name;
}

@end
