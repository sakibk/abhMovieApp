//
//  BookingViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 31/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "BookingViewController.h"
#import "PickerCell.h"
#import "TwoPickerCell.h"
#import "LegendCell.h"
#import "CollectionSeatsCell.h"
#import "CheckoutSummaryViewController.h"

@interface BookingViewController ()

@property (strong,nonatomic)NSString *totalCost;
@property NSNumber *ticketNumber;

@property CGFloat legendCellHeigh;
@property CGFloat seatsCellHeight;
@property CGFloat nonPoppedTwoPickerHeight;
@property CGFloat poppedTwoPickerHeight;
@property CGFloat nonPopedHight;
@property CGFloat popedHight;
@property CGFloat buttonHeight;
@property CGFloat noCellHeight;
@property NSIndexPath *seatsIndexPath;
@property NSIndexPath *twoPickerIndexPath;
@property NSMutableArray<Seats*> *selectedSeats;

@end

@implementation BookingViewController{
    UIButton *bottomButton;
    UIView *bottomView;
    UILabel *totalLabel;
    BOOL isPickerViewExtended;
    BOOL isPickerTwoViewExtended;
    BOOL senderOnePop;
    BOOL senderTwoPop;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    // Do any additional setup after loading the view.
    _totalCost=@"TOTAL: $0.00";
    senderOnePop=NO;
    senderTwoPop=NO;
    isPickerViewExtended=NO;
    isPickerTwoViewExtended=NO;
    _selectedSeats =[[NSMutableArray alloc] init];
    [self setNavBarTitle];
    [self createBottomButton];
    [self setupCells];
    [self setSizes];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupCells{
    [_tableView registerNib:[UINib nibWithNibName:@"PickerCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:pickerCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"TwoPickerCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:twoPickerCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"LegendCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:legendCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"CollectionSeatsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:seatsCollectionCellIdentifier];
}

-(void)setNavBarTitle{
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor lightGrayColor];
    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-150, 27)];
    [iv setBackgroundColor:[UIColor clearColor]];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, iv.frame.size.width, 27)];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:18];
    titleLabel.text=[_selectedMovie title];
    
    titleLabel.textColor=[UIColor whiteColor];
    [iv addSubview:titleLabel];
    self.navigationItem.titleView = iv;
}


