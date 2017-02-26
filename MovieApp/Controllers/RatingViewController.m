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
@property BOOL isRated;

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
}

-(void)setupView{
    _ratingStatus.layer.cornerRadius=29;
    _ratingStatus.clipsToBounds = YES;
    _ratingStatus.textAlignment = NSTextAlignmentCenter;
    [_ratingStatus setHidden:YES];
    if(_isMovie){
        _mediaTitle.text=[NSString stringWithFormat:@"Rate:    %@",_singleMovie.title];
        _isRated = [_user ratedMovies];
    }
    else{
        _mediaTitle.text=[NSString stringWithFormat:@"Rate:    %@",_singleShow.name];
        _isRated = [_user ratedShows];
    }
    
    if(_isMovie){
        if([[[_user ratedMovies] valueForKey:@"movieID"] containsObject:_singleMovie.movieID]){
            [_rateButton setHidden:YES];
            RLMResults<RLMovie*> *movies=[[_user ratedMovies] objectsWhere:@"movieID = %@",_singleMovie.movieID];
            RLMovie *result = movies.firstObject;
            starRatingView.value = [result.userRate doubleValue];
            [starRatingView setUserInteractionEnabled:NO];
        }
    }
    else{
        if([[[_user ratedShows] valueForKey:@"showID"] containsObject:_singleShow.showID]){
            [_rateButton setHidden:YES];
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
    starRatingView.tintColor = [UIColor yellowColor];
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
    if(_isMovie){
        _singleMovie.userRate=_rate;
        [_user addToRatedMovies:[[RLMovie alloc]initWithMovie:_singleMovie]];
        [self postToRateList];
        [self postStatusError:@"Successfuly rated Movie"];
        }
    else{
        _singleShow.userRate=_rate;
        [_user addToRatedShows:[[RLTVShow alloc] initWithShow:_singleShow]];
        [self postToRateList];
        [self postStatusError:@"Successfuly rated Show"];
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

-(void)postToRateList{
    if(_isMovie){
    _pathP = [NSString stringWithFormat:@"/3/movie/%@/rating?api_key=%@&session_id=%@",_singleMovie.movieID, @"893050c58b2e2dfe6fa9f3fae12eaf64", [_userCredits objectForKey:@"sessionID"]];
    }
    else{
    _pathP = [NSString stringWithFormat:@"/3/tv/%@/rating?api_key=%@&session_id=%@",_singleShow.showID, @"893050c58b2e2dfe6fa9f3fae12eaf64", [_userCredits objectForKey:@"sessionID"]];
    }
    
    NSMutableIndexSet *statusCodesRK = [[NSMutableIndexSet alloc]initWithIndexSet:[NSIndexSet indexSetWithIndex:200]];
    [statusCodesRK addIndexes:[NSIndexSet indexSetWithIndex:201]];
    
    RKObjectMapping *requestMapping= [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:@[@"status_code", @"status_message"]];
    
    RKRequestDescriptor *watchlistRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[NSDictionary class] rootKeyPath:nil method:RKRequestMethodAny];
    
    RKObjectMapping *watchlistMapping = [RKObjectMapping mappingForClass:[NSDictionary class]];
    
    [watchlistMapping addAttributeMappingsFromArray:@[@"status_code", @"status_message"]];
    
    watchlistMapping.assignsNilForMissingRelationships=YES;
    
    RKResponseDescriptor *watchlistResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:watchlistMapping
                                                                                                     method:RKRequestMethodGET
                                                                                                pathPattern:_pathP
                                                                                                    keyPath:nil statusCodes:statusCodesRK];
    //
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:@"application/json"];
    [[RKObjectManager sharedManager] addRequestDescriptor:watchlistRequestDescriptor];
    [[RKObjectManager sharedManager] addResponseDescriptor:watchlistResponseDescriptor];
    
    
    
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    RKLogConfigureByName("Restkit/Network", RKLogLevelDebug);

    
    NSDictionary *queryParameters = @{
                                      @"value" : _rate
                                      };
    
    
    
    [[RKObjectManager sharedManager] postObject:nil path:_pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
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
