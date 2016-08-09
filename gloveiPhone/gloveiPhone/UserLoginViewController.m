//
//  UserLoginViewController.m
//  gloveiPhone
//
//  Created by 艾海涛 on 30/11/2015.
//  Copyright © 2015 geilove. All rights reserved.
//

#import "UserLoginViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import<QuartzCore/QuartzCore.h>
@interface UserLoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;
@property (weak, nonatomic) IBOutlet UITextField *userEmail;

@property (weak, nonatomic) IBOutlet UITextField *userPassword;

@end


@implementation UserLoginViewController
@synthesize userEmail;
@synthesize userPassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self setDefaultEmail:@"邮箱最大不超过32位"];
    //[self setDefaultPassword:@"6-16位字母数字特殊字符组成"];
    userEmail.textColor=[UIColor redColor];
    userEmail.backgroundColor=[UIColor whiteColor];
    userEmail.borderStyle = UITextBorderStyleRoundedRect;
    userEmail.clearButtonMode = UITextFieldViewModeAlways;
    userEmail.layer.cornerRadius = 3.0;
    
    self.view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    
    [self.view addGestureRecognizer:singleTap];
    userPassword.delegate=self;
    userEmail.delegate=self;
   
}
-(void)setDefaultEmail:(NSString*)str
{
    userEmail.text=str;
}
-(void)setDefaultPassword:(NSString*)str
{
    userPassword.text=str;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.userEmail resignFirstResponder];
    [self.userPassword resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer

{
    
    [self.view endEditing:YES];
    
}

- (IBAction)loginAction:(id)sender {
    NSLog(@"这里测试登录");
    //首先先获得用户输入的邮箱和密码
    NSString *getUserEmail=self.userEmail.text;
    NSString *getUserPassword=self.userPassword.text;
    //调用工具类判断用户名和密码是否合法，这里先这么写上，毕竟刚开始学习
    //    if([getUserEmail length]>16 || getUserEmail.length <6){
    //        NSLog(@"用户邮箱输入不合法");
    //        return ;
    //    }else if (getUserPassword.length>20 || getUserPassword.length <6){
    //        NSLog(@"用户密码不合法");
    //        return;
    //    }
    //若果合法，就发送请求
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    //声明请求的类型是json类型
    manager.requestSerializer =[AFJSONRequestSerializer serializer];
    //声明返回的类型是json类型
    // manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //如果报接受类型不一致请替换一致application/json或者别的
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"application/json"];
    //传入参数
    // NSDictionary *parameters=@{@"userEmail":getUserEmail,@"userPassword":getUserPassword };
    NSDictionary *parameters=@{@"userEmail":@"alooge@126.com",@"userPassword":@"123456"};
    //NSDictionary *parameters=@{@"userNickName":@"aww",@"userEmail":@"asd@126.com",@"userPassword":@"123456",@"userPassRepeat":@"123456" };
    
    //传入阿里云服务器地址
    NSString *url=@"http://123.56.112.178:8080/glove/user/login";
    //发送请求
    [manager
     POST:url
     parameters:parameters
     success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
         
         // NSLog(@"JSON: %@", responseObject); //打印出二进制形式
         
         NSString *result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSLog(@"JSON1:%@",result); //result是NSString类型，在这里就可以使用了
         
         
         NSMutableDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         NSLog(@"dic=%@",dic);//转换成字典形式
         if(dic!=NULL){
             NSLog(@"有这个用户");
             NSUserDefaults *userProfile=[NSUserDefaults standardUserDefaults];
             //[userProfile setObject:dic forKey:@"userProfile"]; 因为包含byte类型，所以这个报错
             //提取出dic中的数据，一个个保存，很蛋疼，这里先保存一部分马上要用到的
             NSNumber *userid=[dic objectForKey:@"userid"];
             [userProfile setObject:userid forKey:@"userid"];
             NSString *usernickname=[dic objectForKey:@"usernickname"];
             [userProfile setObject:usernickname forKey:@"usernickname"];
             NSString *useremail=[dic objectForKey:@"useremail"];
             [userProfile setObject:useremail forKey:@"useremail"];
             NSString *userpassword=[dic objectForKey:@"userpassword"];
             [userProfile setObject:userpassword forKey:@"userpassword"];
             //为了确保数据持久化
             [[NSUserDefaults standardUserDefaults] synchronize];
             //接下来，程序条件跳转到主页（包含各种项目基金等的页面），好像又得查找资料了
             [self performSegueWithIdentifier:@"d" sender:nil];
             
             
             
             
         }
         
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"Error: %@", error);
     }];
    
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

@end
