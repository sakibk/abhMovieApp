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
@property NSNumber *totalCostToPay;
@property NSString *stringPlayingTerm;

@end

@implementation BookingViewController{
    UIButton *bottomButton;
    UIView *bottomView;
    UILabel *totalLabel;
    BOOL isPickerViewExtended;
    BOOL isPickerTwoViewExtended;
    BOOL senderOnePop;
    BOOL senderTwoPop;
    float floatPrice;
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
    _ticketNumber=[NSNumber numberWithInt:1];
    [self setNavBarTitle];
    [self createBottomButton];
    [self setupCells];
    [self setSizes];
    [self setTicketPrice];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
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
    titleLabel.text=@"Tickets";
    
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
    CGRect totalRect = CGRectMake(20, 20, 130, 20);
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
    CollectionSeatsCell *cellSeats =[_tableView cellForRowAtIndexPath:_seatsIndexPath];
    [cellSeats setupNumberOfSeatsToTake:_ticketNumber];
    [cellSeats.selectedSeats removeAllObjects];
    [_selectedSeats removeAllObjects];
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

-(void)setTicketPrice{
    floatPrice = 0.0;
    NSCharacterSet *numberCharset = [NSCharacterSet characterSetWithCharactersInString:@"0123456789-"];
    NSScanner *theScanner = [NSScanner scannerWithString:_selectedMovie.ticketPrice];
    while (![theScanner isAtEnd]) {
        [theScanner scanUpToCharactersFromSet:numberCharset
                                   intoString:NULL];
        if ([theScanner scanFloat:&floatPrice]) {
            NSLog(@"Found %f", floatPrice);
        }
    }
}

-(void)pushTicketNo:(NSNumber*)numberOfTickets{
    _ticketNumber = numberOfTickets;
    _totalCostToPay = [NSNumber numberWithFloat:[numberOfTickets floatValue]*floatPrice];
    _totalCost =[NSString stringWithFormat:@"%@%@%@",@"TOTAL: $",[NSNumber numberWithFloat:20*[numberOfTickets floatValue]],@".00"];
    totalLabel.text=_totalCost;
    CollectionSeatsCell *cell =[_tableView cellForRowAtIndexPath:_seatsIndexPath];
    [cell setupNumberOfSeatsToTake:_ticketNumber];
}

-(void)pushSelectedHours:(Hours*)hoursSelected andPushSelectedString:(NSString*)selectedHourString{
    _selectedHours=hoursSelected;
    _stringPlayingTerm=selectedHourString;
    CollectionSeatsCell *cell =(CollectionSeatsCell*)[_tableView cellForRowAtIndexPath:_seatsIndexPath];
    [cell setupWithHallID:_selectedHours.playingHall andPlayingDayID:_selectedHours.playingDayID andPlayingHourID:_selectedHours.hourID];
    _totalCost=@"TOTAL: $0.00";
    totalLabel.text =_totalCost;
    CollectionSeatsCell *cellSeat =[_tableView cellForRowAtIndexPath:_seatsIndexPath];
    [cellSeat setupNumberOfSeatsToTake:_ticketNumber];
    [cellSeat.selectedSeats removeAllObjects];
    [_selectedSeats removeAllObjects];
}

-(void)pushSelectedString:(NSString*)selectedHourString{
    _stringPlayingTerm = [[NSString alloc] initWithString:selectedHourString];
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
    _totalCostToPay = [NSNumber numberWithFloat:[_selectedSeats count]*floatPrice];
    _totalCost =[NSString stringWithFormat:@"%@%@%@",@"TOTAL: $",_totalCostToPay,@".00"];
    totalLabel.text=_totalCost;
}

-(void)popSeatSelected:(Seats*)seat{
    [_selectedSeats removeObject:seat];
    _totalCostToPay = [NSNumber numberWithFloat:[_selectedSeats count]*floatPrice];
    _totalCost =[NSString stringWithFormat:@"%@%@%@",@"TOTAL: $",_totalCostToPay,@".00"];
    totalLabel.text=_totalCost;
}

-(void)cleanSelectedSeats{
    [_selectedSeats removeAllObjects];
    totalLabel.text=@"TOTAL: $0.00";
}

-(void)pushCheckoutSummary{
    NSLog(@"Push checkout summary");
    if([_selectedSeats count]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CheckoutSummaryViewController* summary = (CheckoutSummaryViewController*)[storyboard instantiateViewControllerWithIdentifier:@"CheckoutSummary"];
        summary.selectedSeats = [[NSMutableArray alloc]init];
        summary.selectedSeats=_selectedSeats;
        summary.selectedHours = [[Hours alloc] init];
        summary.selectedHours=_selectedHours;
        summary.selectedMovie = [[Movie alloc] init];
        summary.selectedMovie=_selectedMovie;
        summary.numberOfTickets=_ticketNumber;
        summary.DateString = _stringPlayingTerm;
        if([_selectedSeats count]==[_ticketNumber integerValue]){
            summary.amountToPay= _totalCostToPay;
        }else{
            float payingAmount=0.0;
            payingAmount = [_totalCostToPay floatValue]/[_ticketNumber floatValue];
            payingAmount = payingAmount*[_selectedSeats count];
            summary.amountToPay = [NSNumber numberWithFloat:payingAmount];
            summary.numberOfTickets=[NSNumber numberWithInteger:[_selectedSeats count]];
        }
        
        [self.navigationController pushViewController:summary animated:YES];
    }
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
            _stringPlayingTerm=[cell setupStringsToShow];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
