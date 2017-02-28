//
//  LoginViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 16/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <RestKit/RestKit.h>
#import "Token.h"
#import "UserInfo.h"
#import "RLUserInfo.h"
#import "Movie.h"
#import "TVShow.h"
#import "RLMovie.h"
#import "RLTVShow.h"
#import "ListMapping.h"

@interface LoginViewController ()

@property Token *token;
@property Token *sessionToken;
@property Token *session;
@property UserInfo *currentUser;
@property RLMRealm *realm;
@property NSNumber *currentPage;
@property ListMapping *onePageFavMovieList;
@property ListMapping *onePageWtchMovieList;
@property ListMapping *onePageRateMovieList;
@property ListMapping *onePageFavShowList;
@property ListMapping *onePageWtchShowList;
@property ListMapping *onePageRateShowList;

@property RLMArray<RLUserInfo*> <RLUserInfo> *users;

@property RLUserInfo *user;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setVariables];
    [self setLoginView];
    [self setRestkit];
    [self getToken];
    [self setLoginRestkit];
    [self setSessionRestkit];
    [self setAccountRestkit];

    //[NSUserDefaults standardUserDefaults]
    // dodati restkit za statuscode 401 i provjeriti tekst koji se dobije ako nije nil !!
}

-(void)setVariables{
    _currentPage =[NSNumber numberWithInt:1];
    _onePageFavMovieList = [[ListMapping alloc]init];
    _onePageWtchMovieList = [[ListMapping alloc]init];
    _onePageRateMovieList = [[ListMapping alloc]init];
    _onePageFavShowList = [[ListMapping alloc]init];
    _onePageWtchShowList = [[ListMapping alloc]init];
    _onePageRateShowList = [[ListMapping alloc]init];
    _user = [[RLUserInfo alloc] init];
    _realm = [RLMRealm defaultRealm];
}

-(IBAction)sessionPressed:(id)sender{
    [self getTokenForSesion];
    [self.passwordEditor resignFirstResponder];
}

-(void)setLoginView{
    _loginButton.layer.cornerRadius = 29;
    _loginButton.clipsToBounds = YES;
    
    _statusLabel.layer.cornerRadius=29;
    _statusLabel.clipsToBounds = YES;
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    [_statusLabel setHidden:YES];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [self.navigationController.navigationBar setHidden:NO];
    UIImage* logoImage = [UIImage imageNamed:@"LoginTitle"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
    
    [self.passwordEditor setValue:[UIColor whiteColor]
                       forKeyPath:@"_placeholderLabel.textColor"];
    [self.emailEditor setValue:[UIColor whiteColor]
                    forKeyPath:@"_placeholderLabel.textColor"];
    
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateFocused];
    [_loginButton addTarget:self action:@selector(sessionPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)postStatusError:(NSString*)error{
    [_statusLabel setText:error];
    [_statusLabel setHidden:NO];
    [self performSelector:@selector(hideLabel) withObject:nil afterDelay:2.7];
}

-(void)hideLabel{
    [UIView animateWithDuration:0.3 animations:^{
        [_statusLabel setHidden:YES];
    } completion:^(BOOL finished){
        
    }];
}

-(void)setRestkit{
    NSString *pathP = @"/3/authentication/token/new";
    RKObjectMapping *tokenMapping = [RKObjectMapping mappingForClass:[Token class]];
    NSMutableIndexSet *statusCodesRK = [[NSMutableIndexSet alloc]initWithIndexSet:[NSIndexSet indexSetWithIndex:200]];
    [statusCodesRK addIndexes:[NSIndexSet indexSetWithIndex:401]];
    
    [tokenMapping addAttributeMappingsFromDictionary:@{@"success": @"isSuccessful",
                                                       @"expires_at": @"expireDate",
                                                       @"status_code": @"statusCode",
                                                       @"status_message": @"statusMessage",
                                                       @"request_token": @"requestToken"
                                                       }];
    
    tokenMapping.assignsNilForMissingRelationships=YES;
    
    RKResponseDescriptor *tokenResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:tokenMapping
                                                                                                 method:RKRequestMethodGET
                                                                                            pathPattern:pathP
                                                                                                keyPath:nil
                                                                                            statusCodes:statusCodesRK];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:tokenResponseDescriptor];
    
}

