//
//  BosDetailViewController.m
//  Approval
//
//  Created by Ryan Fabella on 3/10/17.
//  Copyright © 2017 Semen Indonesia. All rights reserved.
//

#import "BosDetailViewController.h"
#import "BosDetailViewCell.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"

@interface BosDetailViewController (){
    NSArray *list;
}

@property (weak, nonatomic) IBOutlet UILabel *bilNo;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *nominal;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)btnApproveTapped:(id)sender;
- (IBAction)btnRejectTapped:(id)sender;


@end

@implementation BosDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bilNo.text = [NSString stringWithFormat:@"Bil No. %@",[_data objectForKey:@"BIL_NO"]];
    _name.text = [_data objectForKey:@"NAME1"];
    _nominal.text = [_data objectForKey:@"amount"];
    
    list = [_data objectForKey:@"item"];
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BosDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *item = [list objectAtIndex:indexPath.row];
    
    cell.pr.text = [item objectForKey:@"BELNR"];//[NSString stringWithFormat:@"PO No. %@",[item objectForKey:@"po"]];
    cell.material.text = [item objectForKey:@"comname"];
    cell.qty.text = [item objectForKey:@"desc"];
    cell.nominal.text = [item objectForKey:@"amount"];
    cell.date.hidden = YES;
    //cell.date.text = [item objectForKey:@"delv_date"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}


- (void)doApproval {
    [SVProgressHUD showWithStatus:@"Please wait.."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] forKey:@"username"];
    [param setObject:@"Y" forKey:@"type"];
    [param setObject:[_data objectForKey:@"BUKRS"] forKey:@"ct_bukrs"];
    [param setObject:[_data objectForKey:@"p_level"] forKey:@"p_level"];
    [param setObject:[_data objectForKey:@"p_col"] forKey:@"p_col"];
    [param setObject:[_data objectForKey:@"BIL_NO"] forKey:@"BIL_NO"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:@"https://approval.semenindonesia.com/sgg/approval2/index.php/mobile/mob_payment/approve_bos_out" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        
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

- (void)doReject {
    [SVProgressHUD showWithStatus:@"Please wait.."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] forKey:@"username"];
    [param setObject:@"X" forKey:@"type"];
    [param setObject:[_data objectForKey:@"BUKRS"] forKey:@"ct_bukrs"];
    [param setObject:[_data objectForKey:@"p_level"] forKey:@"p_level"];
    [param setObject:[_data objectForKey:@"p_col"] forKey:@"p_col"];
    [param setObject:[_data objectForKey:@"BIL_NO"] forKey:@"BIL_NO"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:@"https://approval.semenindonesia.com/sgg/approval2/index.php/mobile/mob_payment/approve_bos_out" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        //list = responseObject;
        
        NSLog(@"responseObject: %@",responseObject);
        
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"SIM Approval"
                                         message:@"Anda sukses tidak menyetujui item tersebut"
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBos" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)btnApproveTapped:(id)sender {
    UIAlertController * alert = [UIAlertController
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

- (IBAction)btnRejectTapped:(id)sender {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"SIM Approval"
                                 message:@"Apakah anda ingin tidak menyetujui item ini"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ya"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    [self doReject];
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
@end
