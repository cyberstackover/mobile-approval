//
//  OvertimeViewController.m
//  Approval
//
//  Created by Ryan Fabella on 2/22/17.
//  Copyright © 2017 Semen Indonesia. All rights reserved.
//

#import "OvertimeViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "OvertimeViewCell.h"

@interface OvertimeViewController (){
    NSArray *list;
}

@end

@implementation OvertimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Overtime";
    
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
    
    [manager POST:@"http://dev-app.semenindonesia.com/dev/approval2/index.php/mobile/mob_hris/get_lembur" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        
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
    OvertimeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *item = [list objectAtIndex:indexPath.row];
    
    cell.person.text = [item objectForKey:@"mk_nama"];//[NSString stringWithFormat:@"PO No. %@",[item objectForKey:@"po"]];
    cell.detail.text = [item objectForKey:@"ot_ti"];
    cell.date.text = [NSString stringWithFormat:@"Date: %@",[item objectForKey:@"ot_date"]];
    cell.begin.text = [NSString stringWithFormat:@"From: %@",[item objectForKey:@"ot_begin"]];
    cell.end.text = [NSString stringWithFormat:@"To: %@",[item objectForKey:@"ot_end"]];

    cell.tag = indexPath.row;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 2.0; //seconds
    [cell addGestureRecognizer:lpgr];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
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
                                            [self doApproval];
                                        }];
        
        UIAlertAction* rejectButton = [UIAlertAction
                                       actionWithTitle:@"Reject"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           [self doReject];
                                       }];
        
        UIAlertAction* cancelButton = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           //Handle no, thanks button
                                       }];
        
        [alert addAction:approveButton];
        [alert addAction:rejectButton];
        [alert addAction:cancelButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if (longPress.state==UIGestureRecognizerStateEnded) {
        
    }
}

- (void)doApproval {
    NSDictionary *data = [list objectAtIndex:longPressIndex];
    
    [SVProgressHUD showWithStatus:@"Please wait.."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] forKey:@"username"];
    [param setObject:@"Y" forKey:@"type"];
    [param setObject:[data objectForKey:@"ot_id"] forKey:@"ot_id"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:@"http://dev-app.semenindonesia.com/dev/approval2/index.php/mobile/mob_hris/approve_lembur" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        
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
                                           [self populateData];
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
    NSDictionary *data = [list objectAtIndex:longPressIndex];
    
    [SVProgressHUD showWithStatus:@"Please wait.."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] forKey:@"username"];
    [param setObject:@"X" forKey:@"type"];
    [param setObject:[data objectForKey:@"ot_id"] forKey:@"ot_id"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:@"http://dev-app.semenindonesia.com/dev/approval2/index.php/mobile/mob_hris/approve_lembur" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        
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
                                           [self populateData];
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

@end