-(void)getToken{
    
    NSString *pathP = @"/3/authentication/token/new";
    
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64",/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _token=mappingResult.array.firstObject;
        if(_token.statusCode!=nil){
            [self postStatusError:@"Wrong api key"];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
}



-(void)setLoginRestkit{
    
    NSMutableIndexSet *statusCodesRK = [[NSMutableIndexSet alloc]initWithIndexSet:[NSIndexSet indexSetWithIndex:200]];
    [statusCodesRK addIndexes:[NSIndexSet indexSetWithIndex:401]];
    
    RKObjectMapping *sessionTokenMapping = [RKObjectMapping mappingForClass:[Token class]];
    
    NSString *pathP = @"/3/authentication/token/validate_with_login";
    
    [sessionTokenMapping addAttributeMappingsFromDictionary:@{@"success": @"isSuccessful",
                                                       @"status_code": @"statusCode",
                                                       @"status_message": @"statusMessage",
                                                       @"request_token": @"requestToken"
                                                       }];

    sessionTokenMapping.assignsNilForMissingRelationships=YES;
    
    RKResponseDescriptor *sessionTokenResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:sessionTokenMapping
                                                                                                 method:RKRequestMethodGET
                                                                                            pathPattern:pathP
                                                                                                keyPath:nil
                                                                                            statusCodes:statusCodesRK];
    

    [[RKObjectManager sharedManager] addResponseDescriptor:sessionTokenResponseDescriptor];
}


-(void)getTokenForSesion{
    NSString *token=_token.requestToken;
    
    NSString *pathP = @"/3/authentication/token/validate_with_login";
    
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64",/*add your api*/
                                      @"request_token":token,
                                      @"username":_emailEditor.text,
                                      @"password":_passwordEditor.text
                                      };

    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _sessionToken=mappingResult.array.firstObject;
            [self getSesion];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
        [self postStatusError:@"Wrong Username or Password"];
    }];
}

-(void)setSessionRestkit{
    RKObjectMapping *sessionMapping = [RKObjectMapping mappingForClass:[Token class]];
    NSMutableIndexSet *statusCodesRK = [[NSMutableIndexSet alloc]initWithIndexSet:[NSIndexSet indexSetWithIndex:200]];
    [statusCodesRK addIndexes:[NSIndexSet indexSetWithIndex:401]];
    
    NSString *pathP = @"/3/authentication/session/new";
    
    [sessionMapping addAttributeMappingsFromDictionary:@{@"success": @"isSuccessful",
                                                              @"status_code": @"statusCode",
                                                              @"status_message": @"statusMessage",
                                                              @"session_id": @"sessionID"
                                                              }];
    
    sessionMapping.assignsNilForMissingRelationships=YES;
    
    RKResponseDescriptor *sessionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:sessionMapping
                                                                                                 method:RKRequestMethodGET
                                                                                            pathPattern:pathP
                                                                                                keyPath:nil
                                                                                            statusCodes:statusCodesRK];
    
    
    [[RKObjectManager sharedManager] addResponseDescriptor:sessionResponseDescriptor];
}

-(void)getSesion{
    NSString *token=_sessionToken.requestToken;
    
    NSString *pathP = @"/3/authentication/session/new";
    
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64",/*add your api*/
                                      @"request_token":token
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _session=mappingResult.array.firstObject;
        _session.logedUsername=_emailEditor.text;
        _session.requestToken=token;
             [self postStatusError:@"Successfuly Logged"];
        [self getAccountDetails];
       // [[NSUserDefaults standardUserDefaults] setObject:_session forKey:@"session"];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
        [self postStatusError:@"Wrong Api key or request token"];
    }];
}

