//
//  CheckoutSummaryViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 04/04/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "CheckoutSummaryViewController.h"
#import "CheckoutCell.h"
#import "PaymentsViewController.h"

@import Firebase;

@interface CheckoutSummaryViewController ()

@property (strong,nonatomic) FIRDatabaseReference *seatsRef;

@end

@implementation CheckoutSummaryViewController
{
    UIView *bottomView;
    UIButton *bottomButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self setupCell];
    [self setNavBarTitle];
    [self createPaymentButton];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
    [self setupWatchingReferences];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavBarTitle{
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor lightGrayColor];
    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-150, 27)];
    [iv setBackgroundColor:[UIColor clearColor]];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, iv.frame.size.width, 27)];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:18];
    titleLabel.text=@"Checkout Summary";
    
    titleLabel.textColor=[UIColor whiteColor];
    [iv addSubview:titleLabel];
    self.navigationItem.titleView = iv;
}


-(void)createPaymentButton{
    CGRect bottomFrame = CGRectMake(0, self.view.frame.size.height-70, self.view.frame.size.width, 70);
    bottomView=[[UIView alloc]initWithFrame:bottomFrame];
    [bottomView setBackgroundColor:[UIColor blackColor]];
    CGRect bottomButtomFrame = CGRectMake(10, 0, bottomView.frame.size.width-20, bottomView.frame.size.height-10);
    bottomButton = [[UIButton alloc]initWithFrame:bottomButtomFrame];
    [bottomButton setBackgroundColor:[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0]];
    [bottomButton setTitle:@"PROCEED TO CHECKOUT" forState:UIControlStateNormal];
    [bottomButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [bottomButton.titleLabel setFont:[UIFont systemFontOfSize:20.0 weight:0.78]];
    [bottomButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    bottomButton.layer.cornerRadius=3.0f;
    [bottomButton addTarget:self action:@selector(pushInputPayments) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:bottomButton];
    [self.view insertSubview:bottomView aboveSubview:_tableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bottomView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_tableView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
}

-(void)setupWatchingReferences{
    [self.seatsRef removeAllObservers];
    FIRDatabaseReference *ref = [FIRDatabase database].reference;
    _seatsRef = [[[[[ref child:@"Halls"] child:[NSString stringWithFormat:@"%@",_selectedHours.playingHall]] child:[NSString stringWithFormat:@"%@",_selectedHours.playingDayID]] child:[NSString stringWithFormat:@"%@",_selectedHours.hourID]] child:@"Seats"];

    [_seatsRef
     observeEventType:FIRDataEventTypeChildChanged
     withBlock:^(FIRDataSnapshot *snapshot) {
         for(Seats *sts in _selectedSeats){
             if([[snapshot.value valueForKeyPath:@"row"] isEqualToString:sts.row]){
                 if([[snapshot.value valueForKeyPath:@"taken"] boolValue]){
                     [self.navigationController popViewControllerAnimated:YES];
                 }
             }
         }
     }];
}


-(void)pushInputPayments{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PaymentsViewController *paymentsVC = (PaymentsViewController*)[storyboard instantiateViewControllerWithIdentifier:@"PaymentVC"];
    paymentsVC.selectedSeats =[[NSMutableArray alloc]initWithArray:_selectedSeats];
    paymentsVC.playingTerm = [[Hours alloc]init];
    paymentsVC.playingTerm=_selectedHours;
    [self.navigationController pushViewController:paymentsVC animated:YES];
}

-(void)setupCell{
    [_tableView registerNib:[UINib nibWithNibName:@"CheckoutCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:checkoutCellIdentifier];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CheckoutCell *cell = (CheckoutCell*)[_tableView dequeueReusableCellWithIdentifier:checkoutCellIdentifier forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:{
            [cell setupWithTitle:@"Checkout Summary"];
        }
            break;
        case 1:{
            NSString *name=[[NSString alloc]init];
            NSDictionary *userCredits = [[NSUserDefaults standardUserDefaults] objectForKey:@"SessionCredentials"];
            if([[userCredits valueForKey:@"name"] isKindOfClass:[NSNull class]]){
                name =[userCredits valueForKey:@"name"];
            }else{
                name=[userCredits valueForKey:@"username"];
            }
            [cell setupWithString:@"Name" andAtributedPart:name];
        }
            break;
        case 2:{
            [cell setupWithString:@"Movie" andAtributedPart:_selectedMovie.title];
        }
            break;
        case 3:{
            
            [cell setupWithDate:[NSString stringWithFormat:@"%@: %@",@"Date and Time",_DateString]];
        }
            break;
        case 4:{
            [cell setupWithString:@"Tickets" andAtributedPart:[NSString stringWithFormat:@"%@ Adults",_numberOfTickets]];
        }
            break;
        case 5:{
            NSMutableString *seatString=[[NSMutableString alloc]init];
            for(Seats *s in _selectedSeats){
                [seatString appendString:[NSString stringWithFormat:@"%@,",s.row]];
            }
            [seatString deleteCharactersInRange:NSMakeRange([seatString length]-1, 1)];
            [cell setupWithString:@"Seats" andAtributedPart:seatString];
        }
            break;
        case 6:{
            [cell setupWithString:@"Total" andAtributedPart:[NSString stringWithFormat:@"$ %@",_amountToPay]];
        }
            break;
        default:
            break;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)viewWillDisappear:(BOOL)animated{
    [_seatsRef removeAllObservers];
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
