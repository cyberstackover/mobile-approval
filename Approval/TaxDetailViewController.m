//
//  TaxDetailViewController.m
//  Approval
//
//  Created by Ryan Fabella on 3/10/17.
//  Copyright © 2017 Semen Indonesia. All rights reserved.
//

#import "TaxDetailViewController.h"
#import "TaxDetailViewCell.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"

@interface TaxDetailViewController (){
    NSArray *list;
}

@property (weak, nonatomic) IBOutlet UILabel *nopr;
@property (weak, nonatomic) IBOutlet UILabel *owner;
@property (weak, nonatomic) IBOutlet UILabel *nominal;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)btnApproveTapped:(id)sender;
- (IBAction)btnRejectTapped:(id)sender;


@end

@implementation TaxDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _nopr.text = [_header objectForKey:@"DESC"];
    _owner.text = [_header objectForKey:@"AMOUNT"];
    _nominal.hidden = YES;
    
    list = _data;
    
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
    TaxDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *item = [list objectAtIndex:indexPath.row];
    
    cell.pr.text = [NSString stringWithFormat:@"SSP No. %@",[item objectForKey:@"SSP"]];
    cell.material.text = [item objectForKey:@"VENDOR"];
    cell.qty.text = [item objectForKey:@"STREET"];
    cell.nominal.text = [item objectForKey:@"AMOUNT"];
    cell.date.hidden = YES;
    
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
    [param setObject:[_header objectForKey:@"month"] forKey:@"month"];

    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:@"https://approval.semenindonesia.com/sgg/approval2/index.php/mobile/mob_payment/approve_wapu" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        //list = responseObject;
        
        NSLog(@"responseObject: %@",responseObject);
        
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"SIM Approval"
                                         message:[responseObject objectForKey:@"msg"]
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
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"SIM Approval"
                                         message:[responseObject objectForKey:@"msg"]
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* okButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           [self doBack];
                                       }];
            
            [alert addAction:okButton];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error: %@",error);
        [SVProgressHUD dismiss];
    }];
    
}



- (void)doBack {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTax" object:nil];
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

@end
