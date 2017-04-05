//
//  FirebaseDetailViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 28/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "FirebaseDetailViewController.h"
#import "PictureDetailCell.h"
#import "BellowImageCell.h"
#import "OverviewCell.h"
#import "OverviewdLineCell.h"
#import "PickerCell.h"
#import "BookingViewController.h"
#import "TrailerViewController.h"
#import "RatingViewController.h"
#import "ApiKey.h"

@interface FirebaseDetailViewController ()

@property NSMutableArray<NSNumber*> *cellOverviewHeights;

@property CGFloat imageCellHeigh;
@property CGFloat detailsCellHeight;
@property CGFloat overviewCellHeight;
@property CGFloat overviewLineCellHight;
@property CGFloat nonPopedHight;
@property CGFloat popedHight;
@property CGFloat buttonHeight;
@property CGFloat noCellHeight;
@property Hours *selectedHours;
@property UILabel *statusLabel;
@property NSMutableString *directorString;
@property NSMutableString *writersString;
@property NSMutableString *producentString;

@property BOOL hasDirector;
@property BOOL hasWriters;
@property BOOL hasProducents;

@property BOOL isDirectorSet;
@property BOOL areWritersSet;
@property BOOL areProducentsSet;

@property int count;
@end

@implementation FirebaseDetailViewController
{
    UIButton *bottomButton;
    UIView *bottomView;
    BOOL isPickerViewExtended;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self setCells];
    [self setSizes];
    [self setNavBarTitle];
    isPickerViewExtended = NO;
    [self createBottomButton];
    [self setupStatusLabel];
    [self setBools];
    [self setupOverviewMovie];
}

-(void)createBottomButton{
    CGRect bottomFrame = CGRectMake(0, self.view.frame.size.height-130, self.view.frame.size.width, 70);
    bottomView=[[UIView alloc]initWithFrame:bottomFrame];
    [bottomView setBackgroundColor:[UIColor blackColor]];
    CGRect bottomButtomFrame = CGRectMake(10, 0, bottomView.frame.size.width-20, bottomView.frame.size.height-10);
    bottomButton = [[UIButton alloc]initWithFrame:bottomButtomFrame];
    [bottomButton setBackgroundColor:[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0]];
    [bottomButton setTitle:@"BOOK NOW" forState:UIControlStateNormal];
    [bottomButton.titleLabel setFont:[UIFont systemFontOfSize:20.0 weight:0.78]];
    [bottomButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    bottomButton.layer.cornerRadius=3;
    [bottomButton addTarget:self action:@selector(pushBookingView) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:bottomButton];
    [self.view insertSubview:bottomView aboveSubview:_tableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bottomView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_tableView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
}

-(void)setNavBarTitle{
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor lightGrayColor];
    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-150, 27)];
    [iv setBackgroundColor:[UIColor clearColor]];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, iv.frame.size.width, 27)];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:18];
    titleLabel.text= _singleMovie.title;
    
    titleLabel.textColor=[UIColor whiteColor];
    [iv addSubview:titleLabel];
    self.navigationItem.titleView = iv;
}


-(void)setCells{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PictureDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:pictureDetailCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BellowImageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BellowImageCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OverviewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:OverviewCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OverviewdLineCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:overviewLineCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PickerCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:pickerCellIdentifier];
}

-(void)setupStatusLabel{
    CGRect statusRect = CGRectMake(20, self.view.bounds.size.height*5/7, self.view.bounds.size.width-40, 50);
    _statusLabel= [[UILabel alloc]initWithFrame:statusRect];
    [_statusLabel setBackgroundColor:[UIColor darkGrayColor]];
    [[_statusLabel layer] setCornerRadius:24.0];
    _statusLabel.clipsToBounds = YES;
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_statusLabel];
    [_statusLabel setHidden:YES];
}

-(void)postStatus:(NSString*)error{
    [_statusLabel setText:error];
    [_statusLabel setHidden:NO];
    [self performSelector:@selector(hideLabel) withObject:nil afterDelay:2.7];
}

-(void)hideLabel{
    [UIView animateWithDuration:0.3 animations:^{
        [_statusLabel setHidden:YES];
    } completion:^(BOOL finished){
        
    }];
}



-(void)setSizes{
    _imageCellHeigh =222.0;
    _detailsCellHeight =50.0;
    _overviewCellHeight =105;
    _overviewLineCellHight=20.0;
    _nonPopedHight=60.0;
    _popedHight=120.0;
    _buttonHeight=60;
    _noCellHeight =0.0001;
}

