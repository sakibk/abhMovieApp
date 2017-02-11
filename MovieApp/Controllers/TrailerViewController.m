//
//  TrailerViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 09/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "TrailerViewController.h"
#import <RestKit/RestKit.h>

@interface TrailerViewController ()

@property NSNumber *movieID;
@property TrailerVideos *singleTrailer;
@property NSMutableArray <TrailerVideos *> *allTrailers;

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      self.playerView.delegate = self;
    // Do any additional setup after loading the view.
    }

-(void)setupWithMovieID:(NSNumber *) movieID{

    _movieID=movieID;
    [self setRestkit];
    [self getTrailers];
}

-(void)setupPlayer{
    NSDictionary *playerVars = @{
                                 @"controls" : @2,
                                 @"playsinline" : @1,
                                 @"autohide" : @1,
                                 @"showinfo" : @1,
                                 @"modestbranding" : @1,
                                 @"fs": @1
                                 
                                 };
    [self.playerView loadWithVideoId:_allTrailers.firstObject.videoKey playerVars:playerVars];
}

-(void)getTrailers{
    NSString *pathP = [NSString stringWithFormat:@"/3/movie/%@/videos",_movieID];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _allTrailers=[[NSMutableArray alloc]initWithArray:mappingResult.array];
        _singleTrailer= [_allTrailers firstObject];
        NSMutableArray<NSString*> *allIds= [[NSMutableArray alloc]init];
        for(TrailerVideos *tv in _allTrailers){
            [allIds addObject:tv.videoID];
        }
        [self setupPlayer];

    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
    }];

}

-(void)playerViewDidBecomeReady:(YTPlayerView *)playerView{
    //            [self.playerView loadPlaylistByVideos:ids index:0 startSeconds:0 suggestedQuality:kYTPlaybackQualityAuto ];
    int i;
    for (i=1; i<[_allTrailers count]; i++) {
        [self.playerView cueVideoById:[_allTrailers objectAtIndex:i].videoKey startSeconds:0 suggestedQuality:kYTPlaybackQualityAuto];
    }
}

-(void)setRestkit{
    NSString *pathP = [NSString stringWithFormat:@"/3/movie/%@/videos",_movieID];
    RKObjectMapping *trailerMapping = [RKObjectMapping mappingForClass:[TrailerVideos class]];
    
    [trailerMapping addAttributeMappingsFromDictionary:@{@"key": @"videoKey",
                                                       @"name": @"videoName",
                                                         @"id":@"videoID"
                                                       }];
    
    RKResponseDescriptor *trailerResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:trailerMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:pathP
                                                keyPath:@"results"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:trailerResponseDescriptor];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)playerView:(YTPlayerView *)ytPlayerView didChangeToState:(YTPlayerState)state {
    NSString *message = [NSString stringWithFormat:@"Player state changed: %ld\n", (long)state];
    [self appendStatusText:message];
}

- (void)playerView:(YTPlayerView *)playerView didPlayTime:(float)playTime {
    float progress = playTime/self.playerView.duration;
    [self.slider setValue:progress];
}

- (IBAction)onSliderChange:(id)sender {
    float seekToTime = self.playerView.duration * self.slider.value;
    [self.playerView seekToSeconds:seekToTime allowSeekAhead:YES];
    [self appendStatusText:[NSString stringWithFormat:@"Seeking to time: %.0f seconds\n", seekToTime]];
}

- (IBAction)buttonPressed:(id)sender {
    if (sender == self.playButton) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Playback started" object:self];
        [self.playerView playVideo];
    }
    else if (sender == self.pauseButton) {
        [self.playerView pauseVideo];
    } }

- (void)receivedPlaybackStartedNotification:(NSNotification *) notification {
    if([notification.name isEqual:@"Playback started"] && notification.object != self) {
        [self.playerView pauseVideo];
    }
}

/**
 * Private helper method to add player status in statusTextView and scroll view automatically.
 *
 * @param status a string describing current player state
 */
- (void)appendStatusText:(NSString *)status {
    [self.statusTextView setText:[self.statusTextView.text stringByAppendingString:status]];
    NSRange range = NSMakeRange(self.statusTextView.text.length - 1, 1);
    
    // To avoid dizzying scrolling on appending latest status.
    self.statusTextView.scrollEnabled = NO;
    [self.statusTextView scrollRangeToVisible:range];
    self.statusTextView.scrollEnabled = YES;
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
