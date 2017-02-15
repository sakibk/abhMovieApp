//
//  ImagesViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 09/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "ImagesViewController.h"
#import "ImageCell.h"
#import "ImagePathUrl.h"
#import <RestKit/RestKit.h>
#import "SingleImageViewController.h"

@interface ImagesViewController ()

@property NSMutableArray<ImagePathUrl *> *allImagePaths;
@property ImagePathUrl *singleImage;
@property NSString *movieID;
@property NSString *galleryTitle;
@end

@implementation ImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [self setNavBarTitle];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ImageCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:imageCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavBarTitle{
    self.navigationItem.title =@"Movies";
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor lightGrayColor]];
}


-(void)setupWithMovie:(Movie *)singleMovie{
    _movieID = [NSString stringWithFormat:@"%@",singleMovie.movieID];
    
//    RKObjectMapping *imageMapping = [RKObjectMapping mappingForClass:[ImagePathUrl class]];
//    
//    [imageMapping addAttributeMappingsFromDictionary:@{@"file_path": @"posterPath"
//                                                       }];
//    imageMapping.assignsDefaultValueForMissingAttributes = YES;
    
    NSString *pathP = [NSString stringWithFormat:@"%@%@%@", @"/3/movie/", _movieID,@"/images"];
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
        [self setupMovieLabels:singleMovie.title];
        [_collectionView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
    }];
    
}

-(void)setupMovieLabels:(NSString*)movieTitle{
    _imageGalleryTitle.text = [NSString stringWithFormat:@"Image gallery: %@",movieTitle];
    _imageCount.text = [NSString stringWithFormat:@"%lu images",(unsigned long)[_allImagePaths count]];
    _galleryTitle=movieTitle;
}

-(void)setupWithShow:(TVShow *)singleShow{
    
    _movieID = [NSString stringWithFormat:@"%@",singleShow.showID];
    NSString *pathP = [NSString stringWithFormat:@"%@%@%@", @"/3/tv/", _movieID,@"/images"];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _allImagePaths = [[NSMutableArray alloc]initWithArray:mappingResult.array];
        [self setupShowLabels:singleShow.name];
        [_collectionView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
    }];
    
}
-(void)setupShowLabels:(NSString*)showTitle{
    _imageGalleryTitle.text = [NSString stringWithFormat:@"Image gallery: %@",showTitle];
    _imageCount.text = [NSString stringWithFormat:@"%lu images",(unsigned long)[_allImagePaths count]];
    _galleryTitle=showTitle;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _allImagePaths != nil ? [_allImagePaths count] : 0;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImageCell *cell = (ImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:imageCellIdentifier forIndexPath:indexPath];
    _singleImage=[_allImagePaths objectAtIndex:indexPath.row];
    
    [cell setupWithUrl:_singleImage.posterPath];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return CGSizeMake(self.view.frame.size.width/3, self.view.frame.size.width/3);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"SingleImageIdentifier" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"SingleImageIdentifier"]){
        SingleImageViewController *singleImage = segue.destinationViewController;
        NSIndexPath *indexPath = [self.collectionView.indexPathsForSelectedItems objectAtIndex:0];
        singleImage.allImagePaths = _allImagePaths;
        singleImage.currentImageIndex=[NSNumber numberWithLong:indexPath.row];
        singleImage.galleryTitle=_galleryTitle;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
