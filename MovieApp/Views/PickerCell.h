//
//  PickerCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 30/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hours.h"
#import "Movie.h"

extern NSString *const pickerCellIdentifier;

@protocol PickerCellDelegate <NSObject>

-(IBAction)popPicker:(id)sender;
-(void)pushHoursTroughDelegate:(Hours*)selectedHour;

@end

@protocol PickerCellTwoDelegate <NSObject>

-(IBAction)popPicker:(id)sender;
-(void)pushMoviesTroughDelegate:(Movie*)selectedMovie;

@end


@interface PickerCell : UITableViewCell<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *pickerButton;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) NSMutableArray<Hours*> *hoursPlaying;
@property (weak, nonatomic) IBOutlet UIImageView *imageDown;
@property (strong, nonatomic) id<PickerCellDelegate> delegate;
@property (strong, nonatomic) NSMutableArray<Movie*> *playingMovies;
@property (strong, nonatomic) id<PickerCellTwoDelegate> delegateOne;
@property (strong, nonatomic) Movie* selectedMovie;
-(void)setupWithPlayingMovies:(NSMutableArray<Movie*>*)playingMovies andSelectedMovie:(Movie*)selectedMovie;
-(void)setupWithHours:(NSMutableArray<Hours*>*) playingHours;
@end
