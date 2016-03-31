//
//  ResultViewController.m
//  SnapDub
//
//  Created by Poland on 08/05/15.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "ExploreResultViewController.h"
#import "DubsTableViewCell.h"
#import "DubsCollectionViewCell.h"
#import "DubFeaturedContentsParseHelper.h"
#import "DubCategory.h"
#import "GeneralUtility.h"
#import "CategorySelectionViewController.h"
#import "AppDelegate.h"
#import "SDConstants.h"
//TESTING should be 20
#define QUERY_LIMIT 20

@implementation ExploreResultViewController
@synthesize usExplore, uvCollection, uvTable, tvExplore, category, needToRefresh;

-(void) resetPageNumAndRefresh
{
    pageNum = 0;
    shouldStopLoadMore = NO;
    
    [videosList removeAllObjects];
    if(self.segment.selectedSegmentIndex<1)
    {
        
        [self loadFeatureVideosContents];
    }else
    {
        [self loadLatestVideosContents];
    }
}

-(void) stopRefresh: (UIRefreshControl*) control
{
    // if(control.isRefreshing)
    [control endRefreshing];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    // Do your job, when done:
    //NSLog(@"REFRESHING");
    //   [self.tvProfile reloadData];
    
    [self resetPageNumAndRefresh];
}

-(void) loadMoreContents
{
    if(self.segment.selectedSegmentIndex<1)
    {
        
        [self loadFeatureVideosContents];
    }else
    {
        [self loadLatestVideosContents];
    }
}
-(void) loadFeatureVideosContents
{
    //Cassandra start
   /* NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:@"Jekyll" size:12], NSFontAttributeName,
                                [UIColor blueColor], NSFontAttributeName, nil];
    [self.segment setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    NSDictionary *highlightedAttributes = [NSDictionary
                                           dictionaryWithObject:[UIColor whiteColor] forKey:NSFontAttributeName];
    [self.segment setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];*/
    //Cassandra end
    PFCachePolicy policy = kPFCachePolicyNetworkElseCache;
    
    /*
    if(![GeneralUtility isParseReachable])
    {
        policy = kPFCachePolicyCacheOnly;
    }
    */
    
    if(pageNum<1)
    {
        [tvExplore setHidden: YES];
        [self.loadingView setHidden: NO];
    }
    
    [DubFeaturedContentsParseHelper GetTopDubVideosFromACategory:self.category.connectedPFObject limit:QUERY_LIMIT pageNum:pageNum cachePolicy:policy block:^(NSArray * results, NSError *error) {
     
        //NSLog(@"GetTopDubVideosFromACategory %@ and ERROR %@", results, error);
        //NSLog(@"GetTopDubVideosFromACategory count %d and pageNum %d", (int)[ results count], pageNum);
        if(!error)
        {
            [videosList addObjectsFromArray:results];
            pageNum++;
            
        }
     
     if(error || [results count] < QUERY_LIMIT)
     {
         shouldStopLoadMore = YES;
     }else
     {
         shouldStopLoadMore = NO;
     }
     
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [tvExplore setHidden: NO];
            [self.tvExplore reloadData];
            [self.loadingView setHidden: YES];
            [refreshController endRefreshing];
        });
 }];

}

-(void) loadLatestVideosContents
{
    //Cassandra start
    /*NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:@"Jekyll" size:12], NSFontAttributeName,
                                [UIColor blueColor], NSFontAttributeName, nil];
    [self.segment setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    NSDictionary *highlightedAttributes = [NSDictionary
                                           dictionaryWithObject:[UIColor whiteColor] forKey:NSFontAttributeName];
    [self.segment setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];*/
    //Cassandra end
    
    PFCachePolicy policy = kPFCachePolicyNetworkOnly;
    
    if(![GeneralUtility isParseReachable])
    {
        policy = kPFCachePolicyCacheOnly;
    }
    
    [DubFeaturedContentsParseHelper GetRecentDubVideosFromACategory:self.category.connectedPFObject limit:QUERY_LIMIT pageNum:pageNum cachePolicy:policy block:^(NSArray * videos, NSError *error) {
        
        //NSLog(@"GetRecentDubVideosFromACategory count %d and pageNum %d", (int)[ videos count], pageNum);
        if(!error)
        {
            [videosList addObjectsFromArray: videos];
            pageNum++;
        }
        
        if(error || [videos count]< QUERY_LIMIT)
        {
            shouldStopLoadMore = YES;
        }else
        {
            shouldStopLoadMore = NO;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tvExplore reloadData];
            [self.loadingView setHidden: YES];
            [refreshController endRefreshing];
        });
    }];
    
}

