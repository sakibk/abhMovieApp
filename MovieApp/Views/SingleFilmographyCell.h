//
//  SingleFilmographyCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 08/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cast.h"

extern NSString *const singleFilmographyCellIdentifier;

@interface SingleFilmographyCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *castImage;
@property (weak, nonatomic) IBOutlet UILabel *castMovie;
@property (weak, nonatomic) IBOutlet UILabel *castRole;

-(void)setupWithCast:(Cast *) singleCast;

@end
