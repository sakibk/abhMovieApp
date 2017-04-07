//
//  UserInfo.h
//  MovieApp
//
//  Created by Sakib Kurtic on 20/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "Token.h"
#import <Realm/Realm.h>
#import "Movie.h"
#import "TVShow.h"

@interface UserInfo : NSObject

@property (strong, nonatomic)NSNumber *userID;
@property (strong, nonatomic)NSString *name;
@property (strong, nonatomic)NSString *userName;
@property (strong, nonatomic)Token *session;
@property (strong, nonatomic)NSMutableArray<Movie*> *favoriteMovies;
@property (strong, nonatomic)NSMutableArray<TVShow*> *favoriteShows;
@property (strong, nonatomic)NSMutableArray<Movie*> *watchlistMovies;
@property (strong, nonatomic)NSMutableArray<TVShow*> *watchlistShows;
@property (strong, nonatomic)NSMutableArray<Movie*> *ratedMovies;
@property (strong, nonatomic)NSMutableArray<TVShow*> *ratedShows;


- (id) initWithObject:(UserInfo *)user;

+(NSDictionary*)elementToPropertyMappings;
+(RKObjectMapping *)responseMapping;
+(NSString*)pathPatternForRequestMethod:(RKRequestMethod)method;
+(NSArray*)additionalResponseDescriptors;
+(NSArray*)additionalRequestDescriptors;

@end