-(void)setBools{
    _hasDirector=NO;
    _hasWriters=NO;
    _hasProducents=NO;
    
    _isDirectorSet=NO;
    _areWritersSet=NO;
    _areProducentsSet=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) setupOverviewMovie{
    NSString *pathP =[NSString stringWithFormat:@"/3/movie/%@/credits",_singleMovie.movieID];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": [ApiKey getApiKey]/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _singleMovie.crews=[[NSMutableArray alloc]init];
        for (Crew *crew in mappingResult.array) {
            if ([crew isKindOfClass:[Crew class]]) {
                [_singleMovie.crews addObject:crew];
            }
        }
        [self setMovieCredits];
        [_tableView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
    
    
}

-(void)setMovieCredits{
    _directorString=[[NSMutableString alloc]init];
    _writersString = [[NSMutableString alloc]init];
    _producentString = [[NSMutableString alloc]init];
    NSMutableArray<NSString*> *strings = [[NSMutableArray alloc]init];
    Boolean tag = false;
    for(Crew *sinCrew in _singleMovie.crews ){
        if([sinCrew.jobName isEqualToString:@"Director"]){
            [_directorString appendString:sinCrew.crewName];
            tag = true;
            [strings addObject:_directorString];
        }
        else if([sinCrew.jobName isEqualToString:@"Writer"]){
            [_writersString appendString:sinCrew.crewName];
            [_writersString appendString:@", "];
        }
        else if ([sinCrew.jobName isEqualToString:@"Producer"]){
            [_producentString appendString:sinCrew.crewName];
            [_producentString appendString:@", "];
        }
    }
    if(![_writersString isEqualToString:@""]){
        [_writersString deleteCharactersInRange:NSMakeRange([_writersString length]-2, 2)];
        [strings addObject:_writersString];
    }
    if(![_producentString isEqualToString:@""]){
        [_producentString deleteCharactersInRange:NSMakeRange([_producentString length]-2, 2)];
        [strings addObject:_producentString];
    }
    
    if([_producentString isEqualToString:@""]){
    }
    
    if([_writersString isEqualToString:@""]){
    }
    
    if(tag==false){
        [_directorString appendString:@""];
    }
    [self setOverviewLineHeights:strings];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==2){
        int count=1;
        if(![_producentString isEqualToString:@""]){
            count++;
            _hasProducents =YES;
        }
        if(![_writersString isEqualToString:@""]){
            count++;
            _hasWriters=YES;
        }
        if(![_directorString isEqualToString:@""]){
            count++;
            _hasDirector=YES;
        }
        _count=count;
        return count;
    }
    else
        return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            PictureDetailCell *cell = (PictureDetailCell *)[tableView dequeueReusableCellWithIdentifier:pictureDetailCellIdentifier forIndexPath:indexPath];
            [cell setupWithSnapMovie:_singleMovie];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
        case 1:
        {
            BellowImageCell *cell = (BellowImageCell *)[tableView dequeueReusableCellWithIdentifier:BellowImageCellIdentifier forIndexPath:indexPath];
            [cell setupWithSnapMovie:_singleMovie];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
            
        }
            break;
        case 2:
        {
            if(indexPath.row == 0 && _count>1){
                //napraviti metodu za ovo
                if(_hasDirector){
                    _isDirectorSet=YES;
                    return [self setupOverviewCellForTableView:tableView :indexPath :@"Director: " :[NSString stringWithFormat:@"%@",_directorString]];
                }
                else if(_hasWriters){
                    return [self setupOverviewCellForTableView:tableView :indexPath :@"Writers: " :[NSString stringWithFormat:@"%@",_writersString]];
                }
                else if(_hasProducents){
                    return [self setupOverviewCellForTableView:tableView :indexPath :@"Stars: " :[NSString stringWithFormat:@"%@",_producentString]];
                }
                
            }
            else if(indexPath.row==1 && _count>2){
                if(_hasWriters && _isDirectorSet){
                    return [self setupOverviewCellForTableView:tableView :indexPath :@"Writers: " :[NSString stringWithFormat:@"%@",_writersString]];
                }
                else if(_hasProducents){
                    return [self setupOverviewCellForTableView:tableView :indexPath :@"Stars: " :[NSString stringWithFormat:@"%@",_producentString]];
                }
            }
            else if(indexPath.row==2 && _count==4){
                if(_hasProducents){
                    return [self setupOverviewCellForTableView:tableView :indexPath :@"Stars: " :[NSString stringWithFormat:@"%@",_producentString]];
                }
            }
            else{
                OverviewCell *celld = (OverviewCell *)[tableView dequeueReusableCellWithIdentifier:OverviewCellIdentifier forIndexPath:indexPath];
                celld.delegate=self;
                [celld setupWithMovie:_singleMovie];
                [celld setSelectionStyle:UITableViewCellSelectionStyleNone];
                return celld;
            }

            
        }
            break;
        case 3:{
            PickerCell *cell =(PickerCell *)[tableView dequeueReusableCellWithIdentifier:pickerCellIdentifier forIndexPath:indexPath];
            [cell setupWithHours:[[_singleMovie.playingDays objectAtIndex:[_indexPlayDay integerValue]] playingHours]];
            [cell setButonEdges];
            cell.delegate=self;
            return cell;
        }
            break;
        default:{
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            return cell;
        }
            break;
    }
    return nil;
}
-(IBAction)popPicker:(id)sender{
    [self.tableView beginUpdates];
    if (isPickerViewExtended) {
        isPickerViewExtended = NO;
    } else {
        isPickerViewExtended = YES;
    }
    [self.tableView endUpdates];
}

