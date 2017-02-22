//
//  RatingViewController.h
//  MovieApp
//
//  Created by Sakib Kurtic on 21/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "TVShow.h"

@interface RatingViewController : UIViewController

@property (strong,nonatomic) Movie *singleMovie;
@property (strong,nonatomic) TVShow *singleShow;
@property (weak, nonatomic) IBOutlet UILabel *mediaTitle;
@property (weak, nonatomic) IBOutlet UIButton *rateButton;

-(void)setupWithMovie:(Movie*)movie;
-(void)setupWithShow:(TVShow*)show;

@end
