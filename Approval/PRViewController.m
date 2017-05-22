//
//  PRViewController.m
//  Approval
//
//  Created by Ryan Fabella on 2/22/17.
//  Copyright © 2017 Semen Indonesia. All rights reserved.
//

#import "PRViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "PRViewCell.h"
#import "PRDetailViewController.h"

@interface PRViewController () {
    NSArray *list;
}

@end

@implementation PRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Purchase Requsition";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadPR)
                                                 name:@"reloadPR" object:nil];
    
    [self populateData];
    
}

- (void)reloadPR {
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
    
    [manager POST:@"http://dev-app.semenindonesia.com/dev/approval2/index.php/mobile/mob_pr_list" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray * _Nullable responseObject) {
        
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PRViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *item = [list objectAtIndex:indexPath.row];
    
    cell.title.text = [NSString stringWithFormat:@"PR No. %@",[item objectForKey:@"pr"]];
    cell.detail.text = [item objectForKey:@"stext"];//[[[item objectForKey:@"detailpr"] firstObject] objectForKey:@"material"];
    cell.nominal.text = [item objectForKey:@"amount"];
    cell.date.text = [item objectForKey:@"c_date"];
    
    //NSLog(@"pr: %@",[item objectForKey:@"pr"]);
    
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
//    tapGestureRecognizer.numberOfTapsRequired = 1;
//    tapGestureRecognizer.numberOfTouchesRequired = 1;
//    cell.tag = indexPath.row;
//    [cell addGestureRecognizer:tapGestureRecognizer];
    
    cell.tag = indexPath.row;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 2.0; //seconds
    [cell addGestureRecognizer:lpgr];
    
    return cell;
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
    [param setObject:[data objectForKey:@"pr"] forKey:@"pr"];
    [param setObject:[data objectForKey:@"rcode"] forKey:@"rc"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:@"http://dev-app.semenindonesia.com/dev/approval2/index.php/mobile/mob_pr_list/do_approve" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        
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
    
    long ip = self.tableView.indexPathForSelectedRow.row;
    NSDictionary *data = [list objectAtIndex:ip];
    
    [SVProgressHUD showWithStatus:@"Please wait.."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] forKey:@"username"];
    [param setObject:[data objectForKey:@"pr"] forKey:@"pr"];
    [param setObject:[data objectForKey:@"rcode"] forKey:@"rc"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:@"http://dev-app.semenindonesia.com/dev/approval2/index.php/mobile/mob_pr_list/do_reject" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        
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


//-(void)cellTapped:(UITapGestureRecognizer*)tap
//{
//    // Your code here
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"detail" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSDictionary *item = [list objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    
    PRDetailViewController *vc = segue.destinationViewController;
    vc.data = item;
}


@end
