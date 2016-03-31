//
//  DubCategoryTableViewCell.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-06-03.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "DubCategoryTableViewCell.h"
#import "DubSoundBoard.h"
#import "TrendingCategoryListViewController.h"
#import "AppDelegate.h"
#import "DubCategory.h"

@implementation DubCategoryTableViewCell
@synthesize title, iconImage, connectedSoundboard, uiController, connectedCategory, mode;


-(void) setConnectedSoundboard:(DubSoundBoard *)connectedSoundboard2
{
    self.title.text = @"";
    self.iconImage.hidden = YES;

    connectedSoundboard = connectedSoundboard2;
    self.title.text = connectedSoundboard.soundBoardName;
   
    
    if(connectedSoundboard.coverImageFile != [NSNull null] )
    {
        
        //NSLog(@"CoverImageFile URL %@ length %d", connectedSoundboard.coverImageFile.url, connectedSoundboard.coverImageFile.url.length);
        
        self.iconImage.file = connectedSoundboard.coverImageFile;
        
        //Use this to fix Parse's PFImageView not showing Bug
        [connectedSoundboard.coverImageFile getDataInBackground];
      
        [self.iconImage loadInBackground:^(UIImage *image, NSError *error) {
            
            //NSLog(@"Load Soundboard Image error %@ and height %f", error, image.size.height);
            
            if (image.size.height>0 && !error) {
                self.iconImage.hidden = NO;
            }
            
        }];
        
    }

    self.selectionStyle = UITableViewCellSelectionStyleGray;
}

-(void) setConnectedCategory:(DubCategory *)connectedCategory2
{
    self.title.text = @"";
    self.iconImage.hidden = YES;
    connectedCategory = connectedCategory2;
    
    self.title.text = connectedCategory.categoryName;
    
    if(connectedCategory.iconImageFile.url)
    {
        self.iconImage.file = connectedCategory.iconImageFile;
        
        [self.iconImage loadInBackground:^(UIImage *image, NSError *error) {
            if (image.size.height>0 && !error) {
                self.iconImage.hidden = NO;
            }
        }];
    }
 
    self.selectionStyle = UITableViewCellSelectionStyleGray;
}

-(void) cellIsSelected
{
    if(self.mode == SHOW_VIDEO_MODE)
    {
        [self.uiController performSegueWithIdentifier:@"goExplore" sender: self.connectedCategory];
        return;
    }
    
    if(connectedSoundboard)
    {
        TrendingCategoryListViewController *controller = [uiController.storyboard instantiateViewControllerWithIdentifier:@"trendingCategoryList"];
        
        controller.connectedSoundBoard = self.connectedSoundboard;
        controller.mode = SOUNDS_IN_SOUNDBOARD_MODE;
        
        [uiController.navigationController pushViewController:controller animated:YES];
    }
    else if (connectedCategory)
    {
        
        TrendingCategoryListViewController *controller = [uiController.storyboard instantiateViewControllerWithIdentifier:@"trendingCategoryList"];
        
        controller.connectedDubCategory = self.connectedCategory;
        controller.mode = CATEGORY_FEATURE_MODE;
        
        [uiController.navigationController pushViewController:controller animated:YES];
    }
}

@end
