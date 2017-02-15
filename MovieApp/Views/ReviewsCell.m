//
//  ReviewsCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 27/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "ReviewsCell.h"
#import <RestKit/RestKit.h>

NSString *const reviewsCellIdentifier = @"ReviewsCellIdentifier";

@implementation ReviewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _tableView.delegate=self;
    _tableView.dataSource=self;

    [self.tableView registerNib:[UINib nibWithNibName:@"SingleReviewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:singleReviewCellIdentifier];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _allReviews != nil ? [_allReviews count] : 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor blackColor]];
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SingleReviewCell *cell =(SingleReviewCell *)[tableView dequeueReusableCellWithIdentifier:singleReviewCellIdentifier forIndexPath:indexPath];
    _singleReview=[_allReviews objectAtIndex:indexPath.row];
    [cell setupWithReview:_singleReview]; // Configure the cell...
    
    return cell;
}

-(void) setupWithMovieID:(NSNumber *)singleMovieID{
    
    RKObjectMapping *reviewMapping = [RKObjectMapping mappingForClass:[Review class]];
    
    [reviewMapping addAttributeMappingsFromDictionary:@{@"author": @"author",
                                                      @"content": @"text"
                                                      }];
    reviewMapping.assignsDefaultValueForMissingAttributes = YES;
    
    NSString *pathP = [NSString stringWithFormat:@"%@%@%@", @"/3/movie/", singleMovieID,@"/reviews"];
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:reviewMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:pathP
                                                keyPath:@"results"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _allReviews=[[NSMutableArray alloc]initWithArray:mappingResult.array];
        
        
        [_tableView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
    }];
}

-(void) setupWithShowID:(NSNumber *)singleTVShowID{
    
    RKObjectMapping *reviewMapping = [RKObjectMapping mappingForClass:[Review class]];
    
    [reviewMapping addAttributeMappingsFromDictionary:@{@"author": @"author",
                                                        @"content": @"text"
                                                        }];
    reviewMapping.assignsDefaultValueForMissingAttributes = YES;
    
    NSString *pathP = [NSString stringWithFormat:@"%@%@%@", @"/3/tv/", singleTVShowID,@"/reviews"];
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:reviewMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:pathP
                                                keyPath:@"results"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _allReviews=[[NSMutableArray alloc]initWithArray:mappingResult.array];
        
        
        [_tableView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
    }];
}

@end
