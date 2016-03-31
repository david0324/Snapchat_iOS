//
//  AddIconViewController.m
//  SnapDub
//
//  Created by Poland on 07/05/15.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "AddIconViewController.h"
#import "AddIconCollectionViewCell.h"
#import "DubUser.h"
#import "DubSoundBoardCollectionManager.h"
#import "SDConstants.h"
#import "GeneralUtility.h"

@interface AddIconViewController ()

@end

@implementation AddIconViewController

@synthesize selectedItemIndexPath,images, soundBoardName;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    loadingView = [[PFLoadingView alloc] initWithFrame:CGRectZero];
    loadingView.frame = self.view.bounds;
    [self.view addSubview: loadingView];
    loadingView.hidden = YES;
    
    // Do any additional setup after loading the view.
    images = [NSArray arrayWithObjects:
              @"iconDog.png",
              @"iconMan.png",
              @"iconCheel.png",
              @"iconBone.png",
              @"iconDoc.png",
              nil];
}

- (IBAction)goCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) timeOut
{
    
    timeOut = YES;
    
    [GeneralUtility showTimeOutMessage];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)processCreate:(id)sender {
    /*
    if(![GeneralUtility isParseReachable])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                        message:@"Cannot connect to the server. Can't create the soundboard."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    */
    
    loadingView.hidden = NO;
    [GeneralUtility scheduleTimeOut: self];
    
    [ [DubUser CurrentDubUser].dubSoundboardCollectionManager createSoundBoardAndSaveToParse:self.soundBoardName presetIconName: [images objectAtIndex: selectedItemIndexPath.row]  block:^(BOOL result, NSError *error) {

        loadingView.hidden = YES;
        [GeneralUtility cancelTimeOut:self];
        if(timeOut)
            return;
        
        if(!error && result)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName: EVENT_SOUNDBOARD_CREATED object:nil];
        }else
        {
            [self timeOut];
            return;
        }
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    AddIconCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed: [images objectAtIndex: indexPath.row]];
    
    if (self.selectedItemIndexPath != nil && [indexPath compare:self.selectedItemIndexPath] == NSOrderedSame) {
        cell.imageView.layer.borderColor = [[UIColor redColor] CGColor];
        cell.imageView.layer.borderWidth = 4.0;
    } else {
        cell.imageView.layer.borderColor = nil;
        cell.imageView.layer.borderWidth = 0.0;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // always reload the selected cell, so we will add the border to that cell
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithObject:indexPath];
    
    if (self.selectedItemIndexPath)
    {
        // if we had a previously selected cell
        
        if ([indexPath compare:self.selectedItemIndexPath] == NSOrderedSame)
        {
            // if it's the same as the one we just tapped on, then we're unselecting it
            
            self.selectedItemIndexPath = nil;
        }
        else
        {
            // if it's different, then add that old one to our list of cells to reload, and
            // save the currently selected indexPath
            
            [indexPaths addObject:self.selectedItemIndexPath];
            self.selectedItemIndexPath = indexPath;
        }
    }
    else
    {
        // else, we didn't have previously selected cell, so we only need to save this indexPath for future reference
        
        self.selectedItemIndexPath = indexPath;
    }
    
    // and now only reload only the cells that need updating
    
    [collectionView reloadItemsAtIndexPaths:indexPaths];
}


@end
