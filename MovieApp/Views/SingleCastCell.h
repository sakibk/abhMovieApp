//
//  SingleCastCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 27/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cast.h"
#import <SDWebImage/UIImageView+WebCache.h>

extern NSString *const singleCastCellIdentifier;

@interface SingleCastCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *castImage;
@property (weak, nonatomic) IBOutlet UILabel *castName;
@property (weak, nonatomic) IBOutlet UILabel *castRoleNames;

-(void)setupWithCast:(Cast *) singleCast;

@end
