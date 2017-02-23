//
//  PRViewController.m
//  Approval
//
//  Created by Dody Rachmat Wicaksono on 2/22/17.
//  Copyright © 2017 Semen Indonesia. All rights reserved.
//

#import "PRViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "PRViewCell.h"
#import "PRDetailViewController.h"

@interface PRViewController () {
    NSArray *list;
}

@end

@implementation PRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Purchase Requsition";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadPR)
                                                 name:@"reloadPR" object:nil];
    
    [self populateData];
    
}

- (void)reloadPR {
    [self populateData];
}

- (void)populateData {
    [SVProgressHUD showWithStatus:@"Please wait.."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] forKey:@"username"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:@"http://dev-app.semenindonesia.com/dev/approval2/index.php/mobile/mob_pr_list" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray * _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        list = responseObject;
        
        NSLog(@"list: %lu",(unsigned long)list.count);
        
        [self.tableView reloadData];
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error: %@",error);
        [SVProgressHUD dismiss];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PRViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *item = [list objectAtIndex:indexPath.row];
    
    cell.title.text = [NSString stringWithFormat:@"PR No. %@",[item objectForKey:@"pr"]];
    cell.detail.text = [item objectForKey:@"stext"];//[[[item objectForKey:@"detailpr"] firstObject] objectForKey:@"material"];
    cell.nominal.text = [item objectForKey:@"amount"];
    cell.date.text = [item objectForKey:@"c_date"];
    
    //NSLog(@"pr: %@",[item objectForKey:@"pr"]);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"detail" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSDictionary *item = [list objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    
    PRDetailViewController *vc = segue.destinationViewController;
    vc.data = item;
}


@end
