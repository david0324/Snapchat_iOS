//
//  AddViewController.m
//  SnapDub
//
//  Created by admin on 10/8/15.
//  Copyright © 2015 wjs. All rights reserved.
//

#import "AddViewController.h"

@interface AddViewController ()

@end

@implementation AddViewController

@synthesize btn_shootfirst;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController  setNavigationBarHidden:YES animated:YES];
    // Do any additional setup after loading the view.

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    //NSLog(@"asdasdasdasdasdasdasd = %@",self.navigationController);
    [self.navigationController  setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) onPickSound:(id)sender
{
    PickSoundViewController *v_view = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PickSoundViewController"];
    [self.navigationController pushViewController:v_view animated:NO];
}

-(IBAction) onShootFirst:(id)sender
{
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    ShootFirstViewController *controller = [delegate.navi.storyboard instantiateViewControllerWithIdentifier:@"ShootFirstViewController"];
    [GeneralUtility pushViewController: controller animated: NO];
}

-(IBAction) onImport:(id)sender
{
    ImportViewController *v_view = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ImportViewController"];
    [self.navigationController pushViewController:v_view animated:NO];
}

@end
