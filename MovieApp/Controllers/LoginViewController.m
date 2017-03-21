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
#import "ListMappingTV.h"
#import "ApiKey.h"
#import "ConnectivityTest.h"

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
@property ListMappingTV *onePageFavShowList;
@property ListMappingTV *onePageWtchShowList;
@property ListMappingTV *onePageRateShowList;

@property RLMArray<RLUserInfo*> <RLUserInfo> *users;

@property RLUserInfo *user;

@property BOOL isConnected;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setVariables];
    [self setLoginView];
    if(_isConnected)
        [self getToken];
    
}

-(void)setVariables{
    _currentPage =[NSNumber numberWithInt:1];
    _onePageFavMovieList = [[ListMapping alloc]init];
    _onePageWtchMovieList = [[ListMapping alloc]init];
    _onePageRateMovieList = [[ListMapping alloc]init];
    _onePageFavShowList = [[ListMappingTV alloc]init];
    _onePageWtchShowList = [[ListMappingTV alloc]init];
    _onePageRateShowList = [[ListMappingTV alloc]init];
    _user = [[RLUserInfo alloc] init];
    _realm = [RLMRealm defaultRealm];
    _isConnected = [ConnectivityTest isConnected];
}

-(IBAction)sessionPressed:(id)sender{
    if(_isConnected){
    if(self.emailEditor.text!=nil && ![self.emailEditor.text isEqualToString:@""] && self.passwordEditor.text!=nil && ![self.passwordEditor.text isEqualToString:@""]){
        [self getTokenForSesion];
    }
    else{
        [self postStatusError:@"Enter Your Credentials"];
    }}
    else
        [self postStatusError:@"Please connect to proceed"];
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
    
    [self.passwordEditor setValue:[UIColor lightGrayColor]
                       forKeyPath:@"_placeholderLabel.textColor"];
    [self.emailEditor setValue:[UIColor lightGrayColor]
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

-(void)getToken{
    
    NSString *pathP = @"/3/authentication/token/new";
    
    
    NSDictionary *queryParameters = @{
                                      @"api_key": [ApiKey getApiKey],/*add your api*/
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


-(void)getTokenForSesion{
    NSString *token=_token.requestToken;
    
    NSString *pathP = @"/3/authentication/token/validate_with_login";
    
    
    NSDictionary *queryParameters = @{
                                      @"api_key": [ApiKey getApiKey],/*add your api*/
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

-(void)getSesion{
    NSString *token=_sessionToken.requestToken;
    
    NSString *pathP = @"/3/authentication/session/new";
    
    
    NSDictionary *queryParameters = @{
                                      @"api_key": [ApiKey getApiKey],/*add your api*/
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

-(void)getAccountDetails{
    
    NSString *pathP = @"/3/account";
    
    
    NSDictionary *queryParameters = @{
                                      @"api_key": [ApiKey getApiKey],/*add your api*/
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
                                    @"apiKey": [ApiKey getApiKey]
                                    };
        [[NSUserDefaults standardUserDefaults] setObject:loginData forKey:@"SessionCredentials"];
        [self getFavoriteMovieLists];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
        [self postStatusError:@"Wrong Api key or request token"];
    }];
}


-(void)getFavoriteMovieLists{
    [_realm beginWriteTransaction];
    [[_user favoriteMovies] removeAllObjects];
    [_realm commitWriteTransaction];
    
    NSString *pathP =[NSString stringWithFormat:@"/3/account/%@/favorite/movies",_currentUser.userID];
    NSDictionary *queryParameters = @{
                                      @"api_key": [ApiKey getApiKey],/*add your api*/
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
            [_user addToFavoriteMovies:[[RLMovie alloc] initWithMovie:mv]];
        }
        
        if([[_onePageFavMovieList pageCount] isEqualToNumber:_currentPage] || [[_onePageFavMovieList pageCount] isEqualToNumber:[NSNumber numberWithInt:0]]){
            _currentPage=[NSNumber numberWithInt:1];
            [self getWatchlistMovieLists];
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

-(void)getWatchlistMovieLists{
    
    [_realm beginWriteTransaction];
    [[_user watchlistMovies] removeAllObjects];
    [_realm commitWriteTransaction];
    
    NSString *pathP =[NSString stringWithFormat:@"/3/account/%@/watchlist/movies",_currentUser.userID];
    NSDictionary *queryParameters = @{
                                      @"api_key": [ApiKey getApiKey],/*add your api*/
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
            [_user addToWatchlistMovies:[[RLMovie alloc] initWithMovie:mv]];
        }
        if([[_onePageWtchMovieList pageCount] isEqualToNumber:_currentPage] || [[_onePageWtchMovieList pageCount] isEqualToNumber:[NSNumber numberWithInt:0]]){
            _currentPage=[NSNumber numberWithInt:1];
            [self getRatedMovieLists];
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

-(void)getRatedMovieLists{
    
    [_realm beginWriteTransaction];
    [[_user ratedMovies] removeAllObjects];
    [_realm commitWriteTransaction];
    
    NSString *pathP =[NSString stringWithFormat:@"/3/account/%@/rated/movies",_currentUser.userID];
    NSDictionary *queryParameters = @{
                                      @"api_key": [ApiKey getApiKey],/*add your api*/
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
            [_user addToRatedMovies:[[RLMovie alloc] initWithMovie:mv]];
        }
        if([[_onePageRateMovieList pageCount] isEqualToNumber:_currentPage] || [[_onePageRateMovieList pageCount] isEqualToNumber:[NSNumber numberWithInt:0]]){
            _currentPage=[NSNumber numberWithInt:1];
            [self getFavoriteShowLists];
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

-(void)getFavoriteShowLists{
    
    [_realm beginWriteTransaction];
    [[_user favoriteShows] removeAllObjects];
    [_realm commitWriteTransaction];
    
    NSString *pathP =[NSString stringWithFormat:@"/3/account/%@/favorite/tv",_currentUser.userID];
    NSDictionary *queryParameters = @{
                                      @"api_key": [ApiKey getApiKey],/*add your api*/
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
            [_user addToFavoriteShows:[[RLTVShow alloc] initWithShow:tv]];
        }
        if([[_onePageFavShowList pageCount] isEqualToNumber:_currentPage] || [[_onePageFavShowList pageCount] isEqualToNumber:[NSNumber numberWithInt:0]]){
            _currentPage=[NSNumber numberWithInt:1];
            [self getWatchlistShowLists];
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

-(void)getWatchlistShowLists{
    
    [_realm beginWriteTransaction];
    [[_user watchlistShows] removeAllObjects];
    [_realm commitWriteTransaction];
    
    NSString *pathP =[NSString stringWithFormat:@"/3/account/%@/watchlist/tv",_currentUser.userID];
    NSDictionary *queryParameters = @{
                                      @"api_key": [ApiKey getApiKey],/*add your api*/
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
            [_user addToWatchlistShows:[[RLTVShow alloc] initWithShow:tv]];
        }
        if([[_onePageWtchShowList pageCount] isEqualToNumber:_currentPage] || [[_onePageWtchShowList pageCount] isEqualToNumber:[NSNumber numberWithInt:0]]){
            _currentPage=[NSNumber numberWithInt:1];
            [self getRatedShowLists];
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

-(void)getRatedShowLists{
    
    [_realm beginWriteTransaction];
    [[_user ratedShows] removeAllObjects];
    [_realm commitWriteTransaction];
    
    NSString *pathP =[NSString stringWithFormat:@"/3/account/%@/rated/tv",_currentUser.userID];
    NSDictionary *queryParameters = @{
                                      @"api_key": [ApiKey getApiKey],/*add your api*/
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
            [_user addToRatedShows:[[RLTVShow alloc] initWithShow:tv]];
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
