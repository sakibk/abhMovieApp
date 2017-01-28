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
    
    _genID = [singleMovie.genreIds objectAtIndex:0];
    
    
    for (Genre *gen in  singleMovie.genres) {
        if (gen.genreID == _genID) {
            singleMovie.singleGenre=gen.genreName;
        }
    }
    
  _genreLabel.text=singleMovie.singleGenre;
}

@end
