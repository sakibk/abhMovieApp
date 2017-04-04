//
//  TrailerViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 09/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "TrailerViewController.h"
#import <RestKit/RestKit.h>
#import "TrailerVideos.h"
#import "ApiKey.h"
#import "ConnectivityTest.h"
#import "RLMStoredObjects.h"
#import "RLMovie.h"
#import "RLMTrailerVideos.h"
#import <Reachability/Reachability.h>

@interface TrailerViewController ()

@property NSNumber *movieID;
@property NSString *overviewString;
@property TrailerVideos *singleTrailer;
@property NSMutableArray <TrailerVideos *> *allTrailers;
@property BOOL isConnected;
@property RLMRealm *realm;
@property RLMStoredObjects *storedObjetctMedia;
@property Reachability *reachability;
@property BOOL haveData;
@property UIView *dropDown;
@property UIButton *showList;

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupOffline];
    [self CreateDropDownList];
    self.playerView.delegate = self;
    [self setNavBarTitle];
    if(_isEpisode){
        [self setupWithTVEpisode];
    }
    _isConnected = [ConnectivityTest isConnected];
    if (!_isConnected) {
        [_dropDown setAlpha:1.0];
    }
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
}
- (void)reachabilityDidChange:(NSNotification *)notification {
    
    _reachability = (Reachability *)[notification object];
    
    if ([_reachability isReachable]) {
        NSLog(@"Reachable");
        _isConnected=[ConnectivityTest isConnected];
        if(_isEpisode)
            [self setupWithTVEpisode];
        else{
            if(_haveData)
                [self setupPlayer];
            else
                [self getTrailers];
            if([_dropDown alpha] ==1.0){
                [_dropDown setAlpha:0.0];
            }
        }
    } else {
        NSLog(@"Unreachable");
        _isConnected=[ConnectivityTest isConnected];
    }
}

-(void)setButtonTitle{
    NSMutableAttributedString *text =
    [[NSMutableAttributedString alloc]
     initWithString:[NSString stringWithFormat:@"Please Reconnect to proceed!"]];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor whiteColor]
                 range:NSMakeRange(0, 7)];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0]
                 range:NSMakeRange(7, 10)];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor whiteColor]
                 range:NSMakeRange(17, 11)];
    [_showList setAttributedTitle:text forState:UIControlStateNormal];
}

-(void)CreateDropDownList{
    CGRect dropDownFrame =CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-174, [[UIScreen mainScreen] bounds].size.width, 64);
    _dropDown = [[UIView alloc ]initWithFrame:dropDownFrame];
    [_dropDown setBackgroundColor:[UIColor clearColor]];
    CGRect buttonFrame = CGRectMake(0, 0, [_dropDown bounds].size.width, [_dropDown bounds].size.height-1);
    _showList = [[UIButton alloc]init];
    _showList.frame = buttonFrame;
    [_showList setBackgroundColor:[UIColor clearColor]];
    _showList.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _showList.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self setButtonTitle];
    [_showList addTarget:self action:@selector(openWifiSettings:) forControlEvents:UIControlEventTouchUpInside];
    
    [_dropDown addSubview:_showList];
    [self.view addSubview:_dropDown];
    [_dropDown setAlpha:0.0];
}

- (IBAction)openWifiSettings:(id)sender{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"prefs:root=WIFI"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=WIFI"]];
    }
}

-(void)setupOffline{
    _isConnected = [ConnectivityTest isConnected];
    _realm =[RLMRealm defaultRealm];
    RLMResults<RLMStoredObjects*> *objs= [RLMStoredObjects allObjects];
    _storedObjetctMedia = objs.firstObject;
}

-(void)setupWithMovieID:(NSNumber *)movieID andOverview:(NSString *)overview{
    
    _movieID=movieID;
    _overviewString=overview;
    _isConnected = [ConnectivityTest isConnected];
    if(_isConnected)
        [self getTrailers];
    else
        [self getStoredTrailers];
}

-(void)setupWithTVEpisode{
    _singleTrailer=_episodeTrailer;
    _overviewString=_episodeOverview;
    [self setupPlayer];
}

-(void)getStoredTrailers{
    RLMResults<RLMovie*> *movs =[RLMovie objectsWhere:@"movieID = %@", _movieID];
    RLMovie* mv = movs.firstObject;
    if(mv.videos.firstObject !=nil){
        _haveData=YES;
        _allTrailers = [[NSMutableArray alloc]init];
        for(RLMTrailerVideos *vd in mv.videos)
            [_allTrailers addObject:[[TrailerVideos alloc] initWithVideo:vd]];
        [self setupPlayer];
    }
    else{
        _haveData = NO;
    }
    
    [_dropDown setAlpha:1.0];
}

-(void)setStoredTrailers{
    RLMResults<RLMovie*> *movs =[RLMovie objectsWhere:@"movieID = %d", [_movieID intValue]];
    if([movs count]){
        RLMovie* mv = movs.firstObject;
        if(mv.videos.firstObject == nil){
            [_realm beginWriteTransaction];
            for(TrailerVideos *vid in _allTrailers)
                [mv.videos addObject:[[RLMTrailerVideos alloc] initWithVideo:vid]];
            [_realm addOrUpdateObject:mv];
            [_realm commitWriteTransaction];
        }
    }
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
    if(_allTrailers.firstObject.videoKey){
        [self.playerView loadWithVideoId:_allTrailers.firstObject.videoKey playerVars:playerVars];
    }
    if(_isEpisode)
        [self.playerView loadWithVideoId:_singleTrailer.videoKey playerVars:playerVars];
    [self appendStatusText:_overviewString];
}

-(void)setNavBarTitle{
    self.navigationItem.title =@"Trailer";
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor lightGrayColor]];
}

-(void)getTrailers{
    NSString *pathP = [NSString stringWithFormat:@"/3/movie/%@/videos",_movieID];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": [ApiKey getApiKey]/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _allTrailers=[[NSMutableArray alloc]initWithArray:mappingResult.array];
        _singleTrailer= [_allTrailers firstObject];
        NSMutableArray<NSString*> *allIds= [[NSMutableArray alloc]init];
        for(TrailerVideos *tv in _allTrailers){
            [allIds addObject:tv.videoID];
        }
        [self setStoredTrailers];
        [self setupPlayer];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
    
}

-(void)playerViewDidBecomeReady:(YTPlayerView *)playerView{
    int i;
    for (i=1; i<[_allTrailers count]; i++) {
        [self.playerView cueVideoById:[_allTrailers objectAtIndex:i].videoKey startSeconds:0 suggestedQuality:kYTPlaybackQualityAuto];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)playerView:(YTPlayerView *)ytPlayerView didChangeToState:(YTPlayerState)state {
}

- (void)playerView:(YTPlayerView *)playerView didPlayTime:(float)playTime {
    float progress = playTime/self.playerView.duration;
    [self.slider setValue:progress];
}

- (IBAction)onSliderChange:(id)sender {
    float seekToTime = self.playerView.duration * self.slider.value;
    [self.playerView seekToSeconds:seekToTime allowSeekAhead:YES];
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
