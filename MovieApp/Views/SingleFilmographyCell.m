//
//  SingleFilmographyCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 08/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "SingleFilmographyCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString *const singleFilmographyCellIdentifier=@"SingleFilmographyCellIdentifier";

@implementation SingleFilmographyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


-(void)setupWithCast:(Cast *) singleCast{
    [self.castImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://image.tmdb.org/t/p/w92/",singleCast.castImagePath]]
                      placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",singleCast.castName,@".png"]]];
    if (singleCast.castMovieTitle!=nil) {
         _castMovie.text = singleCast.castMovieTitle;
    }
    if (singleCast.castRoleName!=nil) {
        _castRole.text = singleCast.castRoleName;
    }
    
}

@end
