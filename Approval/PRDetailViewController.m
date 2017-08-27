//
//  PRDetailViewController.m
//  Approval
//
//  Created by Ryan Fabella on 2/22/17.
//  Copyright © 2017 Semen Indonesia. All rights reserved.
//

#import "PRDetailViewController.h"
#import "PRDetailViewCell.h"
#import "ApprovalHistoryViewCell.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"

@interface PRDetailViewController (){
    NSArray *list;
    NSArray *listHistory;
}
@property (weak, nonatomic) IBOutlet UILabel *nopr;
@property (weak, nonatomic) IBOutlet UILabel *owner;
@property (weak, nonatomic) IBOutlet UILabel *nominal;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *tvHistory;
@property (weak, nonatomic) IBOutlet UILabel *lbApprovalHistory;

- (IBAction)btnApproveTapped:(id)sender;
- (IBAction)btnRejectTapped:(id)sender;


@end

@implementation PRDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"data: %@",_data);
    
    _nopr.text = [NSString stringWithFormat:@"%@",[_data objectForKey:@"pr"]];
    _owner.text = [_data objectForKey:@"created_by"];
    _nominal.text = [_data objectForKey:@"amount"];
    
    list = [_data objectForKey:@"detailpr"];
    
//    if ([[_data objectForKey:@"histPR"] isEqualToString:@"<null>"]) {
//        listHistory = @[];
//    }
//    else {
//        listHistory = [_data objectForKey:@"histPR"];
//    }
    
    if (![[_data objectForKey:@"histPR"] isKindOfClass:[NSNull class]]) {
        NSLog(@"class: %@",[[_data objectForKey:@"histPR"] class]);
        listHistory = [_data objectForKey:@"histPR"];
    }
    else {
        listHistory = @[];
        _lbApprovalHistory.hidden = YES;
    }
    
//    if (listHistory.count==0) {
//        listHistory = @[];
//    }
    
    //listHistory = [_data objectForKey:@"histPR"];
    [self.tableView reloadData];
    [self.tvHistory reloadData];

}

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
        PRDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        

        NSDictionary *item = [list objectAtIndex:indexPath.row];
        
        cell.pr.text = [item objectForKey:@"itempr"];//[NSString stringWithFormat:@"PO No. %@",[item objectForKey:@"po"]];
        cell.material.text = [item objectForKey:@"material"];
        cell.qty.text = [item objectForKey:@"quantity"];
        cell.nominal.text = [item objectForKey:@"amount"];
        cell.date.text = [item objectForKey:@"delv_date"];
        
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


- (void)doApproval {
    [SVProgressHUD showWithStatus:@"Please wait.."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] forKey:@"username"];
    [param setObject:[_data objectForKey:@"pr"] forKey:@"pr"];
    [param setObject:[_data objectForKey:@"rcode"] forKey:@"rc"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:@"https://approval.semenindonesia.com/sgg/approval2/index.php/mobile/mob_pr_list/do_approve" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        
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
    [param setObject:[_data objectForKey:@"pr"] forKey:@"pr"];
    [param setObject:[_data objectForKey:@"rcode"] forKey:@"rc"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:@"https://approval.semenindonesia.com/sgg/approval2/index.php/mobile/mob_pr_list/do_reject" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadPR" object:nil];
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
