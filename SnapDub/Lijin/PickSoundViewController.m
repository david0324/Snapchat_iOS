//
//  PickSoundViewController.m
//  SnapDub
//
//  Created by admin on 10/12/15.
//  Copyright © 2015 wjs. All rights reserved.
//

#import "PickSoundViewController.h"

@interface PickSoundViewController ()

@end

@implementation PickSoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(IBAction)onBack:(id)sender
{
    AddViewController *v_view = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddViewController"];
    [self.navigationController pushViewController:v_view animated:YES];
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
