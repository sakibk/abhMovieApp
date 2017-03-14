//
//  RatingViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 21/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "RatingViewController.h"
#import <HCSStarRatingView/HCSStarRatingView.h>
#import <Realm/Realm.h>
#import "RLUserInfo.h"
#import <RestKit/RestKit.h>
#import "ListPost.h"

@interface RatingViewController ()

@property NSNumber *rate;
@property NSDictionary *userCredits;
@property RLMRealm *realm;
@property RLUserInfo *user;
@property NSString *pathP;

@property BOOL isMovie;
@property BOOL didRate;
@property BOOL isSuccessful;

@end

@implementation RatingViewController
{
    HCSStarRatingView *starRatingView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUserDefaults];
    [self setupRatings];
    [self setupView];
}

-(void)setupUserDefaults{
    [_rateButton addTarget:self action:@selector(rateMe:) forControlEvents:UIControlEventTouchUpInside];
    _realm=[RLMRealm defaultRealm];
    _userCredits = [[NSUserDefaults standardUserDefaults] objectForKey:@"SessionCredentials"];
    RLMResults<RLUserInfo*> *users= [RLUserInfo objectsWhere:@"userID = %@", [_userCredits objectForKey:@"userID"]];
    if([users count]){
        _user = [users firstObject];
    }
    _didRate= NO;
}

-(void)setupView{
    self.navigationItem.leftBarButtonItem.title=@"Cancel";
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(rateMe:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    if(_isMovie){
        self.navigationItem.title=_singleMovie.title;
    }
    else{
        self.navigationItem.title=_singleShow.name;
    }
    _ratingStatus.layer.cornerRadius=29;
    _ratingStatus.clipsToBounds = YES;
    _ratingStatus.textAlignment = NSTextAlignmentCenter;
    [_ratingStatus setHidden:YES];
    if(_isMovie){
        _mediaTitle.text=[NSString stringWithFormat:@"Rate:    %@",_singleMovie.title];
    }
    else{
        _mediaTitle.text=[NSString stringWithFormat:@"Rate:    %@",_singleShow.name];
    }
    
    if(_isMovie){
        if([[[_user ratedMovies] valueForKey:@"movieID"] containsObject:_singleMovie.movieID]){
            [_rateButton setHidden:YES];
            [self.navigationItem.rightBarButtonItem setTarget:nil];
            RLMResults<RLMovie*> *movies=[[_user ratedMovies] objectsWhere:@"movieID = %@",_singleMovie.movieID];
            RLMovie *result = movies.firstObject;
            starRatingView.value = [result.userRate doubleValue];
            [starRatingView setUserInteractionEnabled:NO];
        }
    }
    else{
        if([[[_user ratedShows] valueForKey:@"showID"] containsObject:_singleShow.showID]){
            [_rateButton setHidden:YES];
            [self.navigationItem.rightBarButtonItem setTarget:nil];
            RLMResults<RLTVShow*> *shows=[[_user ratedShows] objectsWhere:@"showID = %@",_singleShow.showID];
            RLTVShow *result = shows.firstObject;
            starRatingView.value = [result.userRate doubleValue];
            [starRatingView setUserInteractionEnabled:NO];
        }
    }
}

-(void)setupRatings{
    

    
    starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/4, 200, [UIScreen mainScreen].bounds.size.width/2, 60)];
    starRatingView.maximumValue = 10;
    starRatingView.minimumValue = 0.5;
    starRatingView.value = 0.5f;
    starRatingView.accurateHalfStars = YES;
    starRatingView.tintColor = [UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0];
    [starRatingView setBackgroundColor:[UIColor clearColor]];
    starRatingView.emptyStarImage = [UIImage imageNamed:@"NonRatedButton"];
    starRatingView.filledStarImage = [UIImage imageNamed:@"YellowRatingsButton"];
    [starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:starRatingView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:starRatingView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_rateButton attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];

}

-(void)postStatusError:(NSString*)error{
    [_ratingStatus setText:error];
    [_ratingStatus setHidden:NO];
    [self performSelector:@selector(hideLabel) withObject:nil afterDelay:2.7];
}

-(void)hideLabel{
    [UIView animateWithDuration:0.3 animations:^{
        [_ratingStatus setHidden:YES];
    } completion:^(BOOL finished){
        
    }];
}

-(IBAction)didChangeValue:(id)sender{
    _rate=[NSNumber numberWithDouble:starRatingView.value];
}

-(IBAction)rateMe:(id)sender{
    if(!_didRate){
    if(_isMovie){
        _singleMovie.userRate=_rate;
        [_user addToRatedMovies:[[RLMovie alloc]initWithMovie:_singleMovie]];
        [self noRestkitRate];
        [self postStatusError:@"Successfuly rated Movie"];
        [starRatingView setUserInteractionEnabled:NO];
        _didRate=YES;
        }
    else{
        _singleShow.userRate=_rate;
        [_user addToRatedShows:[[RLTVShow alloc] initWithShow:_singleShow]];
        [self noRestkitRate];
        [self postStatusError:@"Successfuly rated Show"];
        [starRatingView setUserInteractionEnabled:NO];
        _didRate=YES;
    }}
    else{
        [self postStatusError:@"Already Rated"];
    }

}


-(void)setupWithShow:(TVShow *)show{
    _singleShow=show;
    _isMovie=NO;
}

-(void)setupWithMovie:(Movie *)movie{
    _singleMovie=movie;
    _isMovie=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)noRestkitRate{
    NSError *error;
    
    if(_isMovie){
        _pathP = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/rating?api_key=%@&session_id=%@",_singleMovie.movieID, @"893050c58b2e2dfe6fa9f3fae12eaf64", [_userCredits objectForKey:@"sessionID"]];
    }
    else{
        _pathP = [NSString stringWithFormat:@"https://api.themoviedb.org/3/tv/%@/rating?api_key=%@&session_id=%@",_singleShow.showID, @"893050c58b2e2dfe6fa9f3fae12eaf64", [_userCredits objectForKey:@"sessionID"]];
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPAdditionalHeaders = @{
                                            @"Content-Type" : @"application/json;charset=utf-8"
                                            };
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:_pathP];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *dataMapped = @{
                                 @"value" : _rate
                                 };

    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dataMapped options:0 error:&error];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(!error){
            if([[dictionary valueForKey:@"status_code"] intValue]==1){
                NSLog(@"Rating added");
            }
            else if([[dictionary valueForKey:@"status_code"] intValue]==12){
                NSLog(@"The item/record was updated successfully");
            }
            _isSuccessful=YES;
        }
        else{
            _isSuccessful=NO;
        }
    }];
    
    [postDataTask resume];
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
