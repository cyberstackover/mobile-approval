//
//  LoginViewController.m
//  Approval
//
//  Created by Dody Rachmat Wicaksono on 2/15/17.
//  Copyright © 2017 Semen Indonesia. All rights reserved.
//

#import "LoginViewController.h"
//#import "AFURLSessionManager.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *vwTop;
@property (weak, nonatomic) IBOutlet UITextField *tfUsername;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;


- (IBAction)btnLoginTapped:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"loginbv"]];
    _vwTop.backgroundColor = background;
    
    _tfUsername.text = @"amin.erfandy";
    _tfPassword.text = @"aminkerja";

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

- (IBAction)btnLoginTapped:(id)sender {
    [SVProgressHUD showWithStatus:@"Logging in.."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:_tfUsername.text forKey:@"username"];
    [param setObject:_tfPassword.text forKey:@"passuser"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"Basic Z3Nrc3RhZ2luZzY6TGlmZVdvcnRoTGl2aW5nMTc=" forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:@"http://dev-app.semenindonesia.com/dev/approval2/index.php/mobile/c_auth" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSDictionary *result = responseObject;
        
        NSLog(@"result: %@",result);
        
        if ([[result objectForKey:@"loginreturn"] boolValue]) {
            NSLog(@"login sukses");
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"home"];
            [[[[UIApplication sharedApplication] windows] firstObject] setRootViewController:vc];
        }
        else {
            NSLog(@"login gagal");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Approval" message:@"Login gagal" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error: %@",error);
        [SVProgressHUD dismiss];
    }];}
@end
