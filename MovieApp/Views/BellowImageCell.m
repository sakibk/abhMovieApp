//
//  BellowImageTableViewCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 26/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "BellowImageCell.h"
#import "Genre.h"
#import <RestKit/RestKit.h>

NSString * const BellowImageCellIdentifier=@"bellowImageCellIdentifier";

@implementation BellowImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    RKObjectMapping *genreMapping = [RKObjectMapping mappingForClass:[Genre class]];
//    
//    [genreMapping addAttributeMappingsFromDictionary:@{@"id": @"genreID",
//                                                       @"name": @"genreName"
//                                                       }];
//    
//    RKResponseDescriptor *responseGenreDescriptor =
//    [RKResponseDescriptor responseDescriptorWithMapping:genreMapping
//                                                 method:RKRequestMethodGET
//                                            pathPattern:@"/3/genre/movie/list"
//                                                keyPath:@"genres"
//                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
//    
//    
//    [[RKObjectManager sharedManager] addResponseDescriptor:responseGenreDescriptor];
//    
//    NSDictionary *queryParameters = @{
//                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
//                                      };
//    
//    [[RKObjectManager sharedManager] getObjectsAtPath:@"/3/genre/movie/list" parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//        NSLog(@"%@", mappingResult.array);
//        _allGenres=[[NSMutableArray alloc]initWithArray:mappingResult.array];
//        
//        [_collectionView reloadData];
//    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
//    }];

}

-(void) setupWithMovie:(Movie *)singleMovie{
    _duration.text = [NSString stringWithFormat:@"%@ min",singleMovie.runtime];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd LLLL yyyy"];
    
    _releaseDate.text = [dateFormatter stringFromDate:singleMovie.releaseDate];

}

@end
