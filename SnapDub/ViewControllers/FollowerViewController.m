//
//  FollowerViewController.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-07-06.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "FollowerViewController.h"
#import "SingleUserCell.h"
#import "DubUser.h"
#import "DubUserActivityParseHelper.h"

#define PAGE_LIMIT 10

@implementation FollowerViewController
@synthesize userTable, mode;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadingView = [[PFLoadingView alloc] initWithFrame:CGRectZero];
    self.loadingView.frame = self.view.bounds;
    [self.view addSubview:self.loadingView];

    usersList = [NSMutableArray array];
    
    [self loadUsersList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadUsersList
{
    //NSLog(@"loadUserList");
    if(!initialized)
        self.loadingView.hidden = NO;
    
    if(self.mode == FOLLOWERS_MODE)
    {
        [DubUserActivityParseHelper GetAllUsersThatFollowAUserInBackground:self.connectedUser.connectedParseObject pageLimit:PAGE_LIMIT pageNum:pageNum cachePolicy:kPFCachePolicyNetworkOnly block:^(NSArray *results, NSError *error) {
        
                if(!error)
                {
                    [usersList addObjectsFromArray: results];
                    pageNum++;
                }
            
                if(error || [results count]<PAGE_LIMIT)
                {
                    shouldStopLoadMore = YES;
                }
            
            initialized = YES;
            [self.userTable reloadData];
            self.loadingView.hidden = YES;
            
        }];
    }else
    {
        [DubUserActivityParseHelper GetAllFollowingUsersOfAUserInBackground:self.connectedUser.connectedParseObject pageLimit:PAGE_LIMIT pageNum:pageNum cachePolicy:kPFCachePolicyNetworkOnly block:^(NSArray *results, NSError *error) {
            
            
            if(!error)
            {
                [usersList addObjectsFromArray: results];
                pageNum++;
            }
            
            if(error || [results count]<PAGE_LIMIT)
            {
                shouldStopLoadMore = YES;
            }
            
            initialized = YES;
            [self.userTable reloadData];
            self.loadingView.hidden = YES;
        }];
    }
}

- (UITableViewCell *) getLoadMoreCell
{
    
    static NSString *CellIdentifier = @"loadMoreCell";
    UITableViewCell* cell = [self.userTable dequeueReusableCellWithIdentifier: CellIdentifier];
    if (!cell)
    {
        [self.userTable registerNib:[UINib nibWithNibName:@"LoadMoreCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell =[self.userTable dequeueReusableCellWithIdentifier:CellIdentifier];
    }

    return cell;
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!shouldStopLoadMore && initialized)
        return [usersList count] + 1;
    
    return [usersList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!shouldStopLoadMore && indexPath.row == [usersList count] && initialized)
    {
            [self loadUsersList];
        
        return [self getLoadMoreCell];
    }

    //NSLog(@"Follow a user Type Cell");
        
    static NSString *CellIdentifier = @"userCell";
        
    SingleUserCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"SingleUserCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    DubUser* user = [usersList objectAtIndex: indexPath.row];
    [cell setConnectedUser: user];
   // [cell setConnectedActivity: activity];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *myCell = [tableView cellForRowAtIndexPath:indexPath];
    if([myCell isKindOfClass: [SingleUserCell class]])
    {
        [(SingleUserCell*) myCell cellIsSelected];
       
    }
}


- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