-(void)setAccountRestkit{
    RKObjectMapping *accountMapping = [RKObjectMapping mappingForClass:[UserInfo class]];
    NSMutableIndexSet *statusCodesRK = [[NSMutableIndexSet alloc]initWithIndexSet:[NSIndexSet indexSetWithIndex:200]];
    [statusCodesRK addIndexes:[NSIndexSet indexSetWithIndex:401]];
    
    NSString *pathP = @"/3/account";
    
    [accountMapping addAttributeMappingsFromDictionary:@{@"id": @"userID",
                                                         @"name": @"name",
                                                         @"username": @"userName"
                                                         }];
    
    accountMapping.assignsNilForMissingRelationships=YES;
    
    RKResponseDescriptor *accountResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:accountMapping
                                                                                                   method:RKRequestMethodGET
                                                                                              pathPattern:pathP
                                                                                                  keyPath:nil
                                                                                              statusCodes:statusCodesRK];
    
    
    [[RKObjectManager sharedManager] addResponseDescriptor:accountResponseDescriptor];
}

-(void)getAccountDetails{
    
    NSString *pathP = @"/3/account";
    
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64",/*add your api*/
                                      @"session_id":_session.sessionID
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _currentUser=mappingResult.array.firstObject;
        
        RLMResults<RLUserInfo*> *userss= [RLUserInfo objectsWhere:@"userID = %@", _currentUser.userID];
        
        if (![userss count]) {
            _user.userID=_currentUser.userID;
            _user.userName=_currentUser.userName;
            _user.name=_currentUser.userName;
            _user.session= [_user.session initWithToken:_session];
            [_realm beginWriteTransaction];
            [_realm addObject:_user];
            [_realm commitWriteTransaction];

        }
        else{
            _user = [userss firstObject];
        }
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoged"];
        NSDictionary *loginData = @{@"userID":_currentUser.userID,
                                    @"sessionID":_session.sessionID,
                                    @"token":_session.requestToken,
                                    @"username":_currentUser.userName,
                                    @"name":_currentUser.name,
                                    @"movieNotification":[NSNumber numberWithBool:NO],
                                    @"showNotification":[NSNumber numberWithBool:NO],
                                    @"apiKey": @"893050c58b2e2dfe6fa9f3fae12eaf64"
                                    };
        [[NSUserDefaults standardUserDefaults] setObject:loginData forKey:@"SessionCredentials"];
        [self setFavoriteMovieLists];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
        [self postStatusError:@"Wrong Api key or request token"];
    }];
}






-(void)setFavoriteMovieLists{
    RKObjectMapping *listMapping = [RKObjectMapping mappingForClass:[ListMapping class]];
    [listMapping addAttributeMappingsFromDictionary:@{@"page": @"page",
                                                       @"results": @"movieList",
                                                       @"total_pages": @"pageCount"
                                                       }];
    
    NSString *pathP =[NSString stringWithFormat:@"/3/account/%@/favorite/movies",_currentUser.userID];
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:listMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:pathP
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    [_realm beginWriteTransaction];
    [[_user favoriteMovies] removeAllObjects];
    [_realm commitWriteTransaction];
    [self getFavoriteMovieLists];
}

-(void)getFavoriteMovieLists{
    NSString *pathP =[NSString stringWithFormat:@"/3/account/%@/favorite/movies",_currentUser.userID];
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64",/*add your api*/
                                      @"session_id":_session.sessionID,
                                      @"sort_by":@"created_at.asc",
                                      @"page":_currentPage
                                      };
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        _onePageFavMovieList=[[mappingResult array] firstObject];
        for(Movie *mv in [_onePageFavMovieList movieList]){
            Movie *muv = [[Movie alloc]init];
            muv.movieID = [mv valueForKey:@"id"];
            muv.title = [mv valueForKey:@"title"];
            muv.rating = [mv valueForKey:@"vote_average"];
            muv.posterPath = [mv valueForKey:@"poster_path"];
            muv.backdropPath = [mv valueForKey:@"backdrop_path"];
            muv.overview = [mv valueForKey:@"overview"];
            muv.releaseDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",[mv valueForKey:@"release_date"]]];
            [_user addToFavoriteMovies:[[RLMovie alloc] initWithMovie:muv]];
        }
        
        if([[_onePageFavMovieList pageCount] isEqualToNumber:_currentPage] || [[_onePageFavMovieList pageCount] isEqualToNumber:[NSNumber numberWithInt:0]]){
            _currentPage=[NSNumber numberWithInt:1];
            [self setWatchlistMovieLists];
        }
        
        else if([_onePageFavMovieList pageCount]>_currentPage){
            int i = [_currentPage intValue];
            _currentPage = [NSNumber numberWithInt:i+1];
            [self getFavoriteMovieLists];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
}





