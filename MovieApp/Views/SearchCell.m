//
//  SearchCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 06/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "SearchCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString *const searchCellIdentifier=@"SearchCellIdentifier";

@implementation SearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setSearchCellWithMovie:(Movie *)singleMovie{
    
    [_searchImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://image.tmdb.org/t/p/w185/",singleMovie.posterPath]]
                    placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",singleMovie.title,@".png"]]];
    if (singleMovie.releaseDate!=nil) {
        NSDate *releaseYear = singleMovie.releaseDate;
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:releaseYear];
        NSInteger year = [components year];
        
        _releaseAirDate.text=[NSString stringWithFormat:@"(%ld )",(long)year];
    }
    else{
        _releaseAirDate.text=[NSString stringWithFormat:@"(N/A )"];
    }

    _searchRating.text=[NSString stringWithFormat:@"%@",singleMovie.rating];
    _searchTitle.text=[NSString stringWithFormat:@"%@",singleMovie.title];

}


-(void)setSearchCellWithTVShow:(TVShow *)singleShow{
    
    [_searchImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://image.tmdb.org/t/p/w92/",singleShow.posterPath]]
                    placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",singleShow.name,@".png"]]];
    if(singleShow.airDate!=nil){
        NSDate *releaseYear = singleShow.airDate;
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:releaseYear];
        NSInteger year = [components year];
        
        _releaseAirDate.text=[NSString stringWithFormat:@"(TV series %ld- )",(long)year];
    }
    else{
        
        _releaseAirDate.text=[NSString stringWithFormat:@"(TV series N/A- )"];
    }

    
    
    _searchRating.text=[NSString stringWithFormat:@"%@",singleShow.rating];
    _searchTitle.text=[NSString stringWithFormat:@"%@",singleShow.name];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
