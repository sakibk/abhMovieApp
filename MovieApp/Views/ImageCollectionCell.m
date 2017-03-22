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
#import "ApiKey.h"
#import "ConnectivityTest.h"
#import "RLMovie.h"
#import "RLTVShow.h"

NSString * const ImageCollectionCellIdentifier=@"ImageCollectionCellIdentivier";

@interface ImageCollectionCell ()

@property NSMutableArray<ImagePathUrl *> *allImagePaths;
@property ImagePathUrl *singleImage;
@property NSString *movieID;
@property BOOL isConnected;
@property RLMRealm *realm;

@end

@implementation ImageCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SingleImageCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:SingleImageCellIdentifier];
    _realm = [RLMRealm defaultRealm];
    _isConnected = [ConnectivityTest isConnected];
}

-(void) setupWithMovie:(Movie *)singleMovie{
    if(_isConnected)
        [self getMovieImages:singleMovie];
    else
        [self getStoredMovieImages:singleMovie];
}

-(void)getStoredMovieImages:(Movie *)singleMovie{
    RLMResults<RLMovie*> *mvs = [RLMovie objectsWhere:@"movieID = %@",singleMovie.movieID];
    RLMovie *mv = mvs.firstObject;
    _allImagePaths = [[NSMutableArray alloc] init];
    if(mv.images.firstObject!=nil){
        for(RLMImagePaths *image in mv.images)
            [_allImagePaths addObject:[[ImagePathUrl alloc] initWithPaths:image]];
        [self.collectionView reloadData];
    }
    else{
        //connect to proceede
    }
}

-(void)setStoredMovieImages:(NSNumber*)movieID{
    RLMResults<RLMovie*> *mvs = [RLMovie objectsWhere:@"movieID = %@",movieID];
    RLMovie *mv = mvs.firstObject;
    if(mv.images.firstObject==nil){
            [_realm beginWriteTransaction];
        for(ImagePathUrl *image in _allImagePaths){
            [mv.images addObject:[[RLMImagePaths alloc]initWithPaths:image]];
        }
        [_realm addOrUpdateObject:mv];
        [_realm commitWriteTransaction];
    }
    
}


-(void)getMovieImages:(Movie *)singleMovie{
    _movieID = [NSString stringWithFormat:@"%@",singleMovie.movieID];
    
    NSString *pathP = [NSString stringWithFormat:@"%@%@%@", @"/3/movie/", _movieID,@"/images"];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": [ApiKey getApiKey]/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _allImagePaths = [[NSMutableArray alloc]initWithArray:mappingResult.array];
        [self setStoredMovieImages:singleMovie.movieID];
        [_collectionView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
    
}

-(void) setupWithShow:(TVShow *)singleShow{
    if(_isConnected)
        [self getShowImages:singleShow];
    else
        [self getStoredShowImages:singleShow];
}

-(void)getStoredShowImages:(TVShow *)singleShow{
    RLMResults<RLTVShow*> *tvs = [RLTVShow objectsWhere:@"showID = %@",singleShow.showID];
    RLTVShow *tv = tvs.firstObject;
    if(tv.images.firstObject!=nil){
        _allImagePaths = [[NSMutableArray alloc] init];
        for(RLMImagePaths *image in tv.images)
            [_allImagePaths addObject:[[ImagePathUrl alloc]initWithPaths:image]];
        [self.collectionView reloadData];
    }
    else{
        //connect to proceede
    }
}

-(void)setStoredShowImages:(NSNumber*)showID{
    RLMResults<RLTVShow*> *tvs = [RLTVShow objectsWhere:@"showID = %@",showID];
    RLTVShow *tv = tvs.firstObject;
    if(tv.showCast.firstObject==nil){
        [_realm beginWriteTransaction];
        for(ImagePathUrl *image in _allImagePaths)
            [tv.images addObject:[[RLMImagePaths alloc]initWithPaths:image]];
        [_realm addOrUpdateObject:tv];
        [_realm commitWriteTransaction];
    }
    
}


-(void)getShowImages:(TVShow *)singleShow{
    _movieID = [NSString stringWithFormat:@"%@",singleShow.showID];
    
    NSString *pathP = [NSString stringWithFormat:@"%@%@%@", @"/3/tv/", _movieID,@"/images"];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": [ApiKey getApiKey]/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _allImagePaths = [[NSMutableArray alloc]initWithArray:mappingResult.array];
        [self setStoredShowImages:singleShow.showID];
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
