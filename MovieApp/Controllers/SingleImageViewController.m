//
//  SingleImageViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 10/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "SingleImageViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SingleImageViewController ()

@end

@implementation SingleImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedLeft:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft ];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedRight:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight ];
    [self.view addGestureRecognizer:swipeRight];
    [self setupView];
}

-(void)setupView{
    _galleryTitleLabel.text=[NSString stringWithFormat:@"  %@",_galleryTitle];
    [self setupPicture];
}

-(void)setNavBarTitle{
    if(_isMovie){
        self.navigationItem.title =@"Movie";
    }
    else{
        self.navigationItem.title =@"TV Show";
    }
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor lightGrayColor]];
}

-(void)setupPicture{
    _imageCountLabel.text =[NSString stringWithFormat:@"  %d of %lu",[_currentImageIndex intValue]+1,(unsigned long)[_allImagePaths count]];
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://image.tmdb.org/t/p/w780/",[_allImagePaths objectAtIndex:[_currentImageIndex intValue]].posterPath]]placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",_currentImageIndex,@".png"]]];
}

- (IBAction)swipedLeft:(UISwipeGestureRecognizer *)recognizer
{
    if([_currentImageIndex longValue] == [_allImagePaths count]-1){
        _currentImageIndex=0;
    }
    else{
        NSNumber *curentNumber = [NSNumber numberWithInt:[_currentImageIndex intValue] + 1];
        _currentImageIndex=curentNumber;
    }
    [self setupPicture];
}

- (IBAction)swipedRight:(UISwipeGestureRecognizer *)recognizer
{
    if([_currentImageIndex longValue] == 0){
        _currentImageIndex= [NSNumber numberWithLong:[_allImagePaths count]-1];
    }
    else{
        NSNumber *curentNumber = [NSNumber numberWithInt:[_currentImageIndex intValue] - 1];
        _currentImageIndex=curentNumber;
    }
    [self setupPicture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