-(void)pushHoursTroughDelegate:(Hours*)selectedHour{
    _selectedHours=selectedHour;
}

-(OverviewLineCell *)setupOverviewCellForTableView:(UITableView*)tableView :(NSIndexPath*)indexPath :(NSString*)titlel :(NSString*)content{
    OverviewLineCell *cell = (OverviewLineCell *)[tableView dequeueReusableCellWithIdentifier:overviewLineCellIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.titleLabel setText:titlel];
    [cell.contentLabel setText:content];
    CGFloat afterHeight=[self heightForView:content :[UIFont systemFontOfSize:14.0] :cell.contentLabel.frame.size.width];
    [_cellOverviewHeights addObject:[NSNumber numberWithFloat:afterHeight]];
    return cell;
}

-(CGFloat)heightForView :(NSString*)text :(UIFont *)font : (CGFloat)width{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, CGFLOAT_MAX)];
    [label setNumberOfLines:0];
    [label setLineBreakMode: NSLineBreakByWordWrapping];
    [label setFont:font];
    [label setText:text];
    [label sizeToFit];
    return  label.frame.size.height;
}

-(void)pushBookingView{
    if(_selectedHours !=nil){
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BookingViewController * bookingVC = [storyboard instantiateViewControllerWithIdentifier:@"BookingVC"];
    bookingVC.allMovies=_allMovies;
    bookingVC.selectedMovie=_singleMovie;
    bookingVC.selectedHours=_selectedHours;
    [self.navigationController pushViewController:bookingVC animated:YES];
    }
    else
        [self postStatus:@"Select playing hours!"];
    
}

-(void)setOverviewLineHeights:(NSMutableArray*)strings{
    _cellOverviewHeights = [[NSMutableArray alloc]init];
    int i;
    for (i=0; i<[strings count]; i++) {
        CGFloat afterHeight=[self heightForView:[strings objectAtIndex:i] :[UIFont systemFontOfSize:15.0] :[UIScreen mainScreen].bounds.size.width-84];
        [_cellOverviewHeights addObject:[NSNumber numberWithFloat:afterHeight+3]];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section ==0 && indexPath.row == 0){
        return _imageCellHeigh;
    }
    else if(indexPath.section ==1 && indexPath.row == 0){
            return _detailsCellHeight;
    }
    else if(indexPath.section ==2){
        if (_count>1){
            if(indexPath.row==_count-1)
                return _overviewCellHeight;
            else{
                if(indexPath.row==0)
                    return [[_cellOverviewHeights objectAtIndex:0]floatValue];
                else
                    return [[_cellOverviewHeights objectAtIndex:indexPath.row] floatValue];
            }
        }
        else
            return _overviewCellHeight;
    }
    else if(indexPath.section ==3){
        if (isPickerViewExtended) {
            return _popedHight;
        }
        else{
            return _nonPopedHight;
        }
    }
    else if(indexPath.section == 4){
        return _buttonHeight;
    }
    else
        return _noCellHeight;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==3)
        return 20.00;
    else
        return _noCellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TrailerViewController *trailer = (TrailerViewController*)[storyboard instantiateViewControllerWithIdentifier:@"TrailerView"];
        [trailer setupWithMovieID:_singleMovie.movieID  andOverview:_singleMovie.overview];
        [self.navigationController pushViewController:trailer animated:YES];
    }
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *hv =[[UIView alloc]init];
    [hv setBackgroundColor:[UIColor blackColor]];
    return hv;
}

-(void)rateMedia{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RatingViewController *rate = (RatingViewController*)[storyboard instantiateViewControllerWithIdentifier:@"RatingViewController"];
    [rate setupWithMovie:_singleMovie];
    [self.navigationController pushViewController:rate animated:YES];
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
