//
//  MovieDetailViewController.h
//  MovieApp
//
//  Created by Sakib Kurtic on 20/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieDetailViewController : UIViewController

@property (nonatomic,strong) NSNumber* movieID;
@property (weak, nonatomic) IBOutlet UIImageView *detailPoster;
@property (weak, nonatomic) IBOutlet UILabel *detailTitle;

-(void)setDetailPoster;

@end