-(void)setWatchlistMovieLists{
    RKObjectMapping *listMapping = [RKObjectMapping mappingForClass:[ListMapping class]];
    [listMapping addAttributeMappingsFromDictionary:@{@"page": @"page",
                                                      @"results": @"movieList",
                                                      @"total_pages": @"pageCount"
                                                      }];
    
    NSString *pathP =[NSString stringWithFormat:@"/3/account/%@/watchlist/movies",_currentUser.userID];
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:listMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:pathP
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    [_realm beginWriteTransaction];
    [[_user watchlistMovies] removeAllObjects];
    [_realm commitWriteTransaction];
    [self getWatchlistMovieLists];
}

-(void)getWatchlistMovieLists{
    NSString *pathP =[NSString stringWithFormat:@"/3/account/%@/watchlist/movies",_currentUser.userID];
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64",/*add your api*/
                                      @"session_id":_session.sessionID,
                                      @"sort_by":@"created_at.asc",
                                      @"page":_currentPage
                                      };
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        _onePageWtchMovieList=[[mappingResult array] firstObject];
        for(Movie *mv in [_onePageWtchMovieList movieList]){
            Movie *muv = [[Movie alloc]init];
            muv.movieID = [mv valueForKey:@"id"];
            muv.title = [mv valueForKey:@"title"];
            muv.rating = [mv valueForKey:@"vote_average"];
            muv.posterPath = [mv valueForKey:@"poster_path"];
            muv.backdropPath = [mv valueForKey:@"backdrop_path"];
            muv.overview = [mv valueForKey:@"overview"];
            muv.releaseDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",[mv valueForKey:@"release_date"]]];
            [_user addToWatchlistMovies:[[RLMovie alloc] initWithMovie:muv]];
        }
        if([[_onePageWtchMovieList pageCount] isEqualToNumber:_currentPage] || [[_onePageWtchMovieList pageCount] isEqualToNumber:[NSNumber numberWithInt:0]]){
            _currentPage=[NSNumber numberWithInt:1];
            [self setRatedMovieLists];
        }
        else if([_onePageWtchMovieList pageCount]>_currentPage){
            int i = [_currentPage intValue];
            _currentPage = [NSNumber numberWithInt:i+1];
            [self getWatchlistMovieLists];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
}





-(void)setRatedMovieLists{
    RKObjectMapping *listMapping = [RKObjectMapping mappingForClass:[ListMapping class]];
    [listMapping addAttributeMappingsFromDictionary:@{@"page": @"page",
                                                      @"results": @"movieList",
                                                      @"total_pages": @"pageCount"
                                                      }];
    
    NSString *pathP =[NSString stringWithFormat:@"/3/account/%@/rated/movies",_currentUser.userID];
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:listMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:pathP
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    [_realm beginWriteTransaction];
    [[_user ratedMovies] removeAllObjects];
    [_realm commitWriteTransaction];
    [self getRatedMovieLists];
}

