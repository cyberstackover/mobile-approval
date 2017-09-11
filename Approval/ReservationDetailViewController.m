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

@interface ReservationDetailViewController (){
    NSString *approvalInput;
}

@end

@implementation ReservationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 140;
    
    _reservasinum.text = [NSString stringWithFormat:@"Reservasi No. %@",[_data objectForKey:@"no_reservasi"]];
    _plant.text = [NSString stringWithFormat:@"Plant: %@",[_data objectForKey:@"plant"]];
    //_nominal.text = [NSString stringWithFormat:@"Total Value: %@",[_data objectForKey:@"tot_val"]];
    _nominal.hidden = YES;
    
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
    
    
    
    NSString *priceRelease = [item objectForKey:@"price_realease"]; //stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *totalValue = [item objectForKey:@"total_value"]; //stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *qtyRelease = [item objectForKey:@"quantity_realease"]; //stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    cell.lbTop.text = [NSString stringWithFormat:@"Item No: %@\nMaterial No: %@\nMaterial: %@",[item objectForKey:@"item_number"],[item objectForKey:@"material_number"],[item objectForKey:@"material_description"]];
    
    //cell.lbLeft.text = [NSString stringWithFormat:@"QTY: %@\nQTY Release: %@\nMRP Controller: %@",[item objectForKey:@"quantity_real"],qtyRelease,[item objectForKey:@"mrp_controller"]];
    
    //cell.lbRight.text = [NSString stringWithFormat:@"Price Release: %@\nNet Value: %@\nTotal Value: %@",priceRelease,[item objectForKey:@"net_value"],totalValue];
    
    cell.lbLeft.text = @"QTY: \nQTY Release: \nMRP Controller: \nPrice Release: \nNet Value: \nTotal Value: ";
    
    cell.lbRight.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@",[item objectForKey:@"quantity_real"],qtyRelease,[item objectForKey:@"mrp_controller"],priceRelease,[item objectForKey:@"net_value"],totalValue];
    cell.lbRight.textAlignment = NSTextAlignmentRight;
    
    cell.tfEce.tag = [[item objectForKey:@"item_number"] intValue];
    cell.tfEce.text = [NSString stringWithFormat:@"%d",[[item objectForKey:@"ece"] intValue]];
    cell.tfEce.placeholder = @"";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (NSString*)getECEValues {
    NSArray *allTf = [self findAllTextFieldsInView:self.view];
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    for (UITextField *t in allTf) {
        
        if ([t.text length]==0) {
            [values addObject:[NSNumber numberWithInt:25]];
        }
        else {
            [values addObject:[NSNumber numberWithInt:[t.text intValue]]];
        }
    }
    
    return [values componentsJoinedByString: @","];
}

- (NSArray*)findAllTextFieldsInView:(UIView*)view{
    NSMutableArray* textfieldarray = [[NSMutableArray alloc] init];
    for(id x in [view subviews]){
        if([x isKindOfClass:[UITextField class]])
            [textfieldarray addObject:x];
        
        if([x respondsToSelector:@selector(subviews)]){
            // if it has subviews, loop through those, too
            [textfieldarray addObjectsFromArray:[self findAllTextFieldsInView:x]];
        }
    }
    
    // sort by tag
    
    NSSortDescriptor *ascendingSort = [[NSSortDescriptor alloc] initWithKey:@"tag" ascending:YES];
    NSArray *sortedArray = [textfieldarray sortedArrayUsingDescriptors:[NSArray arrayWithObject:ascendingSort]];
    
    return sortedArray;
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
                                    //[self showApprovalInput];
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

- (void)showApprovalInput {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"Reservasi Approval"
                                        message:@"Silahkan memasukkan nilai ECE"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"Nilai ECE";
        textField.textAlignment = NSTextAlignmentCenter;
        approvalInput = textField.text;
    }];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   approvalInput = [alert.textFields firstObject].text;
                                   NSLog(@"Nilai ECE: %@",approvalInput);
                                   [self doApproval];
                               }];
    
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:TRUE completion:^{
        
    }];
    
}


- (void)doApproval {
    
    NSString *ece = [self getECEValues];
    
    [SVProgressHUD showWithStatus:@"Please wait.."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] forKey:@"username"];
    [param setObject:[_data objectForKey:@"no_reservasi"] forKey:@"rsnum"];
    [param setObject:[_data objectForKey:@"plant"] forKey:@"plant"];
    [param setObject:ece forKey:@"price"];
    
    NSLog(@"approval param: %@",param);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:@"https://approval.semenindonesia.com/sgg/approval2/index.php/mobile/mob_reservation/set_approve_ece" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray * _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        //list = responseObject;
        
        //NSLog(@"responseObject: %@",responseObject);
        NSDictionary *result = [responseObject firstObject];
        
        NSLog(@"result: %@",result);
        
        if ([[result objectForKey:@"status"] isEqualToString:@"FAIL"]) {
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"SIM Approval"
                                         message:[result objectForKey:@"returnmsg"]
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
                                         message:[result objectForKey:@"returnmsg"]
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
