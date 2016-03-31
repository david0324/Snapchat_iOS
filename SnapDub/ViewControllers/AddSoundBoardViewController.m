//
//  AddBoardViewController.m
//  SnapDub
//
//  Created by Poland on 07/05/15.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "AddSoundBoardViewController.h"
#import "AddIconViewController.h"

@interface AddSoundBoardViewController ()

@end

@implementation AddSoundBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [_nameField becomeFirstResponder];
    [self updateNextButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goNext:(id)sender {
    [self performSegueWithIdentifier:@"goSelectIcon" sender:nil];
}

-(void) updateNextButton
{
    _nextButton.hidden  = ([_nameField.text length]<1);
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AddIconViewController *detailVC = segue.destinationViewController;
    //  detailVC.category = [categoryList objectAtIndex:indexPath.row];
    detailVC.soundBoardName = self.soundboardNameField.text;
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                             withString:string];
    [self updateNextButton];
    // Now you can use the value of textField.text for whatever you need to do.
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
   
    if([_nameField.text length]>0)
    {
        [self performSegueWithIdentifier:@"goSelectIcon" sender:nil];
       
    }
    return NO;
}
@end
