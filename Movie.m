//
//  Movie.m
//  MovieApp
//
//  Created by Sakib Kurtic on 16/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "Movie.h"
#import "TVMovie.h"
#import "RLMovie.h"

@implementation Movie


// Here you need to add all Movie properties that needs to be mapped.
+ (NSDictionary*)elementToPropertyMappings {
    
    NSDictionary *dict = @{
                                      @"title": @"title",
                                      @"vote_average": @"rating",
                                      @"poster_path": @"posterPath",
                                      @"release_date": @"releaseDate",
                                      @"id": @"movieID",
                                      @"runtime": @"runtime",
                                      @"backdrop_path": @"backdropPath",
                                      @"overview": @"overview",
                                      @"genre_ids": @"genreIds"
                                      };
    return dict;
}

+(RKObjectMapping*)responseMapping {
    // Create an object mapping.
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Movie class]];
    [mapping addPropertyMapping:[RKRelationshipMapping
                                 relationshipMappingFromKeyPath:@"genres"
                                 toKeyPath:@"genreSet"
                                 withMapping:[Genre responseMapping]]];
    [mapping addAttributeMappingsFromDictionary:[self elementToPropertyMappings]];
    mapping.assignsDefaultValueForMissingAttributes = NO;
    
    return mapping;
}

// Here you need to add paths for every method.
+(NSString*)pathPatternForRequestMethod:(RKRequestMethod)method{
    NSString *path;
    switch (method) {
        case RKRequestMethodGET:
            path = @"/3/movie/:id";
            break;
        default:
            break;
    }
    return path;
}

// Here you add additional response descriptors if you need them.
// e.g. If you need to map again Movie model from another path with GET method.
+ (NSArray *)additionalResponseDescriptors{
    return @[[RKResponseDescriptor responseDescriptorWithMapping:[Movie responseMapping] method:RKRequestMethodGET pathPattern:@"/3/discover/movie"
                                                         keyPath:@"results"
                                                     statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)],
             [RKResponseDescriptor responseDescriptorWithMapping:[Movie responseMapping] method:RKRequestMethodGET pathPattern:@"/3/movie/upcoming"
                                                         keyPath:@"results"
                                                     statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]
             ];
    
}

// Here you add additional response descriptors if you need them.
// e.g. If you need to map again Movie model from another path with GET method.
+ (NSArray *)additionalRequestDescriptors{
    return nil;
    
}


//- (NSString *)description
//{
//    return [NSString stringWithFormat:@"MovieId: %@, Title: %@, Rating: %@, Poster path: %@, ReleaseDate: %@ , BackdropPath: %@",self.movieID, self.title, self.rating, self.posterPath, self.releaseDate, self.backdropPath];
//}

-(void)setupWithTVMovie:(TVMovie *)singleObject{
    self.movieID=singleObject.TVMovieID;
    self.backdropPath=singleObject.backdropPath;
    self.releaseDate=singleObject.releaseDate;
    self.genreIds=singleObject.genreIds;
    self.title=singleObject.title;
    self.rating=singleObject.rating;
    self.posterPath=singleObject.posterPath;
    self.overview=singleObject.overview;
    
}

- (id) initWithObject:(RLMovie *)movie{
    self=[super init];
    
    self.movieID=movie.movieID;
    self.backdropPath=movie.backdropPath;
    self.releaseDate=movie.releaseDate;
    self.title=movie.title;
    self.rating=movie.rating;
    self.posterPath=movie.posterPath;
    self.overview=movie.overview;
    self.userRate=movie.userRate;
    return self;
}

@end
