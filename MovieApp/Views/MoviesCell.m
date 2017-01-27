//
//  MoviesCollectionViewCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 17/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "MoviesCell.h"
#import "Movie.h"
#import "Genre.h"
#import <RestKit/RestKit.h>

NSString* const identifier= @"MovieCellIdentifier";

@implementation MoviesCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void) setupMovieCell:(Movie *) singleMovie{
    RKObjectMapping *genreMapping = [RKObjectMapping mappingForClass:[Genre class]];
    
    [genreMapping addAttributeMappingsFromDictionary:@{@"id": @"genreID",
                                                       @"name": @"genreName"
                                                       }];
    NSNumber *gid = singleMovie.genreIds.firstObject;
    
    NSString *pathP = [NSString stringWithFormat:@"%@%@", @"/3/genre/", gid];
    genreMapping.assignsDefaultValueForMissingAttributes=YES;
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:genreMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:pathP
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _singleGerne=[mappingResult firstObject];
        NSLog(@"%@",_singleGerne.genreName);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
    }];
    
    
    NSDate *releaseYear = singleMovie.releaseDate;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:releaseYear];
    NSInteger year = [components year];
    _title.text = [NSString stringWithFormat:@"%@(%ld)",singleMovie.title,(long)year];
    
    _genreLabel.text=_singleGerne.genreName;
}

@end