- (IBAction)segmentValueChanged:(id)sender {
    [self resetPageNumAndRefresh];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName: EVENT_STOP_PLAYING object:nil];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    
    if(!category)
    {
        [self.categoryButton setTitle: @"All Categories⌵" forState:UIControlStateNormal];
        //Cassandra
        /*self.categoryButton.titleLabel.font = [UIFont fontWithName:@"Jekyll" size:17];*/
    }else
    {
        [self.categoryButton setTitle: [NSString stringWithFormat:@"%@ ⌵", category.categoryName ] forState:UIControlStateNormal];
        //Cassandra
      /*  self.categoryButton.titleLabel.font = [UIFont fontWithName:@"Jekyll" size:17];*/
    }
    
    if(needToRefresh)
    {
        needToRefresh = NO;
        pageNum = 0;
        [videosList removeAllObjects];
        [tvExplore setContentOffset:CGPointZero animated:YES];
        [self loadMoreContents];
    }
}

- (void)loadView {
    [super loadView];
    
    
    self.loadingView = [[PFLoadingView alloc] initWithFrame:CGRectZero];
    self.loadingView.frame = self.view.bounds;
    [self.view addSubview:self.loadingView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    videosList = [NSMutableArray array];
    
    self.theTitle.text = self.category.categoryName;
   
    //cassandra
    
    // Do any additional setup after loading the view.
   // uvTable.hidden = YES;
    
    uvTable.hidden  = NO;
    uvCollection.hidden = YES;
    
    pageNum = 0;
    [self.segment setSelectedSegmentIndex: 0];
    [self loadFeatureVideosContents];
    
    [self.categoryButton.titleLabel setTextAlignment: NSTextAlignmentCenter];
    
    refreshController = [[UIRefreshControl alloc] init];
    refreshController.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    
    [refreshController addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.tvExplore addSubview: refreshController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView

{
    return 1;
    
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(indexPath.row< [videosList count] )
    {
        return 470;
    }else
    {
        return 44;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([videosList count]<1)
    {
        return 0;
    }
    
    if(!shouldStopLoadMore)
    {
    return [videosList count] +1;
    }
    
    return [videosList count];
}

- (UITableViewCell *) getLoadMoreCell
{
    
    static NSString *CellIdentifier = @"loadMoreCell";
    UITableViewCell* cell = [self.tvExplore dequeueReusableCellWithIdentifier: CellIdentifier];
    if (!cell)
    {
        [self.tvExplore registerNib:[UINib nibWithNibName:@"LoadMoreCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell =[self.tvExplore dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
  //  //NSLog(@"cellForRowAtIndexPath %d and %d",(int) indexPath.row, (int)[videosList count]);
    if(indexPath.row< [videosList count] )
    {
    static NSString *CellIdentifier = @"dubsTableCell";
    DubsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
        cell.navController = self.navigationController;
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"DubsTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    cell.tableView = self.tvExplore;
        
        
        [cell setConnectedDubVideo: [videosList objectAtIndex:indexPath.row]];

        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[cell.celPlayer currentItem]];
        
        cell.Paused = NO;
        [cell updatePosition];
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        return cell;
    }else
    {
        //[self loadFeatureVideosContents];
   //     [self performSelector:@selector(loadMoreContents) withObject:nil afterDelay:0.4];
        if(!shouldStopLoadMore)
        [self loadMoreContents];
        shouldStopLoadMore = YES;
        
        return [self getLoadMoreCell];
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DubsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.navController = self.navigationController;
    //[cell setConnectedDubVideo: [videosList objectAtIndex:indexPath.row]];
    
    [cell cellIsSelected];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

- (IBAction)categoryButtonClicked:(id)sender {
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    CategorySelectionViewController *controller = [delegate.navi.storyboard instantiateViewControllerWithIdentifier:@"CategorySelectionViewController"];
    
   // [controller setConnectedDubUser: connectedActivity.fromUserRef];
    controller.hidesBottomBarWhenPushed = YES;
    controller.mode = EXPLORE_CATEGORY_SELECTION_MODE;
    controller.exploreResultViewController = self;
    
    [UIView animateWithDuration:0.75
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [self.navigationController pushViewController:controller animated:NO];
                         [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
                     }];
    
    //[GeneralUtility pushViewController: controller animated: YES];
}


#pragma UIScrollView
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSArray *a=[self.tvExplore visibleCells];

    for(UITableViewCell *topCell in a)
    {
        if([topCell isKindOfClass: [DubsTableViewCell class] ])
            
            [(DubsTableViewCell*)topCell updatePosition];
    }
}

@end
