//
//  SingleImageViewController.h
//  MovieApp
//
//  Created by Sakib Kurtic on 10/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagePathUrl.h"

@interface SingleImageViewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *galleryTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *imageCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@property (strong,nonatomic) NSMutableArray<ImagePathUrl *> *allImagePaths;
@property (strong, nonatomic) NSNumber *currentImageIndex;
@property (strong, nonatomic) NSString *galleryTitle;
@property BOOL isMovie;

@end
