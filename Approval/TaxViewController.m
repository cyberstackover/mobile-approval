//
//  TaxViewController.m
//  Approval
//
//  Created by Dody Rachmat Wicaksono on 2/22/17.
//  Copyright © 2017 Semen Indonesia. All rights reserved.
//

#import "TaxViewController.h"
#import "TaxDetailViewCell.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"

@interface TaxViewController (){
    NSArray *list;
}

@end

@implementation TaxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"TAX Wapu";
    
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
    
    [manager POST:@"http://dev-app.semenindonesia.com/dev/approval2/index.php/mobile/mob_payment" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray * _Nullable responseObject) {
        
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaxDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *item = [list objectAtIndex:indexPath.row];
    
//    cell.title.text = [item objectForKey:@"person"];//[NSString stringWithFormat:@"PO No. %@",[item objectForKey:@"po"]];
//    cell.date.text = [NSString stringWithFormat:@"Date: %@",[item objectForKey:@"date"]];
//    cell.from.text = [NSString stringWithFormat:@"From: %@",[item objectForKey:@"t_from"]];
//    cell.to.text = [NSString stringWithFormat:@"To: %@",[item objectForKey:@"t_to"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

@end
