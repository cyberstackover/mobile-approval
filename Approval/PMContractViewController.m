//
//  PMContractViewController.m
//  Approval
//
//  Created by Ryan Fabella on 2/22/17.
//  Copyright © 2017 Semen Indonesia. All rights reserved.
//

#import "PMContractViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "POContractViewCell.h"
#import "POContractDetailViewController.h"

@interface PMContractViewController (){
    NSArray *list;
}

@end

@implementation PMContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadPOContract)
                                                 name:@"reloadPOContract" object:nil];

    self.title = @"PO Contract";
    
    [self populateData];
    
}

- (void)reloadPOContract {
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
    
    [manager POST:@"http://dev-app.semenindonesia.com/dev/approval2/index.php/mobile/mob_po_contract" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray * _Nullable responseObject) {
        
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    POContractViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    NSDictionary *item = [list objectAtIndex:indexPath.row];
    
    cell.title.text = [NSString stringWithFormat:@"PO No. %@",[item objectForKey:@"po"]];
    cell.detail.text = [item objectForKey:@"vendor"];
    cell.nominal.text = [item objectForKey:@"harga"];
    
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
//    tapGestureRecognizer.numberOfTapsRequired = 1;
//    tapGestureRecognizer.numberOfTouchesRequired = 1;
    
//    [cell addGestureRecognizer:tapGestureRecognizer];
    
    cell.tag = indexPath.row;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 2.0; //seconds
    [cell addGestureRecognizer:lpgr];
    
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
                                            [self doApproval];
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


- (void)doApproval {
    
    NSDictionary *data = [list objectAtIndex:longPressIndex];

    [SVProgressHUD showWithStatus:@"Please wait.."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] forKey:@"username"];
    [param setObject:[data objectForKey:@"po"] forKey:@"po"];
    [param setObject:[data objectForKey:@"rcode"] forKey:@"rc"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:@"http://dev-app.semenindonesia.com/dev/approval2/index.php/mobile/mob_po_contract/approve_contract" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        
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
                                           //[self doBack];
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"detail" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSDictionary *item = [list objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    
    POContractDetailViewController *vc = segue.destinationViewController;
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
