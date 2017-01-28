//
//  OverviewTableViewCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 26/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "OverviewCell.h"
#import <RestKit/RestKit.h>
#import "Crew.h"

NSString * const OverviewCellIdentifier=@"overviewCellIdentifier";

@implementation OverviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void) setupWithMovie :(Movie*) singleMovie{
    
    RKObjectMapping *genreMapping = [RKObjectMapping mappingForClass:[Crew class]];
    
    [genreMapping addAttributeMappingsFromDictionary:@{@"job": @"jobName",
                                                       @"name": @"crewName"
                                                       }];
    
    NSString *pathP =[NSString stringWithFormat:@"/3/movie/%@/credits",singleMovie.movieID];
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:genreMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:pathP
                                                keyPath:@"crew"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        singleMovie.crews=[[NSMutableArray alloc]initWithArray:mappingResult.array];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
    }];

    
    _rating.text = [NSString stringWithFormat:@"%@",singleMovie.rating];
    _overview.text = singleMovie.overview;
    _writersString = [[NSMutableString alloc]init];
    _producentString = [[NSMutableString alloc]init];
    for(Crew *sinCrew in singleMovie.crews ){
        if([sinCrew.jobName isEqualToString:@"Director"]){
            _director.text=sinCrew.crewName;
        }
        else if([sinCrew.jobName isEqualToString:@"Writer"]){
            [_writersString appendString:sinCrew.jobName];
            [_writersString appendString:@", "];
        }
        else if ([sinCrew.jobName isEqualToString:@"Producer"]){
            [_producentString appendString:sinCrew.jobName];
            [_producentString appendString:@", "];
        }
    }
    [_writersString deleteCharactersInRange:NSMakeRange([_writersString length]-2, 2)];
    [_producentString deleteCharactersInRange:NSMakeRange([_writersString length]-2, 2)];
    _stars.text=_producentString;
    _writers.text=_writersString;
}

@end
