//
//  TVShow.h
//  MovieApp
//
//  Created by Sakib Kurtic on 16/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Genre.h"
#import <Realm/Realm.h>
#import "Cast.h"
#import "Crew.h"
#import "Season.h"
#import "TVMovie.h"
@class RLTVShow;
#import "ListType.h"

@interface TVShow : NSObject

@property (strong, nonatomic) NSNumber *showID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *posterPath;
@property (strong, nonatomic) NSNumber *rating;
@property (strong, nonatomic) NSDate *firstAirDate;
@property (strong, nonatomic) NSDate *lastAirDate;
@property (strong, nonatomic) NSDate *airDate;
@property (strong, nonatomic) NSString *backdropPath;
@property (strong, nonatomic) NSArray<Genre *> *genres;
@property (strong, nonatomic) NSString *singleGenre;
@property (strong, nonatomic) NSString *overview;
@property (strong, nonatomic) NSNumber *userRate;
@property (nonatomic) BOOL inProduction;
@property (strong, nonatomic) NSMutableArray<Crew *> *crews;
@property (strong, nonatomic) NSSet<Genre *> *genreSet;
@property (strong, nonatomic) NSArray<NSNumber *> *genreIds;
@property (strong, nonatomic) NSArray <NSNumber *> *runtime;
@property (strong, nonatomic) NSMutableArray<Season *> *seasons;
@property (strong, nonatomic) NSMutableArray<Cast*> *casts;
@property (strong, nonatomic) NSNumber *seasonCount;
@property (strong, nonatomic) NSMutableArray<ListType *> *listType;

- (id) initWithObject:(RLTVShow *)show;
-(void)setupWithTVMovie:(TVMovie *)singleObject;

+(NSDictionary*)elementToPropertyMappings;
+(RKObjectMapping *)responseMapping;
+(NSString*)pathPatternForRequestMethod:(RKRequestMethod)method;
+(NSArray*)additionalResponseDescriptors;
+(NSArray*)additionalRequestDescriptors;
@end
