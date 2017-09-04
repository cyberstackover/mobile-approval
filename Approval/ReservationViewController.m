//
//  ReservationViewController.m
//  Approval
//
//  Created by ryanthe on 5/28/17.
//  Copyright © 2017 Semen Indonesia. All rights reserved.
//

#import "ReservationViewController.h"
#import "ReservationDetailViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "ReservationViewCell.h"


@interface ReservationViewController (){
    NSArray *list;
    NSString *approvalInput;
}

@end

@implementation ReservationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 140;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadReservation)
                                                 name:@"reloadReservation" object:nil];
    
    self.title = @"Reservation";
    
    [self populateData];
    
}

- (void)reloadReservation {
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
    
    NSString *s1 = @"http://localhost/reservasi.php";
    NSString *s2 = @"http://dev-app.semenindonesia.com/dev/approval2/index.php/mobile/mob_reservation";
    
    // s2 pakai POST, s1 GET
    [manager POST:s2 parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        
        NSLog(@"responseObject: %@", [responseObject objectForKey:@"data"]);
        
        [SVProgressHUD dismiss];
        
        list = [responseObject objectForKey:@"data"];
        
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
    ReservationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *item = [list objectAtIndex:indexPath.row];
    
    /*
     "material_description" = "SPAREPART TEST";
     "material_number" = "623-600001";
     "mrp_controller" = 203;
     "no_reservasi" = 51566186;
     "price_realease" = "          103101601";
     quantity = "101000.000";
     "quantity_realease" = 100981;
     --
     "no_reservasi": "51566186",
     "plant": "7902",
     "tot_val": 101000000,
     "reservation_detail"
     */
    
    cell.title.text = [NSString stringWithFormat:@"Reservasi No. %@",[item objectForKey:@"no_reservasi"]];
    //cell.detail.text = [NSString stringWithFormat:@"%@\nMaterial No. %@\nMRP: %@\nQTY: %@\nQTY Release: %@",[item objectForKey:@"material_description"],[item objectForKey:@"material_number"],[item objectForKey:@"mrp_controller"],[item objectForKey:@"quantity"],[item objectForKey:@"quantity_realease"]];
    //cell.nominal.text = [NSString stringWithFormat:@"%@",[item objectForKey:@"tot_val"]];//[item objectForKey:@"tot_val"];
    
    cell.nominal.hidden = YES;
    cell.detail.text = [NSString stringWithFormat:@"Plant: %@",[item objectForKey:@"plant"]];
    
    cell.detail.numberOfLines = 0;
    
    //    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
    //    tapGestureRecognizer.numberOfTapsRequired = 1;
    //    tapGestureRecognizer.numberOfTouchesRequired = 1;
    
    //    [cell addGestureRecognizer:tapGestureRecognizer];
    
    /*
    cell.tag = indexPath.row;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 2.0; //seconds
    [cell addGestureRecognizer:lpgr];
    */
    return cell;
}

-(void)cellTapped:(UITapGestureRecognizer*)tap {
    // Your code here
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state==UIGestureRecognizerStateBegan) {
        NSLog(@"long press");
        
        longPressIndex = longPress.view.tag;
        
        UIAlertController* alert = [UIAlertController
                                    alertControllerWithTitle:@"SIM Approval"
                                    message:@"Apa yg ingin anda lakukan?"
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* approveButton = [UIAlertAction
                                        actionWithTitle:@"Approve"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            //[self doApproval];
                                            [self showApprovalInput];
                                        }];
        
        //        UIAlertAction* rejectButton = [UIAlertAction
        //                                       actionWithTitle:@"Reject"
        //                                       style:UIAlertActionStyleDefault
        //                                       handler:^(UIAlertAction * action) {
        //                                           [self doReject];
        //                                       }];
        
        UIAlertAction* cancelButton = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           //Handle no, thanks button
                                       }];
        
        [alert addAction:approveButton];
        //[alert addAction:rejectButton];
        [alert addAction:cancelButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if (longPress.state==UIGestureRecognizerStateEnded) {
        
    }
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
    
    NSDictionary *data = [list objectAtIndex:longPressIndex];
    
    [SVProgressHUD showWithStatus:@"Please wait.."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] forKey:@"username"];
    [param setObject:[data objectForKey:@"no_reservasi"] forKey:@"rsnum"];
    [param setObject:approvalInput forKey:@"ECE"];
    
    NSLog(@"approval param: %@",param);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:@"http://dev-app.semenindonesia.com/dev/approval2/index.php/mobile/mob_reservation/set_approve" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray * _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        //list = responseObject;
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
                                           [self populateData];
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
                                           //[self doBack];
                                           [self populateData];
                                       }];
            
            [alert addAction:okButton];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error: %@",error);
        [SVProgressHUD dismiss];
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return 250;
//    
//    NSDictionary *item = [list objectAtIndex:indexPath.row];
//    
//    if ([[item objectForKey:@"material_description"] length]>12*3) {
//        return 150;
//    }
//    else {
//        return 120;
//    }
//    
//    
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *item = [list objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    
    if ([[item objectForKey:@"reservation_detail"] isKindOfClass:[NSNull class]]) {
        // do nothing
    }
    else {
        [self performSegueWithIdentifier:@"detail" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //reservation_detail
    NSDictionary *item = [list objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    
    NSLog(@"item: %@",item);
    
    ReservationDetailViewController *vc = segue.destinationViewController;
    vc.data = item;
}

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
