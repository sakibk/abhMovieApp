//
//  ImageCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 14/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "ImageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString *const imageCellIdentifier=@"ImageCellIdentifier";

@implementation ImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setupWithUrl:(NSString*) posterPath{
    [self.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://image.tmdb.org/t/p/w185/",posterPath]]
                  placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",posterPath,@".png"]]];
}

@end
