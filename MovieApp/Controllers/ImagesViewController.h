//
//  ImagesViewController.h
//  MovieApp
//
//  Created by Sakib Kurtic on 09/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "TVShow.h"

@interface ImagesViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *imageGalleryTitle;
@property (weak, nonatomic) IBOutlet UILabel *imageCount;


-(void)setupWithMovie:(Movie *)singleMovie;
-(void)setupWithShow:(TVShow *)singleShow;

@end
