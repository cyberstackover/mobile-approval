//
//  TaxViewController.m
//  Approval
//
//  Created by Ryan Fabella on 2/22/17.
//  Copyright © 2017 Semen Indonesia. All rights reserved.
//

#import "TaxViewController.h"
#import "TaxViewCell.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "TaxDetailViewController.h"

@interface TaxViewController (){
    NSArray *list;
}

@end

@implementation TaxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTax)
                                                 name:@"reloadTax" object:nil];
    
    self.title = @"TAX Wapu";
    
    [self populateData];
    
}

- (void)reloadTax {
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
    
    [manager POST:@"https://approval.semenindonesia.com/sgg/approval2/index.php/mobile/mob_payment" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        list = [responseObject objectForKey:@"header"];
        item = [responseObject objectForKey:@"item"];
        
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
    TaxViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *item2 = [list objectAtIndex:indexPath.row];
    
    cell.title.numberOfLines = 0;
    cell.title.text = [item2 objectForKey:@"DESC"];//[NSString stringWithFormat:@"SSP No. %@",[item objectForKey:@"DESC"]];
    //cell.date.text = [NSString stringWithFormat:@": %@",[item objectForKey:@""]];
    //cell.nominal.text = [NSString stringWithFormat:@"Nominal: %@",[item objectForKey:@""]];
    cell.detail.text = [NSString stringWithFormat:@"Vendor: %@",[item2 objectForKey:@"AMOUNT"]];
    cell.date.hidden = YES;
    cell.nominal.hidden = YES;
    
    cell.tag = indexPath.row;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 2.0; //seconds
    [cell addGestureRecognizer:lpgr];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
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
        
        UIAlertAction* cancelButton = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           //Handle no, thanks button
                                       }];
        
        [alert addAction:approveButton];
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
    [param setObject:[data objectForKey:@"month"] forKey:@"month"];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"detail" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //NSDictionary *item = [list objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    
    TaxDetailViewController *vc = segue.destinationViewController;
    vc.data = item;
    vc.header = [list firstObject];
}


@end
