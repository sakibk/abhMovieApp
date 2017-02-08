//
//  PictureDetailTableViewCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 26/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "TVShow.h"
#import "Actor.h"

extern NSString * const pictureDetailCellIdentifier;

@interface PictureDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *poster;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;

-(void) setupWithMovie:(Movie *) singleMovie;
-(void) setupWithShow:(TVShow *) singleShow;
-(void) setupWithActor:(Actor *) singleActor;

@end
