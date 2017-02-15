//
//  ActorDetailsViewController.m
//  MovieApp
//
//  Created by Sakib Kurtic on 08/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "ActorDetailsViewController.h"
#import <RestKit/RestKit.h>
#import "PictureDetailCell.h"
#import "AboutCell.h"
#import "FilmographyCell.h"

@interface ActorDetailsViewController ()

@property Actor *singleActor;

@end

@implementation ActorDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    // Do any additional setup after loading the view.
    [self.tableView registerNib:[UINib nibWithNibName:@"PictureDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:pictureDetailCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"AboutCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:aboutCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"FilmographyCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:filmographyCellIdentifier];
    [self setRestkit];
    [self searchForActor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavBarTitle{
    self.navigationItem.title = _singleActor.name;
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor lightGrayColor]];
}

-(void)setRestkit{
    NSString *pathP = [NSString stringWithFormat:@"/3/person/%@",_actorID];
    RKObjectMapping *actorMapping = [RKObjectMapping mappingForClass:[Actor class]];
    
    [actorMapping addAttributeMappingsFromDictionary:@{@"name": @"name",
                                                       @"also_known_as": @"nickNames",
                                                       @"biography": @"biography",
                                                       @"birthday": @"birthDate",
                                                       @"id": @"actorID",
                                                       @"profile_path" : @"profilePath",
                                                       @"deathday":@"deathDate",
                                                       @"place_of_birth": @"birthPlace",
                                                       @"gender" : @"gender",
                                                       @"homepage":@"homePage"
                                                       }];
    
    RKResponseDescriptor *actorResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:actorMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:pathP
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:actorResponseDescriptor];
    
}

-(void)searchForActor{
    
    NSString *pathP = [NSString stringWithFormat:@"/3/person/%@",_actorID];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _singleActor=mappingResult.array.firstObject;
        [self setNavBarTitle];
        [self.tableView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
    }];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _singleActor != nil ? 3 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0)
    {
        return 1;
    }
    else if(section==1){
        return 1;
    }
    else if(section==2){
        return 1;
    }
    else
        return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return @"";
    else if (section==1)
        return @"";
    else if(section==2)
        return @"Filmography";
    else
        return @"";
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width/2, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    //    NSString *string =[list objectAtIndex:section];
    NSString *string =[self stringForSection:section];
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [label setTextColor:[UIColor whiteColor]];
    [view setBackgroundColor:[UIColor blackColor]]; //your background color...
    return view;
}

-(NSString*)stringForSection:(long)section{
    if(section == 0)
        return nil;
    else if (section==1)
        return @"";
    else if(section==2)
        return @"Filmography";
    else
        return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:{
            PictureDetailCell *cell = (PictureDetailCell *)[tableView dequeueReusableCellWithIdentifier:pictureDetailCellIdentifier forIndexPath:indexPath];
            [cell setupWithActor:_singleActor];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
        case 1:{
            AboutCell *cell = (AboutCell *)[tableView dequeueReusableCellWithIdentifier:aboutCellIdentifier forIndexPath:indexPath];
            [cell setupWithActor:_singleActor];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
        case 2:{
            FilmographyCell *cell = (FilmographyCell *)[tableView dequeueReusableCellWithIdentifier:filmographyCellIdentifier forIndexPath:indexPath];
            [cell setupWithActor:_singleActor];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
            break;
        default:
            break;
    }
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        if(indexPath.section == 0 && indexPath.row == 0) {
            return 222.0;
        }
        else if(indexPath.section == 1 && indexPath.row == 0) {
            return 360.0;
        }
        else if(indexPath.section == 2 && indexPath.row == 0) {
            return 295.0;
        }
        
        return 0.0;

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
