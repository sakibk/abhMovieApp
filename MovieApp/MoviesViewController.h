//
//  MoviesTableViewController.h
//  MovieApp
//
//  Created by Sakib Kurtic on 16/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef NS_ENUM(NSInteger, MediaListType) {
//    MostPopular,
//    HighestRated,
//    Latest,
//    OnAir,
//    AiringToday
//};

@interface MoviesViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,assign) BOOL isMovie;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;


@end
