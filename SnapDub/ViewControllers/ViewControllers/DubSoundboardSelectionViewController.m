//
//  DubSoundboardSelectionViewController.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-06-29.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "DubSoundboardSelectionViewController.h"
#import "DubSoundBoardCollectionManager.h"
#import "DubSoundBoard.h"
#import "DubUser.h"
#import "DubSoundBoardParseHelper.h"
#import "DubCategoryTableViewCell.h"
//
@interface DubSoundboardSelectionViewController ()

@end

@implementation DubSoundboardSelectionViewController
@synthesize connectedSound;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DubSoundBoard* soundboard = [[DubUser CurrentDubUser].dubSoundboardCollectionManager.userCreatedDubSoundboards objectAtIndex:indexPath.row];
    
    [DubSoundBoardParseHelper AddADubSoundToADubSoundBoardEventuallyWithBlock:connectedSound soundBoard:soundboard block:^(BOOL result, NSError *error) {
        
        if(error)
        {
            //Do the popup
            //NSLog(@"Saving sound to soundboard error %@", error);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[DubUser CurrentDubUser].dubSoundboardCollectionManager.userCreatedDubSoundboards count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"dubCategoryCell";
    DubCategoryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"DubCategoryTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
     DubSoundBoard* soundboard = [[DubUser CurrentDubUser].dubSoundboardCollectionManager.userCreatedDubSoundboards objectAtIndex:indexPath.row];
    [cell setConnectedSoundboard: soundboard];
    
  //  cell.uiController = self;
    return cell;

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
