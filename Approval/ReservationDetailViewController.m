//
//  ReservationDetailViewController.m
//  Approval
//
//  Created by dody on 5/29/17.
//  Copyright © 2017 Semen Indonesia. All rights reserved.
//

#import "ReservationDetailViewController.h"
#import "ReservationDetailViewCell.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"

@interface ReservationDetailViewController ()

@end

@implementation ReservationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 140;
    
    _reservasinum.text = [NSString stringWithFormat:@"Reservasi No. %@",[_data objectForKey:@"no_reservasi"]];
    _plant.text = [NSString stringWithFormat:@"Plant: %@",[_data objectForKey:@"plant"]];
    _nominal.text = [NSString stringWithFormat:@"Total Value: %@",[_data objectForKey:@"tot_val"]];
    
    list = [_data objectForKey:@"reservation_detail"];
    [self.tableView reloadData];
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
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReservationDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *item = [list objectAtIndex:indexPath.row];
    
    cell.reservasi.text = @"";//[item objectForKey:@"no_reservasi"];//[NSString stringWithFormat:@"PO No. %@",[item objectForKey:@"po"]];
    //
    cell.material.text = @"";
    cell.qty.text = @"";
    cell.nominal.text = @"";
    cell.reservasi.numberOfLines = 0;
    
    NSString *priceRelease = [[item objectForKey:@"price_realease"] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *totalValue = [[item objectForKey:@"total_value"] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    cell.reservasi.text = [NSString stringWithFormat:@"Item No: %@\nMaterial No: %@\nMaterial: %@\nQTY: %@\nQTY Release: %@\nMRP Controller: %@\nPrice Release: %@\nNet Value: %@\nTotal Value: %@",[item objectForKey:@"item_number"],[item objectForKey:@"material_number"],[item objectForKey:@"material_description"],[item objectForKey:@"quantity_real"],[item objectForKey:@"quantity_realease"],[item objectForKey:@"mrp_controller"],priceRelease,[item objectForKey:@"net_value"],totalValue];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 90;
//}

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
    [param setObject:[_data objectForKey:@"no_reservasi"] forKey:@"rsnum"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:@"http://dev-app.semenindonesia.com/dev/approval2/index.php/mobile/mob_reservation/set_approve" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray * _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        //list = responseObject;
        
        //NSLog(@"responseObject: %@",responseObject);
        NSDictionary *result = [responseObject firstObject];
        
        NSLog(@"result: %@",result);
        
        if ([[result objectForKey:@"status"] isEqualToString:@"FAIL"]) {
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"SIM Approval"
                                         message:@"Anda gagal menyetujui item tersebut"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* okButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           //[self doBack];
                                           //[self populateData];
                                       }];
            
            [alert addAction:okButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"reloadReservation" object:nil];
        }
        else {
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"SIM Approval"
                                         message:@"Anda sukses menyetujui item tersebut"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* okButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           [self doBack];
                                           //[self populateData];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadReservation" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
