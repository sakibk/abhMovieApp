//
//  MoviesCollectionViewCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 17/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

extern NSString * const identifier;

@interface MoviesCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;

@property Genre *singleGerne;
@property NSNumber *genID;

-(void) setupMovieCell:(Movie *) singleMovie;

@end
