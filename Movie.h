//
//  Movie.h
//  MovieApp
//
//  Created by Sakib Kurtic on 16/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Genre.h"
#import <Realm/Realm.h>

@interface Movie : NSObject

@property (strong, nonatomic) NSNumber *movieID;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *posterPath;
@property (strong, nonatomic) NSNumber *rating;
@property (strong, nonatomic) NSDate *releaseDate;
@property (strong, nonatomic) NSString *backdropPath;
@property (strong, nonatomic) NSString *singleGenre;
@property (strong, nonatomic) NSArray<Genre *> *genres;
@property (strong, nonatomic) NSArray<NSNumber *> *genreIds;

@end
