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
#import "ApiKey.h"
#import "RLMovie.h"
#import <Realm/Realm.h>
#import "RLMImagePaths.h"
#import "RLTVShow.h"
#import "ConnectivityTest.h"

@interface ImagesViewController ()

@property NSMutableArray<ImagePathUrl *> *allImagePaths;
@property ImagePathUrl *singleImage;
@property NSString *movieID;
@property NSString *galleryTitle;
@property BOOL isMovie;
@property BOOL isConnected;
@property RLMRealm *realm;

@end

@implementation ImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [self setNavBarTitle];
    _isConnected = [ConnectivityTest isConnected];
    _realm = [RLMRealm defaultRealm];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ImageCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:imageCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavBarTitle{
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor lightGrayColor]];
}

-(void) setupWithMovie:(Movie *)singleMovie{
    _isConnected = [ConnectivityTest isConnected];
    if(_isConnected)
        [self getMovieImages:singleMovie];
    else
        [self getStoredMovieImages:singleMovie];
}

-(void)getStoredMovieImages:(Movie *)singleMovie{
    [self setupMovieLabels:singleMovie.title];
    RLMResults<RLMovie*> *mvs = [RLMovie objectsWhere:@"movieID = %@",singleMovie.movieID];
    RLMovie *mv = mvs.firstObject;
    if(mv.images.firstObject!=nil){
        _allImagePaths = [[NSMutableArray alloc] init];
        for(RLMImagePaths *image in mv.images)
            [_allImagePaths addObject:[[ImagePathUrl alloc] initWithPaths:image]];
        [self.collectionView reloadData];
    }
    else{
        //reconnect
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
        [self setupMovieLabels:singleMovie.title];
        [self setStoredMovieImages:singleMovie.movieID];
        [_collectionView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
    
}

-(void)setupMovieLabels:(NSString*)movieTitle{
    self.navigationItem.title =@"Movies";
    _imageGalleryTitle.text = [NSString stringWithFormat:@"  Image gallery: %@",movieTitle];
    if([_allImagePaths count]){
    _imageCount.text = [NSString stringWithFormat:@"  %lu images",(unsigned long)[_allImagePaths count]];
    }
    else{
        _imageCount.text = [NSString stringWithFormat:@"  %d images",0];
    }
    _galleryTitle=movieTitle;
    _isMovie=YES;
}

-(void) setupWithShow:(TVShow *)singleShow{
    _isConnected = [ConnectivityTest isConnected];
    if(_isConnected)
        [self getShowImages:singleShow];
    else
        [self getStoredShowImages:singleShow];
}

-(void)getStoredShowImages:(TVShow *)singleShow{
    [self setupShowLabels:singleShow.name];
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
    if(tv.images.firstObject==nil){
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
        [self setupShowLabels:singleShow.name];
        [_collectionView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
    
}
-(void)setupShowLabels:(NSString*)showTitle{
    self.navigationItem.title =@"TV Show";
    _imageGalleryTitle.text = [NSString stringWithFormat:@"  Image gallery: %@",showTitle];
    if([_allImagePaths count]){
        _imageCount.text = [NSString stringWithFormat:@"  %lu images",(unsigned long)[_allImagePaths count]];
    }
    else{
        _imageCount.text = [NSString stringWithFormat:@"  %d images",0];
    }
    
    _galleryTitle=showTitle;
    _isMovie=NO;
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
        singleImage.isMovie=_isMovie;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