-(void)getRatedMovieLists{
    NSString *pathP =[NSString stringWithFormat:@"/3/account/%@/rated/movies",_currentUser.userID];
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64",/*add your api*/
                                      @"session_id":_session.sessionID,
                                      @"sort_by":@"created_at.asc",
                                      @"page":_currentPage
                                      };
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        _onePageRateMovieList=[[mappingResult array] firstObject];
        for(Movie *mv in [_onePageRateMovieList movieList]){
            Movie *muv = [[Movie alloc]init];
            muv.movieID = [mv valueForKey:@"id"];
            muv.title = [mv valueForKey:@"title"];
            muv.rating = [mv valueForKey:@"vote_average"];
            muv.posterPath = [mv valueForKey:@"poster_path"];
            muv.backdropPath = [mv valueForKey:@"backdrop_path"];
            muv.overview = [mv valueForKey:@"overview"];
            muv.releaseDate = [dateFormatter dateFromString:[mv valueForKey:@"release_date"]];
            [_user addToRatedMovies:[[RLMovie alloc] initWithMovie:muv]];
        }
        if([[_onePageRateMovieList pageCount] isEqualToNumber:_currentPage] || [[_onePageRateMovieList pageCount] isEqualToNumber:[NSNumber numberWithInt:0]]){
            _currentPage=[NSNumber numberWithInt:1];
            [self setFavoriteShowLists];
        }
        
        else if([_onePageRateMovieList pageCount]>_currentPage){
            int i = [_currentPage intValue];
            _currentPage = [NSNumber numberWithInt:i+1];
            [self getRatedMovieLists];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
}






-(void)setFavoriteShowLists{
    RKObjectMapping *listMapping = [RKObjectMapping mappingForClass:[ListMapping class]];
    [listMapping addAttributeMappingsFromDictionary:@{@"page": @"page",
                                                      @"results": @"showList",
                                                      @"total_pages": @"pageCount"
                                                      }];
    
    NSString *pathP =[NSString stringWithFormat:@"/3/account/%@/favorite/tv",_currentUser.userID];
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:listMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:pathP
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    [_realm beginWriteTransaction];
    [[_user favoriteShows] removeAllObjects];
    [_realm commitWriteTransaction];
    [self getFavoriteShowLists];
}

-(void)getFavoriteShowLists{
    NSString *pathP =[NSString stringWithFormat:@"/3/account/%@/favorite/tv",_currentUser.userID];
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64",/*add your api*/
                                      @"session_id":_session.sessionID,
                                      @"sort_by":@"created_at.asc",
                                      @"page":_currentPage
                                      };
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        _onePageFavShowList=[[mappingResult array] firstObject];
        for(TVShow *tv in [_onePageFavShowList showList]){
            TVShow *tvs = [[TVShow alloc]init];
            tvs.showID = [tv valueForKey:@"id"];
            tvs.name = [tv valueForKey:@"name"];
            tvs.rating = [tv valueForKey:@"vote_average"];
            tvs.posterPath = [tv valueForKey:@"poster_path"];
            tvs.backdropPath = [tv valueForKey:@"backdrop_path"];
            tvs.overview = [tv valueForKey:@"overview"];
            tvs.airDate = [dateFormatter dateFromString:[tv valueForKey:@"first_air_date"]];
            [_user addToFavoriteShows:[[RLTVShow alloc] initWithShow:tvs]];
        }
        if([[_onePageFavShowList pageCount] isEqualToNumber:_currentPage] || [[_onePageFavShowList pageCount] isEqualToNumber:[NSNumber numberWithInt:0]]){
            _currentPage=[NSNumber numberWithInt:1];
            [self setWatchlistShowLists];
        }
        
        else if([_onePageFavShowList pageCount]>_currentPage){
            int i = [_currentPage intValue];
            _currentPage = [NSNumber numberWithInt:i+1];
            [self getFavoriteShowLists];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
}





-(void)setWatchlistShowLists{
    RKObjectMapping *listMapping = [RKObjectMapping mappingForClass:[ListMapping class]];
    [listMapping addAttributeMappingsFromDictionary:@{@"page": @"page",
                                                      @"results": @"showList",
                                                      @"total_pages": @"pageCount"
                                                      }];
    
    NSString *pathP =[NSString stringWithFormat:@"/3/account/%@/watchlist/tv",_currentUser.userID];
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:listMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:pathP
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    [_realm beginWriteTransaction];
    [[_user watchlistShows] removeAllObjects];
    [_realm commitWriteTransaction];
    [self getWatchlistShowLists];
}