-(void)createBottomButton{
    CGRect bottomFrame = CGRectMake(0, self.view.frame.size.height-70, self.view.frame.size.width, 70);
    bottomView=[[UIView alloc]initWithFrame:bottomFrame];
    [bottomView setBackgroundColor:[UIColor blackColor]];
    CGRect bottomButtomFrame = CGRectMake(10, 0, bottomView.frame.size.width-20, bottomView.frame.size.height-10);
    bottomButton = [[UIButton alloc]initWithFrame:bottomButtomFrame];
    [bottomButton setBackgroundColor:[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0]];
    [bottomButton setTitle:@"CHECKOUT" forState:UIControlStateNormal];
    [bottomButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [bottomButton.titleLabel setFont:[UIFont systemFontOfSize:20.0 weight:0.78]];
    [bottomButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    bottomButton.layer.cornerRadius=3;
    [bottomButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    [bottomButton addTarget:self action:@selector(pushCheckoutSummary) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:bottomButton];
    CGRect totalRect = CGRectMake(20, 20, 120, 20);
    totalLabel = [[UILabel alloc] initWithFrame:totalRect];
    totalLabel.text=_totalCost;
    [totalLabel setContentMode:UIViewContentModeLeft];
    [totalLabel setFont:[UIFont systemFontOfSize:17.0]];
    [totalLabel setTextColor:[UIColor blackColor]];
    [bottomView addSubview:totalLabel];
    [self.view insertSubview:bottomView aboveSubview:_tableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bottomView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_tableView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
}
-(void)pushMoviesTroughDelegate:(Movie*)selectedMovie{
    _selectedMovie=selectedMovie;
    _selectedHours=[[[[_selectedMovie playingDays] objectAtIndex:0] playingHours] objectAtIndex:0];
    TwoPickerCell *cellPicker = (TwoPickerCell*)[_tableView cellForRowAtIndexPath:_twoPickerIndexPath];
    [cellPicker setSelectedHours:_selectedHours];
    [cellPicker.playingDays setArray:[_selectedMovie playingDays]];
    
    CollectionSeatsCell *cell = (CollectionSeatsCell*)[_tableView cellForRowAtIndexPath:_seatsIndexPath];
    [cell setupWithHallID:_selectedHours.playingHall andPlayingDayID:_selectedHours.playingDayID andPlayingHourID:_selectedHours.hourID];
    _totalCost=@"TOTAL: $0.00";
    totalLabel.text =_totalCost;
}

-(IBAction)popMoviePicker:(id)sender{
    [self.tableView beginUpdates];
    if (isPickerViewExtended) {
        isPickerViewExtended = NO;
    } else {
        isPickerViewExtended = YES;
    }
    [self.tableView endUpdates];
}

-(void)pushTicketNo:(NSNumber*)numberOfTickets{
    _ticketNumber = numberOfTickets;
    _totalCost =[NSString stringWithFormat:@"%@%@%@",@"TOTAL: ",[NSNumber numberWithFloat:20*[numberOfTickets floatValue]],@".00"];
    totalLabel.text=_totalCost;
    CollectionSeatsCell *cell =[_tableView cellForRowAtIndexPath:_seatsIndexPath];
    [cell setupNumberOfSeatsToTake:_ticketNumber];
}

-(void)pushSelectedHours:(Hours*)hoursSelected{
    _selectedHours=hoursSelected;
    CollectionSeatsCell *cell =(CollectionSeatsCell*)[_tableView cellForRowAtIndexPath:_seatsIndexPath];
    [cell setupWithHallID:_selectedHours.playingHall andPlayingDayID:_selectedHours.playingDayID andPlayingHourID:_selectedHours.hourID];
    _totalCost=@"TOTAL: $0.00";
    totalLabel.text =_totalCost;
}

-(IBAction)popOneOfTwoPickers:(id)sender{
    if ([sender tag]==1){
        if(senderOnePop)
            senderOnePop=NO;
        else
            senderOnePop=YES;
    } else {
        if(senderTwoPop)
            senderTwoPop=NO;
        else
            senderTwoPop=YES;
    }
    [self.tableView beginUpdates];
    if(senderOnePop || senderTwoPop){
        isPickerTwoViewExtended=YES;
    } else {
        isPickerTwoViewExtended=NO;
    }
    [self.tableView endUpdates];
}

-(void)setSizes{
    _nonPoppedTwoPickerHeight=60.0;
    _poppedTwoPickerHeight=120.0;
    _nonPopedHight=60.0;
    _legendCellHeigh = 110.0;
    _popedHight=120.0;
    _buttonHeight=60.0;
    _seatsCellHeight = self.view.frame.size.width;
    _noCellHeight =0.0001;
}

-(void)pushSeatSelected:(Seats*)seat{
    [_selectedSeats addObject:seat];
}

-(void)popSeatSelected:(Seats*)seat{
    [_selectedSeats removeObject:seat];
}

-(void)pushCheckoutSummary{
    NSLog(@"Push checkout summary");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CheckoutSummaryViewController* summary = (CheckoutSummaryViewController*)[storyboard instantiateViewControllerWithIdentifier:@"CheckoutSummary"];
    
    
    [self.navigationController pushViewController:summary animated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            PickerCell *cell = (PickerCell*)[_tableView dequeueReusableCellWithIdentifier:pickerCellIdentifier forIndexPath:indexPath];
            [cell setupWithPlayingMovies:_allMovies andSelectedMovie:_selectedMovie];
            cell.delegateOne=self;
            return cell;
        }
            break;
        case 1:{
            _twoPickerIndexPath=indexPath;
            TwoPickerCell *cell = (TwoPickerCell*)[_tableView dequeueReusableCellWithIdentifier:twoPickerCellIdentifier forIndexPath:indexPath];
            cell.selectedHours=_selectedHours;
            cell.playingDays=[_selectedMovie playingDays];
            [cell firstPickerButtonTitle];
            cell.delegate=self;
            return cell;
        }
            break;
        case 2:{
            LegendCell *cell = (LegendCell*)[_tableView dequeueReusableCellWithIdentifier:legendCellIdentifier forIndexPath:indexPath];
            [cell setUserInteractionEnabled:NO];
            return cell;
        }
            break;
        case 3:{
            CollectionSeatsCell *cell = (CollectionSeatsCell*)[_tableView dequeueReusableCellWithIdentifier:seatsCollectionCellIdentifier forIndexPath:indexPath];
            [cell setupWithHallID:_selectedHours.playingHall andPlayingDayID:_selectedHours.playingDayID andPlayingHourID:_selectedHours.hourID];
            _seatsIndexPath=indexPath;
            cell.delegate=self;
            [cell setupNumberOfSeatsToTake:[NSNumber numberWithInt:1]];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            if(isPickerViewExtended)
                return _popedHight;
            else
                return _nonPopedHight;
        }
            break;
        case 1:{
            if(isPickerTwoViewExtended)
                return _poppedTwoPickerHeight;
            else
                return _nonPoppedTwoPickerHeight;
            
        }
            break;
        case 2:{
            return _legendCellHeigh;
        }
            break;
        case 3:{
            return _seatsCellHeight;
        }
            break;
            
        default:return 0.00001;
            break;
    }
    return 0.00001;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return _noCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *hv =[[UIView alloc]init];
    [hv setBackgroundColor:[UIColor blackColor]];
    return hv;
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
