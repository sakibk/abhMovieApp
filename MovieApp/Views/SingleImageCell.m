//
//  SingleImageCollectionViewCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 26/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "SingleImageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString* const SingleImageCellIdentifier= @"imgCellIdentifier";

@implementation SingleImageCell

-(void)setupWithUrl:(NSString*) posterPath{
    [self.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://image.tmdb.org/t/p/w185/",posterPath]]
                  placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",posterPath,@".png"]]];
}

@end
