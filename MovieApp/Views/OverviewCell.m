//
//  OverviewTableViewCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 26/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "OverviewCell.h"
#import <RestKit/RestKit.h>
#import "Crew.h"
#import "RatingViewController.h"

NSString * const OverviewCellIdentifier=@"overviewCellIdentifier";

@implementation OverviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setHidenButtons{
    _isLoged=[[NSUserDefaults standardUserDefaults] boolForKey:@"isLoged"];
    if(!_isLoged){
        [_rateButton setHidden:YES];
    }
    else{
        _userCredits=[[NSUserDefaults standardUserDefaults] objectForKey:@"SessionCredentials"];
        [_rateButton addTarget:self action:@selector(rateMedia:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)setupUser{
    _userCredits = [[NSUserDefaults standardUserDefaults] objectForKey:@"SessionCredentials"];
    RLMResults<RLUserInfo*> *users= [RLUserInfo objectsWhere:@"userID = %@", [_userCredits objectForKey:@"userID"]];
    if([users count]){
        _user = [users firstObject];
    }
}

-(IBAction)rateMedia:(id)sender{
    [self.delegate rateMedia];
}

-(void) setupWithMovie :(Movie*) singleMovie{
    [self setHidenButtons];
    
    RKObjectMapping *crewMapping = [RKObjectMapping mappingForClass:[Crew class]];
    
    [crewMapping addAttributeMappingsFromDictionary:@{@"job": @"jobName",
                                                       @"name": @"crewName"
                                                       }];
    
    NSString *pathP =[NSString stringWithFormat:@"/3/movie/%@/credits",singleMovie.movieID];
    
    RKResponseDescriptor *crewResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:crewMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:pathP
                                                keyPath:@"crew"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    
    [[RKObjectManager sharedManager] addResponseDescriptor:crewResponseDescriptor];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _setupMovie = [[Movie alloc]init];
        singleMovie.crews=[[NSMutableArray alloc]init];
        for (Crew *crew in mappingResult.array) {
            if ([crew isKindOfClass:[Crew class]]) {
                [singleMovie.crews addObject:crew];
            }
        }
        _setupMovie=singleMovie;
        [self setupOverview];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
 
    
}

-(void)setupOverview{
    if([[[_user ratedMovies] valueForKey:@"movieID"] containsObject:_setupMovie.movieID]){
        [_rateButton setImage:[UIImage imageNamed:@"YellowRatingsButton"] forState:UIControlStateNormal];
    }
    
    _rating.text = [NSString stringWithFormat:@"%@",_setupMovie.rating];
    _overview.text = _setupMovie.overview;
    _writersString = [[NSMutableString alloc]init];
    _producentString = [[NSMutableString alloc]init];
    Boolean tag = false;
    for(Crew *sinCrew in _setupMovie.crews ){
        if([sinCrew.jobName isEqualToString:@"Director"]){
            _director.text=sinCrew.crewName;
            tag = true;
        }
        else if([sinCrew.jobName isEqualToString:@"Writer"]){
            [_writersString appendString:sinCrew.crewName];
            [_writersString appendString:@", "];
        }
        else if ([sinCrew.jobName isEqualToString:@"Producer"]){
            [_producentString appendString:sinCrew.crewName];
            [_producentString appendString:@", "];
        }
    }
    if(![_writersString isEqualToString:@""]){
    [_writersString deleteCharactersInRange:NSMakeRange([_writersString length]-2, 2)];
    }
    if(![_producentString isEqualToString:@""]){
    [_producentString deleteCharactersInRange:NSMakeRange([_producentString length]-2, 2)];
    }
    _stars.text=_producentString;
    _writers.text=_writersString;
    
    if([_stars.text isEqualToString:@""]){
        _stars.text=@"  N/A  ";
    }
    
    if([_writers.text isEqualToString:@""]){
        _writers.text=@"  N/A  ";
    }
    
    if(tag==false){
        _director.text=@"  N/A  ";
    }
}

-(void) setupWithShow :(TVShow*) singleShow{
    [self setHidenButtons];
    
    RKObjectMapping *crewMapping = [RKObjectMapping mappingForClass:[Crew class]];
    
    [crewMapping addAttributeMappingsFromDictionary:@{@"job": @"jobName",
                                                      @"name": @"crewName"
                                                      }];
    
    NSString *pathP =[NSString stringWithFormat:@"/3/tv/%@/credits",singleShow.showID];
    
    RKResponseDescriptor *crewResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:crewMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:pathP
                                                keyPath:@"crew"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    
    [[RKObjectManager sharedManager] addResponseDescriptor:crewResponseDescriptor];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
//        for(Crew *singleCrew)
        _setupShow = [[TVShow alloc]init];
        singleShow.crews=[[NSMutableArray alloc]init];
        for (Crew *crew in mappingResult.array) {
            if ([crew isKindOfClass:[Crew class]]) {
                [singleShow.crews addObject:crew];
            }
        }
        _setupShow=singleShow;
        [self setupShowOverview];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
    
    
}

-(void)setupShowOverview{
    if([[[_user ratedShows] valueForKey:@"showID"] containsObject:_setupShow.showID]){
        [_rateButton setImage:[UIImage imageNamed:@"YellowRatingsButton"] forState:UIControlStateNormal];
    }
    
    _rating.text = [NSString stringWithFormat:@"%@",_setupShow.rating];
    _overview.text = _setupShow.overview;
    _writersString = [[NSMutableString alloc]init];
    _producentString = [[NSMutableString alloc]init];
    Boolean tag = false;
    for(Crew *sinCrew in _setupShow.crews ){
        if([sinCrew.jobName isEqualToString:@"Director"]){
            _director.text=sinCrew.crewName;
            tag=true;
        }
        else if([sinCrew.jobName isEqualToString:@"Writer"]){
            [_writersString appendString:sinCrew.crewName];
            [_writersString appendString:@", "];
        }
        else if ([sinCrew.jobName isEqualToString:@"Producer"]){
            [_producentString appendString:sinCrew.crewName];
            [_producentString appendString:@", "];
        }
    }
    if(![_writersString isEqualToString:@""]){
        [_writersString deleteCharactersInRange:NSMakeRange([_writersString length]-2, 2)];
    }
    if(![_producentString isEqualToString:@""]){
        [_producentString deleteCharactersInRange:NSMakeRange([_producentString length]-2, 2)];
    }
    _stars.text=_producentString;
    _writers.text=_writersString;
    if([_stars.text isEqualToString:@""]){
        _stars.text=@"  N/A  ";
    }
    
    if([_writers.text isEqualToString:@""]){
        _writers.text=@"  N/A  ";
    }

    if(tag == false){
        _director.text=@"  N/A  ";
    }

}

@end
