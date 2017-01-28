//
//  CastCollectionCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 27/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "CastCollectionCell.h"
#import "SingleCastCell.h"

NSString *const castCollectionCellIdentifier=@"CastCollectionCellIdentifier";

@implementation CastCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _collectionView.delegate=self;
    _collectionView.dataSource=self;

    [self.collectionView registerNib:[UINib nibWithNibName:@"SingleCastCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:singleCastCellIdentifier];
}


-(void) setupWithMovie:(Movie *)singleMovie{
    
    _movieID = [NSString stringWithFormat:@"%@",singleMovie.movieID];
    
    RKObjectMapping *castMapping = [RKObjectMapping mappingForClass:[Cast class]];
    
    [castMapping addAttributeMappingsFromDictionary:@{@"cast_id": @"castID",
                                                       @"character": @"castRoleName",
                                                       @"id": @"castWithID",
                                                       @"name": @"castName",
                                                       @"profile_path": @"castImagePath"
                                                       }];
    castMapping.assignsDefaultValueForMissingAttributes = YES;
    
    NSString *pathP = [NSString stringWithFormat:@"%@%@%@", @"/3/movie/", _movieID,@"/credits"];
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:castMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:pathP
                                                keyPath:@"cast"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _allCasts=[[NSMutableArray alloc]initWithArray:mappingResult.array];
        
        
        [_collectionView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
    }];

    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _allCasts != nil ? [_allCasts count] : 0;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SingleCastCell *cell = (SingleCastCell *)[collectionView dequeueReusableCellWithReuseIdentifier:singleCastCellIdentifier forIndexPath:indexPath];
    _singleCast=[_allCasts objectAtIndex:indexPath.row];
    
    [cell setupWithCast:_singleCast];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return CGSizeMake(160.0, 298.0);
}


@end
