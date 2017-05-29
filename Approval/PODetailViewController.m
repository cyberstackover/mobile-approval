//
//  PODetailViewController.m
//  Approval
//
//  Created by Ryan Fabella on 3/6/17.
//  Copyright © 2017 Semen Indonesia. All rights reserved.
//

#import "PODetailViewController.h"
#import "PODetailViewCell.h"
#import "ApprovalHistoryViewCell.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"

@interface PODetailViewController ()

@end

@implementation PODetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"data: %@",_data);
    
    _ponum.text = [_data objectForKey:@"po"];
    _vendor.text = [_data objectForKey:@"vendor"];
    _nominal.text = [_data objectForKey:@"harga"];
    
    list = [_data objectForKey:@"podetail"];

    if (![[_data objectForKey:@"histPO"] isKindOfClass:[NSNull class]]) {
        NSLog(@"class: %@",[[_data objectForKey:@"histPO"] class]);
        listHistory = [_data objectForKey:@"histPO"];
    }
    else {
        listHistory = @[];
        _lbApprovalHistory.hidden = YES;
    }

    
    [self.tableView reloadData];
    [self.tvHistory reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView==self.tableView) {
        return list.count;
    }
    else {
        return listHistory.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==self.tableView) {
        PODetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        NSDictionary *item = [list objectAtIndex:indexPath.row];
        
        cell.po.text = [item objectForKey:@"itempo"];//[NSString stringWithFormat:@"PO No. %@",[item objectForKey:@"po"]];
        cell.material.text = [item objectForKey:@"material"];
        cell.qty.text = [item objectForKey:@"quantity"];
        cell.nominal.text = [item objectForKey:@"amount"];
        cell.date.text = [item objectForKey:@"deldate"];
        
        return cell;
    }
    else {
        ApprovalHistoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.backgroundColor = ([indexPath row]%2)?[UIColor colorWithRed:0.95 green:0.84 blue:0.86 alpha:1.0]:[UIColor colorWithRed:0.94 green:0.63 blue:0.71 alpha:1.0];
        NSDictionary *item = [listHistory objectAtIndex:indexPath.row];
        
        cell.title.text = [item objectForKey:@"person"];
        cell.date.text = [item objectForKey:@"dateTimes"];
        
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==self.tableView) {
        return 90;
    }
    else {
        return 50;
    }
}

- (IBAction)btnTapped:(id)sender {
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:@"SIM Approval"
                                message:@"Apakah anda ingin menyetujui item ini"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ya"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    [self doApproval];
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Tidak"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)doApproval {
    [SVProgressHUD showWithStatus:@"Please wait.."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] forKey:@"username"];
    [param setObject:[_data objectForKey:@"po"] forKey:@"po"];
    [param setObject:[_data objectForKey:@"rcode"] forKey:@"rc"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:@"http://dev-app.semenindonesia.com/dev/approval2/index.php/mobile/mob_po_list/do_approve_po" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        //list = responseObject;
        
        NSLog(@"responseObject: %@",responseObject);
        
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"SIM Approval"
                                         message:@"Anda sukses menyetujui item tersebut"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* okButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           [self doBack];
                                       }];
            
            [alert addAction:okButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"reloadPOContract" object:nil];
        }
        else {
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error: %@",error);
        [SVProgressHUD dismiss];
    }];
    
}

- (void)doBack {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadPO" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
