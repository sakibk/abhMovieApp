//
//  CinemaCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 27/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "CinemaCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString *const cinemaCellIdentifier=@"CinemaCellIdentifier";

@implementation CinemaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupWithMovie:(Movie*)mov{
    
    
    NSDate *releaseYear = mov.releaseDate;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:releaseYear];
    NSInteger year = [components year];
    
    _movieTitle.text = [NSString stringWithFormat:@"%@(%ld)",mov.title,(long)year];
    if([mov.genres count]>1){
        _genreLabel.text = [NSString stringWithFormat:@"%@/%@",[mov.genres objectAtIndex:0].genreName,[mov.genres objectAtIndex:1].genreName];
    }
    else if ([mov.genres count]==1){
        _genreLabel.text = [NSString stringWithFormat:@"%@",[mov.genres objectAtIndex:0].genreName];
    }
    else
        _genreLabel.text = [NSString stringWithFormat:@"%@",mov.singleGenre];
    if(mov.rating!=nil){
        _rating.text = [NSString stringWithFormat:@"%@",mov.rating];
    }
    
    [self setPicture:mov.backdropPath];
    [self setCellGradient];
}

-(void)setCellGradient{
    if (![self.backdropImage.layer sublayers]) {
        CAGradientLayer *gradientMask = [CAGradientLayer layer];
        gradientMask.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) - 20, CGRectGetHeight(self.backdropImage.bounds) - 3);
        gradientMask.colors = @[(id)[UIColor clearColor].CGColor,
                                (id)[UIColor blackColor].CGColor];
        gradientMask.locations = @[@0.00, @1.00];
        
        [self.backdropImage.layer insertSublayer:gradientMask atIndex:0];
    }
}

-(void)setPicture:(NSString*)picPath{
    [_backdropImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://image.tmdb.org/t/p/w780",picPath]] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"noBackdropAvalible"]]];
}
@end
