//
//  SingleCastCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 27/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "SingleCastCell.h"

NSString *const singleCastCellIdentifier=@"SingleCastCellIdentifier";

@implementation SingleCastCell

-(void)setupWithCast:(Cast *) singleCast{
    
    [self.castImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://image.tmdb.org/t/p/w92/",singleCast.castImagePath]]
                  placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",singleCast.castName,@".png"]]];
    
    _castName.text=singleCast.castName;
    _castRoleNames.text = singleCast.castRoleName;
    
}

@end
