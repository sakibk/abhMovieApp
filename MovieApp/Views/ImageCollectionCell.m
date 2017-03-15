//
//  ImageCollectionTableViewCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 26/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "ImageCollectionCell.h"
#import "Movie.h"
#import "ImagePathUrl.h"
#import "SingleImageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <RestKit/RestKit.h>

NSString * const ImageCollectionCellIdentifier=@"ImageCollectionCellIdentivier";

@interface ImageCollectionCell ()

@property NSMutableArray<ImagePathUrl *> *allImagePaths;
@property ImagePathUrl *singleImage;
@property NSString *movieID;

@end

@implementation ImageCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
        [self.collectionView registerNib:[UINib nibWithNibName:@"SingleImageCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:SingleImageCellIdentifier];
    
    
}

-(void)setupWithMovie:(Movie *)singleMovie{
    _movieID = [NSString stringWithFormat:@"%@",singleMovie.movieID];
    
//    RKObjectMapping *imageMapping = [RKObjectMapping mappingForClass:[ImagePathUrl class]];
//    
//    [imageMapping addAttributeMappingsFromDictionary:@{@"file_path": @"posterPath"
//                                                       }];
//    imageMapping.assignsDefaultValueForMissingAttributes = YES;
//    
    NSString *pathP = [NSString stringWithFormat:@"%@%@%@", @"/3/movie/", _movieID,@"/images"];
    
//    RKResponseDescriptor *responseDescriptor =
//    [RKResponseDescriptor responseDescriptorWithMapping:imageMapping
//                                                 method:RKRequestMethodGET
//                                            pathPattern:pathP
//                                                keyPath:@"posters"
//                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
//    
//    NSLog(@"%@", pathP);
//    
//    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _allImagePaths = [[NSMutableArray alloc]initWithArray:mappingResult.array];
        [_collectionView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];

}

-(void)setupWithShow:(TVShow *)singleShow{
    _movieID = [NSString stringWithFormat:@"%@",singleShow.showID];
    
//    RKObjectMapping *imageMapping = [RKObjectMapping mappingForClass:[ImagePathUrl class]];
//    
//    [imageMapping addAttributeMappingsFromDictionary:@{@"file_path": @"posterPath"
//                                                       }];
//    imageMapping.assignsDefaultValueForMissingAttributes = YES;
//    
    NSString *pathP = [NSString stringWithFormat:@"%@%@%@", @"/3/tv/", _movieID,@"/images"];
//    
//    RKResponseDescriptor *responseDescriptor =
//    [RKResponseDescriptor responseDescriptorWithMapping:imageMapping
//                                                 method:RKRequestMethodGET
//                                            pathPattern:pathP
//                                                keyPath:@"posters"
//                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
//    
//    NSLog(@"%@", pathP);
//    
//    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _allImagePaths = [[NSMutableArray alloc]initWithArray:mappingResult.array];
        [_collectionView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _allImagePaths != nil ? [_allImagePaths count] : 0;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SingleImageCell *cell = (SingleImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:SingleImageCellIdentifier forIndexPath:indexPath];
    _singleImage=[_allImagePaths objectAtIndex:indexPath.row];

    [cell setupWithUrl:_singleImage.posterPath];

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.delegate openImageGallery];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return CGSizeMake(165.0, 165.0);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeZero;
}

@end
