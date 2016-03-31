//
//  ActivityViewController.m
//  SnapDub
//
//  Created by Poland on 06/05/15.
//  Copyright (c) 2015 Yuan. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityTableViewCell.h"

#import "FollowTableViewCell.h"
#import "ActivVideoTableViewCell.h"

#import "FirstViewController.h"
#import "DubUserActivityParseHelper.h"
#import "UserActivity.h"
#import "DubUser.h"
#import "SDConstants.h"
#import "ActivVideoTableViewCell.h"

#define LIMIT_PER_PAGE 10
#define LOAD_MORE_CELL_TAG -999
@import MediaPlayer;


@interface ActivityViewController ()
{
    NSMutableArray *aryActivity;
}
@end

@implementation ActivityViewController
@synthesize loadingView;

-(void) stopRefresh: (UIRefreshControl*) control
{
 //   if(control.isRefreshing)
        [control endRefreshing];
}

- (void)refresh:(UIRefreshControl *)refreshControl {

    [self reloadActivities];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName: EVENT_STOP_PLAYING object:nil];
}
- (void)loadView {
    [super loadView];
    
    
    self.loadingView = [[PFLoadingView alloc] initWithFrame:CGRectZero];
    self.loadingView.frame = self.view.bounds;
    [self.view addSubview:self.loadingView];
    
    refreshController = [[UIRefreshControl alloc] init];
    refreshController.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    
    [refreshController addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.tvActivity addSubview: refreshController];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    //[self.tvActivity registerNib:[UINib nibWithNibName:@"FollowTableViewCell" bundle:nil] forCellReuseIdentifier:@"followCell"];
    
    activities = [NSMutableArray array];
    
   // [self loadActivities];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
        
        FirstViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FirstViewController"];
        
        [self.navigationController pushViewController:vc animated:YES];
        vc.backButton.hidden = YES;
        //[self performSegueWithIdentifier:@"goFirstView" sender:nil];
    }else
    {
        if ([_tvActivity numberOfRowsInSection: 0]<1) {
            [self loadActivities];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) reloadActivities
{
    pageNum = 0;
    initialized = NO;
    shouldStopLoadMore = NO;
    
    [activities removeAllObjects];
    [self.tvActivity reloadData];
    
    [self loadActivities];
}

-(void) loadActivities
{
    if(!initialized)
        [self.loadingView setHidden: NO];
    
    [DubUserActivityParseHelper GetAllActivityOfAllFollowingUsers:LIMIT_PER_PAGE pageNum:pageNum cachePolicy:kPFCachePolicyNetworkOnly block:^(NSArray *results, NSError *error) {
       
        //NSLog(@"Activity Count %d and pageNum is %d", (int) [results count], pageNum);
        initialized = YES;
        if(!error)
        {
            [activities addObjectsFromArray: results];
            pageNum++;
        }
        
        if(error || [results count] < LIMIT_PER_PAGE)
        {
            shouldStopLoadMore = YES;
        }
        
        [self.tvActivity reloadData];
        [self.loadingView setHidden: YES];
        [refreshController endRefreshing];
    }];
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!shouldStopLoadMore && initialized)
        return [activities count] + 1;
    
    return [activities count];
}

- (UITableViewCell *) getLoadMoreCell
{
    
    static NSString *CellIdentifier = @"loadMoreCell";
    UITableViewCell* cell = [self.tvActivity dequeueReusableCellWithIdentifier: CellIdentifier];
    if (!cell)
    {
        [self.tvActivity registerNib:[UINib nibWithNibName:@"LoadMoreCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell =[self.tvActivity dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    cell.tag = LOAD_MORE_CELL_TAG;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!shouldStopLoadMore && indexPath.row == [activities count])
    {
        if(initialized)
            [self loadActivities];
        
        return [self getLoadMoreCell];
    }
    
    int index =  (int)indexPath.row;
    
    UserActivity* activity = [activities objectAtIndex: index];
    //NSLog(@"Type String %@", activity.activityType);
    if( [activity.activityType isEqualToString: kSDUserActivityActivityTypeFollowAUserValue])
    {
        //NSLog(@"Follow a user Type Cell");
        
        static NSString *CellIdentifier = @"followCell";
        
        FollowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"FollowTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }

        [cell setConnectedActivity: activity];
        return cell;
    }
    else if( [activity.activityType isEqualToString: kSDUserActivityActivityTypePostADubSoundValue] || [activity.activityType isEqualToString: kSDUserActivityActivityTypeLikeADubSoundValue] )
    {
        //NSLog(@"Sound Type Cell");
        static NSString *CellIdentifier = @"activityCell";
        ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"ActivityTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        [cell setConnectedActivity: activity];
        return cell;
    }else
    {
         //NSLog(@"Video Type Cell");
        static NSString *CellIdentifier = @"ActivVideoCell";
        ActivVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"ActivVideoCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        [cell setConnectedActivity: activity];
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath: indexPath];
    
    if([cell isKindOfClass: [ActivVideoTableViewCell class]])
    {
        [((ActivVideoTableViewCell*)cell) cellIsSelected];
    }
    else if([cell isKindOfClass: [ActivityTableViewCell class]])
    {
        [((ActivityTableViewCell*)cell) cellIsSelected];
    }else
    {
        [((FollowTableViewCell*)cell) cellIsSelected];
    }
}


-(void) processUserImage:(UIImageView *)imageview
{
    imageview.layer.cornerRadius = imageview.frame.size.height / 2;
    imageview.layer.masksToBounds = YES;
    imageview.layer.borderWidth = 0;
    [imageview.layer setBorderColor:[[UIColor colorWithRed:209.0 / 255.0 green:209.0 / 255.0 blue:209.0 / 255.0 alpha:1.0] CGColor]];
    float fBorderWidth = imageview.frame.size.height / 30;
    [imageview.layer setBorderWidth:fBorderWidth];
}


@end
