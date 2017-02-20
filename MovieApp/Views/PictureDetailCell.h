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
#import "Episode.h"
#import "ListPost.h"

extern NSString * const pictureDetailCellIdentifier;


@interface PictureDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *poster;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) Movie *singleMovie;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;
@property (weak, nonatomic) IBOutlet UIButton *watchButton;

@property(strong, nonatomic) NSDictionary *userCredits;
@property(strong, nonatomic) ListPost *listToPost;

-(void) setupWithMovie:(Movie *) singleMovie;
-(void) setupWithShow:(TVShow *) singleShow;
-(void) setupWithActor:(Actor *) singleActor;
-(void) setupWithEpisode:(Episode *) singleEpisode;


@property BOOL isLoged;
@end
