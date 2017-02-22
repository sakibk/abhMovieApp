//
//  RatingViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 21/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "RatingViewController.h"
#import <HCSStarRatingView/HCSStarRatingView.h>

@interface RatingViewController ()

@property NSNumber *rate;

@end

@implementation RatingViewController
{
    HCSStarRatingView *starRatingView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupRatings];
}

-(void)setupRatings{
    starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/4, 184, [UIScreen mainScreen].bounds.size.width/2, 60)];
    starRatingView.maximumValue = 10;
    starRatingView.minimumValue = 0.5;
    starRatingView.value = 0.5f;
    starRatingView.accurateHalfStars = YES;
    starRatingView.tintColor = [UIColor yellowColor];
    [starRatingView setBackgroundColor:[UIColor clearColor]];
    starRatingView.emptyStarImage = [UIImage imageNamed:@"NonRatedButton"];
    starRatingView.filledStarImage = [UIImage imageNamed:@"YellowRatingsButton"];
    [starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:starRatingView];
}

-(IBAction)didChangeValue:(id)sender{
    _rate=[NSNumber numberWithDouble:starRatingView.value];
    [self postRate];
}

-(void)postRate{
    
}

-(void)setupWithShow:(TVShow *)show{
    _singleShow=show;
}

-(void)setupWithMovie:(Movie *)movie{
    _singleMovie=movie;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
