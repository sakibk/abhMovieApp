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
    
    RKObjectMapping *crewMapping = [RKObjectMapping mappingForClass:[Crew class]];
    
    [crewMapping addAttributeMappingsFromDictionary:@{@"job": @"jobName",
                                                       @"name": @"crewName"
                                                       }];
    
    NSString *pathP =[NSString stringWithFormat:@"/3/movie/%@/credits",singleMovie.movieID];
    
    RKResponseDescriptor *crewResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:crewMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:pathP
                                                keyPath:@"crew"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    
    [[RKObjectManager sharedManager] addResponseDescriptor:crewResponseDescriptor];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _setupMovie = [[Movie alloc]init];
        singleMovie.crews=[[NSMutableArray alloc]initWithArray:mappingResult.array];
        _setupMovie=singleMovie;
        [self setupOverview];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
    }];
 
    
}

-(void)setupOverview{
    _rating.text = [NSString stringWithFormat:@"%@",_setupMovie.rating];
    _overview.text = _setupMovie.overview;
    _writersString = [[NSMutableString alloc]init];
    _producentString = [[NSMutableString alloc]init];
    for(Crew *sinCrew in _setupMovie.crews ){
        if([sinCrew.jobName isEqualToString:@"Director"]){
            _director.text=sinCrew.crewName;
        }
        else if([sinCrew.jobName isEqualToString:@"Writer"]){
            [_writersString appendString:sinCrew.crewName];
            [_writersString appendString:@", "];
        }
        else if ([sinCrew.jobName isEqualToString:@"Producer"]){
            [_producentString appendString:sinCrew.crewName];
            [_producentString appendString:@", "];
        }
    }
    if(![_writersString isEqualToString:@""]){
    [_writersString deleteCharactersInRange:NSMakeRange([_writersString length]-2, 2)];
    }
    if(![_producentString isEqualToString:@""]){
    [_producentString deleteCharactersInRange:NSMakeRange([_producentString length]-2, 2)];
    }
    _stars.text=_producentString;
    _writers.text=_writersString;
}

@end
