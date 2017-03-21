//
//  Movie.h
//  MovieApp
//
//  Created by Sakib Kurtic on 16/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Genre.h"
#import "Crew.h"
#import <Realm/Realm.h>
#import "TVMovie.h"
#import <RestKit/RestKit.h>
@class RLMovie;
#import "ListType.h"

@interface Movie : NSObject

@property (strong, nonatomic) NSNumber *movieID;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *posterPath;
@property (strong, nonatomic) NSNumber *rating;
@property (strong, nonatomic) NSNumber *runtime;
@property (strong, nonatomic) NSDate *releaseDate;
@property (strong, nonatomic) NSString *backdropPath;
@property (strong, nonatomic) NSString *singleGenre;
@property (strong, nonatomic) NSString *overview;
@property (strong, nonatomic) NSNumber *userRate;
@property (strong, nonatomic) NSArray<Genre *> *genres;
@property (strong, nonatomic) NSMutableArray<Crew *> *crews;
@property (strong, nonatomic) NSSet<Genre *> *genreSet;
@property (strong, nonatomic) NSArray<NSNumber *> *genreIds;
@property (strong, nonatomic) NSMutableArray<ListType*> *listType;

- (id) initWithObject:(RLMovie *)movie;
-(void)setupWithTVMovie:(TVMovie *)singleObject;

+(NSDictionary*)elementToPropertyMappings;
+(RKObjectMapping *)responseMapping;
+(NSString*)pathPatternForRequestMethod:(RKRequestMethod)method;
+(NSArray*)additionalResponseDescriptors;
+(NSArray*)additionalRequestDescriptors;

@end
