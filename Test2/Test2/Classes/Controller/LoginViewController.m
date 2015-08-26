//
//  LoginViewController.m
//  Test2
//
//  Created by Alex Tran on 8/26/15.
//  Copyright (c) 2015 Alex Tran. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import "MainViewController.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)touchLogin:(id)sender;

@end

@implementation LoginViewController

#pragma mark - Life Cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Touch Action
- (IBAction)touchLogin:(id)sender {
    //Valid textField username
    if ([_usernameTextField.text isEqual:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Username can not nil" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    //Valid textField password
    if ([_passwordTextField.text isEqual:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Password can not nil" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
//    if ([User checkLoginWithUsername:_usernameTextField.text andPassword:_passwordTextField.text]) {
//        // Login success
//        MainViewController *mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
//        [self.navigationController pushViewController:mainViewController animated:YES];
//    }else{
//        // Login fail
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Username or password is not correct" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertView show];
//    }
    // Call MainViewController
    MainViewController *mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    mainViewController.username = _usernameTextField.text;
    mainViewController.password = _passwordTextField.text;
    [self.navigationController pushViewController:mainViewController animated:YES];
}
@end
