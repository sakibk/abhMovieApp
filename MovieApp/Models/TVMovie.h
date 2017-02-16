//
//  MultiObject.h
//  MovieApp
//
//  Created by Sakib Kurtic on 10/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TVMovie : NSObject

@property (strong, nonatomic) NSNumber *TVMovieID;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *posterPath;
@property (strong, nonatomic) NSNumber *rating;
@property (strong, nonatomic) NSNumber *runtime;
@property (strong, nonatomic) NSDate *releaseDate;
@property (strong, nonatomic) NSString *backdropPath;
@property (strong, nonatomic) NSString *singleGenre;
@property (strong, nonatomic) NSString *overview;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *firstAirDate;
@property (strong, nonatomic) NSDate *lastAirDate;
@property (strong, nonatomic) NSDate *airDate;
@property (strong, nonatomic) NSString *mediaType;
@property (strong, nonatomic) NSArray<NSNumber *> *genreIds;

-(BOOL)isMovie;

@end