-(void)getWatchlistShowLists{
    NSString *pathP =[NSString stringWithFormat:@"/3/account/%@/watchlist/tv",_currentUser.userID];
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64",/*add your api*/
                                      @"session_id":_session.sessionID,
                                      @"sort_by":@"created_at.asc",
                                      @"page":_currentPage
                                      };
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        _onePageWtchShowList=[[mappingResult array] firstObject];
        for(TVShow *tv in [_onePageWtchShowList showList]){
            TVShow *tvs = [[TVShow alloc]init];
            tvs.showID = [tv valueForKey:@"id"];
            tvs.name = [tv valueForKey:@"name"];
            tvs.rating = [tv valueForKey:@"vote_average"];
            tvs.posterPath = [tv valueForKey:@"poster_path"];
            tvs.backdropPath = [tv valueForKey:@"backdrop_path"];
            tvs.overview = [tv valueForKey:@"overview"];
            tvs.airDate = [dateFormatter dateFromString:[tv valueForKey:@"first_air_date"]];
            [_user addToWatchlistShows:[[RLTVShow alloc] initWithShow:tvs]];
        }
        if([[_onePageWtchShowList pageCount] isEqualToNumber:_currentPage] || [[_onePageWtchShowList pageCount] isEqualToNumber:[NSNumber numberWithInt:0]]){
            _currentPage=[NSNumber numberWithInt:1];
            [self setRatedShowLists];
        }
        
        else if([_onePageWtchShowList pageCount]>_currentPage){
            int i = [_currentPage intValue];
            _currentPage = [NSNumber numberWithInt:i+1];
            [self getWatchlistShowLists];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
}





-(void)setRatedShowLists{
    RKObjectMapping *listMapping = [RKObjectMapping mappingForClass:[ListMapping class]];
    [listMapping addAttributeMappingsFromDictionary:@{@"page": @"page",
                                                      @"results": @"showList",
                                                      @"total_pages": @"pageCount"
                                                      }];
    
    NSString *pathP =[NSString stringWithFormat:@"/3/account/%@/rated/tv",_currentUser.userID];
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:listMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:pathP
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    [_realm beginWriteTransaction];
    [[_user ratedShows] removeAllObjects];
    [_realm commitWriteTransaction];
    [self getRatedShowLists];
}

-(void)getRatedShowLists{
    NSString *pathP =[NSString stringWithFormat:@"/3/account/%@/rated/tv",_currentUser.userID];
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64",/*add your api*/
                                      @"session_id":_session.sessionID,
                                      @"sort_by":@"created_at.asc",
                                      @"page":_currentPage
                                      };
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        _onePageRateShowList=[[mappingResult array] firstObject];
        for(TVShow *tv in [_onePageRateShowList showList]){
            TVShow *tvs = [[TVShow alloc]init];
            tvs.showID = [tv valueForKey:@"id"];
            tvs.name = [tv valueForKey:@"name"];
            tvs.rating = [tv valueForKey:@"vote_average"];
            tvs.posterPath = [tv valueForKey:@"poster_path"];
            tvs.backdropPath = [tv valueForKey:@"backdrop_path"];
            tvs.overview = [tv valueForKey:@"overview"];
            tvs.airDate = [dateFormatter dateFromString:[tv valueForKey:@"first_air_date"]];
            [_user addToRatedShows:[[RLTVShow alloc] initWithShow:tvs]];
        }
        
        if([[_onePageRateShowList pageCount] isEqualToNumber:_currentPage] || [[_onePageRateShowList pageCount] isEqualToNumber:[NSNumber numberWithInt:0]]){
            _currentPage=[NSNumber numberWithInt:1];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        else if([_onePageRateShowList pageCount]>_currentPage){
            int i = [_currentPage intValue];
            _currentPage = [NSNumber numberWithInt:i+1];
            [self getRatedShowLists];
        }
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
