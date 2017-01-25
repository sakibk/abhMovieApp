//
//  MoviesCollectionViewCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 17/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "MoviesCollectionViewCell.h"
#import "Movie.h"

NSString* const identifier= @"MovieCellIdentifier";

@implementation MoviesCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void) setupMovieCell:(Movie *) singleMovie{
    NSDate *releaseYear = singleMovie.releaseDate;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:releaseYear];
    NSInteger year = [components year];
    _title.text = [NSString stringWithFormat:@"%@(%ld)",singleMovie.title,year];
}

@end
