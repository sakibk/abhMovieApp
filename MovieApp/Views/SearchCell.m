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

-(void)setupSeparator{
    self.separatorView = [UIView new];
    CGFloat height = UIScreen.mainScreen.scale == 1.0 ? 1.0 : 0.5;
    self.separatorView.frame = CGRectMake(0.0,
                                          0.0,
                                          CGRectGetWidth(self.frame),
                                          height);
    self.separatorView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
    [self addSubview:self.separatorView];
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
        _releaseAirDate.text=[NSString stringWithFormat:@"(N/A)"];
    }

    [self setRating:singleMovie.rating];
    _searchTitle.text=[NSString stringWithFormat:@"%@",singleMovie.title];
    if(_isSideBar)
        [self setupSeparator];

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

    [self setRating:singleShow.rating];
    _searchTitle.text=[NSString stringWithFormat:@"%@",singleShow.name];
    if(_isSideBar)
        [self setupSeparator];
}

-(void)setRating:(NSNumber*)rate{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:1];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    
    NSString *numberString = [formatter stringFromNumber:rate];
    
    _searchRating.text=[NSString stringWithFormat:@"%@",numberString];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
