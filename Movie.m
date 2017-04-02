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
#import "RLMCast.h"
#import "RLMCrew.h"
#import "RLMTrailerVideos.h"
#import "RLMListType.h"
#import "RLMReview.h"

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
    self.singleGenre =movie.singleGenre;
    self.posterPath=movie.posterPath;
    self.overview=movie.overview;
    self.userRate=movie.userRate;
    self.runtime = movie.runtime;
    NSMutableArray *gns = [[NSMutableArray alloc] init];
    for(RLMGenre *g in movie.genres)
        [gns addObject:[[Genre alloc] initWithGenre:g] ];
    self.genres = [[NSArray alloc] initWithArray:gns];
    self.videos = [[NSMutableArray alloc] init];
    for(RLMTrailerVideos *trv in movie.videos)
        [self.videos addObject:[[TrailerVideos alloc] initWithVideo:trv]];
    self.casts = [[NSMutableArray alloc] init];
    for(RLMCast *rcs in movie.movieCast)
        [self.casts addObject:[[Cast alloc]initWithCast:rcs]];
    self.crews = [[NSMutableArray alloc] init];
    for(RLMCrew *rcr in movie.movieCrew)
        [self.crews addObject:[[Crew alloc] initWithCrew:rcr]];
    self.listType = [[NSMutableArray alloc] init];
    for(RLMListType *lt in movie.listType)
        [self.listType addObject:[[ListType alloc] initWithRLMListType:lt]];
    self.reviews = [[NSMutableArray alloc] init];
    for(RLMReview *rw in movie.Reviews)
        [self.reviews addObject:[[Review alloc] initWithReview:rw]];
    return self;
}

- (id) initWithSnap:(NSDictionary *)movie{
    self=[super init];
    self.movieID = movie[@"id"];
    self.title = movie[@"title"];
    self.overview = movie[@"overview"];
    self.backdropPath = movie[@"backdrop_path"];
    self.posterPath = movie[@"poster_path"];
    self.rating = movie[@"vote_average"];
    self.ticketPrice = movie[@"ticket_price"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //EE - kod za naziv dana
    self.releaseDate = [dateFormatter dateFromString:movie[@"release_date"]];
    self.singleGenre =movie[@"genres"];
    
    self.playingDays = [[NSMutableArray alloc] init];
    
    for(int i=0; i<[movie[@"days_playing"] count];i++){
        if(![[movie[@"days_playing"] objectAtIndex:i] isKindOfClass:[NSNull class]]){
        DaysPlaying *pd = [[DaysPlaying alloc] init];
        pd.playingDate =[dateFormatter dateFromString:[[movie[@"days_playing"] objectAtIndex:i] valueForKeyPath:@"date"]];
        pd.playingDay=[[movie[@"days_playing"] objectAtIndex:i] valueForKeyPath:@"day"];
            pd.playingHours =[[NSMutableArray alloc] init];
            int l;
            for(l=0;l<[[[movie[@"days_playing"] objectAtIndex:i] valueForKeyPath:@"hours"] count];l++){
                Hours *hr = [[Hours alloc]init];
                hr.playingHour=[[[[movie[@"days_playing"] objectAtIndex:i] valueForKeyPath:@"hours"] objectAtIndex:l]valueForKey:@"time"];
                hr.playingHall=[[[[movie[@"days_playing"] objectAtIndex:i] valueForKeyPath:@"hours"] objectAtIndex:l]valueForKey:@"hall_id"];
                hr.hourID=[NSNumber numberWithInt:l];
                hr.playingDayID=[NSNumber numberWithInt:i];
                [pd.playingHours addObject:hr];
           }
        [self.playingDays addObject:pd];
    }
}
        return self;
}


@end
