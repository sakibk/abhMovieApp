//
//  TrailerViewController.h
//  MovieApp
//
//  Created by Sakib Kurtic on 09/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTplayerView.h"
#import "TrailerVideos.h"

@interface TrailerViewController : UIViewController<YTPlayerViewDelegate>
@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;

@property(nonatomic, weak) IBOutlet UIButton *playButton;
@property(nonatomic, weak) IBOutlet UIButton *pauseButton;

@property(nonatomic, weak) IBOutlet UITextView *statusTextView;

@property(nonatomic, weak) IBOutlet UISlider *slider;

- (IBAction)onSliderChange:(id)sender;

- (IBAction)buttonPressed:(id)sender;

-(void)setupWithMovieID:(NSNumber *)movieID andOverview:(NSString *)overview;

@property TrailerVideos *episodeTrailer;
@property NSString *episodeOverview;
@property BOOL isEpisode;


@end
