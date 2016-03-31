//
//  CategorySelectionViewController.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-07-08.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "CategorySelectionViewController.h"
#import "FeaturedContentsManager.h"
#import "CategorySelectionCell.h"
#import "DubCategory.h"
#import "ExploreResultViewController.h"
#import "DubSoundCreator.h"
#import "TrendingCategoryListViewController.h"
#import "DubUser.h"
#import "GeneralUtility.h"
#import "DubVideoCreator.h"

@interface CategorySelectionViewController ()

@end

@implementation CategorySelectionViewController
@synthesize theTitle, mode, selectedIndex, exploreResultViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    loadingView = [[PFLoadingView alloc] initWithFrame:CGRectZero];
    loadingView.frame = self.view.bounds;
    [self.view addSubview: loadingView];
    loadingView.hidden = YES;
    
    // Do any additional setup after loading the view.
    [self loadCategories];
    
    if(mode == SOUND_CATEGORY_SELECTION_MODE)
    {
        theTitle.text = @"Select a category for the sound";
        _cancelButton.hidden = YES;
        _backButton.hidden = NO;
    }
    else if(mode == VIDEO_CATEGORY_SELECTION_MODE)
    {
        theTitle.text = @"Select a category for the video";
        _cancelButton.hidden = YES;
        _backButton.hidden = NO;
    }
    else
    {
        theTitle.text = @"Categories";
        _cancelButton.hidden = NO;
        _backButton.hidden = YES;
}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setMode:(int)mode2
{
    mode = mode2;
    
    if(mode == SOUND_CATEGORY_SELECTION_MODE)
    {
        theTitle.text = @"Select a category for the sound";
        _cancelButton.hidden = YES;
    }
    else if(mode == VIDEO_CATEGORY_SELECTION_MODE)
    {
        theTitle.text = @"Select a category for the video";
        _cancelButton.hidden = YES;
    }
    else
    {
        theTitle.text = @"Categories";
        _cancelButton.hidden = NO;
    }
}

-(void) loadCategories
{
    [FeaturedContentsManager GetAllCategories:^(NSArray * categories, NSError * error) {
        if(categories)
        {
            categoryArray = [NSArray arrayWithArray: categories];
        }else
        {
            categoryArray = [NSArray array];
        }
        
        DubCategory* chosenCategory = self.exploreResultViewController.category;
       
        if(chosenCategory == nil)
        {
            selectedIndex = 0;
        }else
        {
            for(int i=0; i<[categoryArray count]; i++)
            {
                DubCategory* category = [categoryArray objectAtIndex: i];
                if ([category.categoryName isEqualToString: chosenCategory.categoryName]) {
                    selectedIndex = i+1;
                }
            }
        }
        
        initialized = YES;
        [_categoryList reloadData];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString *CellIdentifier = @"CategorySelectionCell";
    
    CategorySelectionCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if (!cell)
    {
        [_categoryList registerNib:[UINib nibWithNibName:@"CategorySelectionCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell =[_categoryList dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    if(self.mode == EXPLORE_CATEGORY_SELECTION_MODE )
    {
        if(indexPath.row==0)
        {
            cell.categoryLabel.text = @"All Categories";
        }else
        {
            cell.categoryLabel.text = ((DubCategory*)[categoryArray objectAtIndex: indexPath.row-1]).categoryName;
        }
    }else
    {
        cell.categoryLabel.text = ((DubCategory*)[categoryArray objectAtIndex: indexPath.row]).categoryName;
    }
    
    if(self.mode == EXPLORE_CATEGORY_SELECTION_MODE )
    {
        [cell setCategoryIsSelected: self.selectedIndex== indexPath.row];
    }else
    {
        [cell setCategoryIsSelected: NO];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!initialized)
        return 0;
    
    if(self.mode == EXPLORE_CATEGORY_SELECTION_MODE )
    {
        return [categoryArray count] + 1;
    }else
    {
        return [categoryArray count];
    }
}

-(void) timeOut
{
  
    timeOut = YES;
    
    [GeneralUtility showTimeOutMessage];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_categoryList deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.mode == EXPLORE_CATEGORY_SELECTION_MODE ) {
        
        if(selectedIndex != indexPath.row)
        {
        if(indexPath.row>0)
        {
            self.exploreResultViewController.category = (DubCategory*)[categoryArray objectAtIndex: indexPath.row-1];
            }else
            {
                self.exploreResultViewController.category = nil;
            }
            self.exploreResultViewController.needToRefresh = YES;
        }
    
        [self.navigationController popViewControllerAnimated:YES];
    }

    if (self.mode == SOUND_CATEGORY_SELECTION_MODE )
    {
        loadingView.hidden = NO;
        
        [GeneralUtility scheduleTimeOut: self];
        
        [DubSoundCreator setCategory: [categoryArray objectAtIndex: indexPath.row]];
        [DubSoundCreator CreateADubSoundByCurrentUserInBackground:^(BOOL result, NSError *error) {
            //NSLog(@"Sound CreateADubSoundByCurrentUserInBackground result %d", result );
        
            [GeneralUtility cancelTimeOut:self];
            if(timeOut)
                return;
            
            if(!result || error)
            {
                [self timeOut];
                return;
            }
            
            loadingView.hidden = YES;
            
            if(result)
            {
                TrendingCategoryListViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"trendingCategoryList"];
        
                controller.dubUser = [DubUser CurrentDubUser];
                controller.mode = USER_CREATED_SOUNDS_MODE;
                controller.hidesBottomBarWhenPushed = YES;
        
                [self.navigationController pushViewController:controller animated:YES];
            }
        }];

    }
    
    if (self.mode == VIDEO_CATEGORY_SELECTION_MODE ) {
        
        [DubVideoCreator setDubCategory: [categoryArray objectAtIndex: indexPath.row]];
   
        [self performSegueWithIdentifier:@"DMVideoShareIdentifier2" sender:nil];
    }
}

- (IBAction)cancelClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
