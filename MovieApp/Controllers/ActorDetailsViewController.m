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
    [self setRestkit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)searchForString{
    
    NSString *pathP = [NSString stringWithFormat:@"/3/person/%@",_actorID];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        _singleActor=mappingResult.array.firstObject;
        [self.tableView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no coffee?': %@", error);
    }];
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:{
            PictureDetailCell *cell = (PictureDetailCell *)[tableView dequeueReusableCellWithIdentifier:pictureDetailCellIdentifier forIndexPath:indexPath];
            [cell setupWithActor:_singleActor];
        }
            break;
        case 1:{
            
        }
            break;
        case 2:{
            
        }
            break;
        default:
            break;
    }
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    // Configure the cell...
    
    return cell;
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
