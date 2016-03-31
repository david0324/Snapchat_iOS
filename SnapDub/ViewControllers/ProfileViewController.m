//
//  ProfileViewController.m
//  SnapDub
//
//  Created by Poland on 06/05/15.
//  Copyright (c) 2015 Yuan. All rights reserved.
//

#import "ProfileViewController.h"
#import "DubsTableViewCell.h"
#import "CommentViewController.h"
#import "DubUser.h"
#import "DubUserActivityParseHelper.h"
#import "MySoundsTableViewCell.h"
#import "SoundTableViewCell.h"
#import "DubSoundParseHelper.h"
#import "DubVideoParseHelper.h"
#import "GeneralUtility.h"
#import "TrendingCategoryListViewController.h"
#import "FirstViewController.h"
#import "FollowerViewController.h"
#import "AppDelegate.h"
#import "UIImage+BlurredFrame.h"
#import "BDBSpinKitRefreshControl.h"
#import "SDConstants.h"

#define VIDEO_LIMIT 5

#import "FirstViewController.h"
@interface ProfileViewController ()
{
    NSMutableArray *aryPosts;
    NSMutableDictionary *dicUser;
}
@end

@implementation ProfileViewController
@synthesize imgBackground, imgprofile, lblname, lblFollowers, lblFollowing, lblPosts, lblLikes, followed, backButton, followButton;

-(void) loadMoreVideoInBackground
{
    if(self.connectedDubUser.connectedParseObject==nil)
        return;
    
    PFCachePolicy policy = kPFCachePolicyNetworkOnly;
    
    if(![GeneralUtility isParseReachable])
    {
        policy = kPFCachePolicyCacheOnly;
    }
    
    //NSLog(@"PageNum is %d", pageNum);
    
    [DubVideoParseHelper GetAllDubVideoCreatedOrLikedByAUserInBackground:self.connectedDubUser.connectedParseObject cachePolicy:policy limitPerPage:VIDEO_LIMIT pageNum:pageNum block:^(NSArray *results, NSError *error) {
        
        if(!error)
        {
            [videoList addObjectsFromArray: results];
            pageNum ++;
        }
        
        if(error || [results count] < VIDEO_LIMIT)
        {
            shouldStopLoadingMore = YES;
        }else
        {
            shouldStopLoadingMore = NO;
        }
        
        [self.tvProfile reloadData];
        [self.loadingView setHidden: YES];
    }];
}

-(void) loadDataFromParseInBackground
{
    if(self.connectedDubUser == nil)
        return;
    
    //NSLog(@"connected DUBUSER %@",self.connectedDubUser.connectedParseObject.username);
    
    [self.loadingView setHidden: NO];
    videoList = [NSMutableArray array];
    pageNum = 0;
    
    PFCachePolicy policy = kPFCachePolicyNetworkOnly;
    
    if(![GeneralUtility isParseReachable])
    {
        policy = kPFCachePolicyCacheOnly;
    }
    
    /*
    [self.imgBackground loadInBackground:^(UIImage *image, NSError *error) {
        UIImage *img = self.imgBackground.image;
        CGRect frame = CGRectMake(0, 0, img.size.width, img.size.height);
        
        self.imgBackground.image = [self.imgBackground.image applyLightBluredAtFrame:frame];
    }];
    */
    
    [self.imgprofile loadInBackground:^(UIImage *image, NSError *error) {
        //By cassandra
        self.imgprofile.layer.cornerRadius = (self.imgprofile.frame.size.width)/2;
        self.imgprofile.clipsToBounds = YES;
        self.imgprofile.layer.borderWidth = 3.0f;
        self.imgprofile.layer.borderColor = [UIColor whiteColor].CGColor;

        //End by Cassandra
        [GeneralUtility processUserImage: self.imgprofile];
    }];
    
    [DubSoundParseHelper GetAllDubSoundsCreatedByAUserInBackground: self.connectedDubUser.connectedParseObject cachePolicy: policy limitPerPage:3 pageNum:0 block:^(NSArray *results, NSError *error) {
        
        if(!error)
        {
            recentSounds = [NSArray arrayWithArray: results];
        }else
        {
            recentSounds = [NSArray array];
        }
       
        [DubVideoParseHelper GetAllDubVideoCreatedOrLikedByAUserInBackground:self.connectedDubUser.connectedParseObject cachePolicy:policy limitPerPage:VIDEO_LIMIT pageNum:pageNum block:^(NSArray *results, NSError *error) {
            
            if(!error)
            {
                [videoList addObjectsFromArray: results];
                pageNum ++;
            }
            
            if([results count] < VIDEO_LIMIT)
            {
                shouldStopLoadingMore = YES;
            }else
            {
                shouldStopLoadingMore = NO;
            }
            
            initialized = YES;
            [self.tvProfile reloadData];
            [self.loadingView setHidden: YES];
            
            [self stopSpinControler];
            [refreshController endRefreshing];
        }];
            
        }];
        
    [DubUserActivityParseHelper GetNumFollowerInBackground:_connectedDubUser.connectedParseObject cachePolicy:kPFCachePolicyCacheThenNetwork block:^(int numFollower, NSError *error) {
        if(!error)
        {
            //NSLog(@"Num Follower is %d", numFollower);
            [_followerButton setTitle:[NSString stringWithFormat:@"%d Followers", numFollower ] forState:UIControlStateNormal];
            
            theNumFollower = numFollower;
        }
    }];
    
    [DubUserActivityParseHelper GetNumFollowingInBackground:_connectedDubUser.connectedParseObject cachePolicy:kPFCachePolicyCacheThenNetwork block:^(int numFollowing, NSError *error) {
        if(!error)
        {
            //NSLog(@"Num Following is %d", numFollowing);
            [_followingButton setTitle:[NSString stringWithFormat:@"%d Following", numFollowing ] forState:UIControlStateNormal];
            
            theNumFollowing = numFollowing;
}
    }];
    
    if(!_connectedDubUser.profileName)
    {
        self.lblname.text = @"User";
    }else
    {
        self.lblname.text = _connectedDubUser.profileName;
    }
    
    [self updateFollowButton];
}

-(void) updateFollowButtons
{
    [_followerButton setTitle:[NSString stringWithFormat:@"%d Followers", theNumFollower ] forState:UIControlStateNormal];
    [_followingButton setTitle:[NSString stringWithFormat:@"%d Following", theNumFollowing ] forState:UIControlStateNormal];
}

-(void) setConnectedDubUser:(DubUser *)connectedDubUser
{
    
    //NSLog(@"ConnectedDubUser %@ CurrentUser %@",connectedDubUser.connectedParseObject,[PFUser currentUser]);
    
    _connectedDubUser = connectedDubUser;
    if(connectedDubUser.connectedParseObject == nil)
        return;
    
   // self.imgBackground.file = _connectedDubUser.profileImagePFFile;
    self.imgprofile.file = _connectedDubUser.profileImagePFFile;
    
    if([_connectedDubUser isCurrentDubUser])
    {
        [followButton setEnabled: NO];
    }
    
    [self updateFollowButton];
}

-(void) stopSpinControler
{
    if(spinControler.isRefreshing)
        [spinControler endRefreshing];
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
    
    [self loadDataFromParseInBackground];
}

- (void)loadView {
    [super loadView];
    
    
    self.loadingView = [[PFLoadingView alloc] initWithFrame:CGRectZero];
    self.loadingView.frame = self.view.bounds;
    [self.view addSubview:self.loadingView];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
  
    _objects = [NSMutableArray array];
    
    spinControler = [BDBSpinKitRefreshControl refreshControlWithStyle:RTSpinKitViewStyleBounce color:[UIColor blueColor]];
    [spinControler addTarget:self
                            action:@selector(refresh:)
                  forControlEvents:UIControlEventValueChanged];
    spinControler.shouldChangeColorInstantly = YES;
    spinControler.spinner.style = RTSpinKitViewStyleCircle;
    
    refreshController = [[UIRefreshControl alloc] init];
    refreshController.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    
    [refreshController addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.tvProfile addSubview: refreshController];
    [self updateFollowButtons];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName: EVENT_STOP_PLAYING object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: EVENT_STOP_PLAYING object:nil];
    
    //NSLog(@"connected Dub User name %@ ",self.connectedDubUser.connectedParseObject.username);
    if ([PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
            
        FirstViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FirstViewController"];
        
        [self.navigationController pushViewController:vc animated:YES];
        vc.backButton.hidden = YES;
            //[self performSegueWithIdentifier:@"goFirstView" sender:nil];
    }
    else{
        if(_connectedDubUser == nil)
        {
            [self setConnectedDubUser: [DubUser CurrentDubUser]];
            self.backButton.hidden = YES;
            [self loadDataFromParseInBackground];
        }

    }
    
    [self loadDataFromParseInBackground];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateFollowButton
{
    if([self.connectedDubUser isTheSameUser: [DubUser CurrentDubUser] ])
    {
        followButton.hidden = YES;
    }else
    {
        followButton.hidden = NO;
    }
    
    if([self.connectedDubUser isFollowedByCurrentUser])
    {
        [followButton setTitle: @"unfollow" forState:UIControlStateNormal];
        self.followed= YES;
    }else
    {
        [followButton setTitle: @"follow" forState:UIControlStateNormal];
        self.followed= NO;
    }
    
    if(self.followed)
    {
        [followButton setImage:[UIImage imageNamed:@"FollowedButton"] forState:UIControlStateNormal];
    } else
    {
        [followButton setImage:[UIImage imageNamed:@"FollowButton"] forState:UIControlStateNormal];
    }
    //NSLog(@"updateFollowButton followed %d", self.followed);
}

- (IBAction)followButtonClicked:(id)sender {
    if([self.connectedDubUser isFollowedByCurrentUser])
    {
        [self.connectedDubUser unfollow];
        theNumFollower --;
    }else
    {
        [self.connectedDubUser follow];
        theNumFollower ++;
    }
    
    [self updateFollowButtons];
    [self updateFollowButton];
    
    //[self loadDataFromParseInBackground];
}


- (IBAction)followingClicked:(id)sender {
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    FollowerViewController *controller = [delegate.navi.storyboard instantiateViewControllerWithIdentifier:@"FollowerViewController"];
    
    [controller setConnectedUser: self.connectedDubUser];
    controller.hidesBottomBarWhenPushed = YES;
    controller.mode = FOLLOWINGS_MODE;
    
    [GeneralUtility pushViewController: controller animated: YES];

}

- (IBAction)followerClicked:(id)sender {
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    FollowerViewController *controller = [delegate.navi.storyboard instantiateViewControllerWithIdentifier:@"FollowerViewController"];
    
    [controller setConnectedUser: self.connectedDubUser];
    controller.hidesBottomBarWhenPushed = YES;
    controller.mode = FOLLOWERS_MODE;
    
    [GeneralUtility pushViewController: controller animated: YES];
}



#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(indexPath.section<2)
    {
        return 54;
    }
    
    return 470;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return @"Recently Created";
    }
    else if(section==1)
    {
        return @"Sounds and Soundboards";
    }
    return @"Posted and Liked Videos";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return [aryPosts count];
    if(section==0)
    {
        return [recentSounds count];
    }
    else if(section ==1)
    {
        return 3;
    }
    
    
    if(!shouldStopLoadingMore && initialized)
        return [videoList count]+1;
    
    return [videoList count];
}


- (UITableViewCell *) getLoadMoreCell
{
    
    static NSString *CellIdentifier = @"loadMoreCell";
    UITableViewCell* cell = [self.tvProfile dequeueReusableCellWithIdentifier: CellIdentifier];
    if (!cell)
    {
        [self.tvProfile registerNib:[UINib nibWithNibName:@"LoadMoreCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell =[self.tvProfile dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *myCell = [tableView cellForRowAtIndexPath:indexPath];
    if([myCell isKindOfClass: [SoundTableViewCell class]])
    {
        [(SoundTableViewCell*) myCell cellIsSelected];
        return;
    }
    
    if(indexPath.section ==1)
    {
        if(indexPath.row == 0)
        {
            TrendingCategoryListViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"trendingCategoryList"];
            
            controller.dubUser = self.connectedDubUser;
            controller.mode = USER_CREATED_SOUNDS_MODE;
            
            //NSLog(@"self connected DubUSer %@",self.connectedDubUser);
            
            [self.navigationController pushViewController:controller animated:YES];
        }
        else if(indexPath.row == 1)
        {
            //Load user's fav sounds
            TrendingCategoryListViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"trendingCategoryList"];
            
            controller.dubUser = self.connectedDubUser;
            controller.mode = USER_FAV_SOUNDS_MODE;
            
             //NSLog(@"self connected DubUSer %@",self.connectedDubUser);
            
            [self.navigationController pushViewController:controller animated:YES];
        }
        else
        {
            TrendingCategoryListViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"trendingCategoryList"];
            
            controller.dubUser = self.connectedDubUser;
            controller.mode = LIST_OF_SOUNDBOARD_MODE;
            
             //NSLog(@"self connected DubUSer %@",self.connectedDubUser);
            
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
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
    //Sound Cell
    if(indexPath.section==0)
    {
        static NSString *CellIdentifier = @"soundCell";
        
        SoundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
        cell.navController = self.navigationController;
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"SoundTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        DubSound* sound = [recentSounds objectAtIndex: indexPath.row];
        [cell setConnectedDubSound: sound];
        [cell setIndex: (int)indexPath.row];
        return cell;
    }
    
    if(indexPath.section==1)
    {
    
        if(indexPath.row==0)
        {
            static NSString *CellIdentifier = @"boardCell";
            MySoundsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            if (!cell)
            {
                [tableView registerNib:[UINib nibWithNibName:@"MySoundsTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            }
        
            cell.lblName.text = @"Uploaded Sounds";
            //Cassandra
            cell.lblName.textColor = [UIColor grayColor];
            cell.tintColor = [UIColor grayColor];
            //Cassandra
            
            [cell setBackgroundColor:[UIColor clearColor]];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            [cell setIconImageFileName: @"cloudUpload.png"];

            return cell;
        
        }
        else if(indexPath.row==1)
        {
            static NSString *CellIdentifier = @"boardCell";
            MySoundsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            if (!cell)
            {
                [tableView registerNib:[UINib nibWithNibName:@"MySoundsTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            }
            
            //Cassandra
            cell.lblName.textColor = [UIColor grayColor];
            cell.lblName.tintColor =[UIColor grayColor];
            //Cassandra
            cell.lblName.text = @"Favorite Sounds";
            
            [cell setBackgroundColor:[UIColor clearColor]];
            
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            [cell setIconImageFileName: @"smileYellow.png"];

            return cell;
        }
        else if(indexPath.row==2)
        {
            static NSString *CellIdentifier = @"boardCell";
            MySoundsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            if (!cell)
            {
                [tableView registerNib:[UINib nibWithNibName:@"MySoundsTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            }
        
            cell.lblName.text = @"All Soundboards";
            //Cassandra
            cell.lblName.textColor = [UIColor grayColor];
            cell.tintColor = [UIColor grayColor];
            //Cassandra
           [cell setBackgroundColor:[UIColor clearColor]];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            return cell;
        }
    }
    
    if(indexPath.row<[videoList count])
    {
        static NSString *CellIdentifier = @"dubsTableCell";
        DubsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
        cell.navController = self.navigationController;
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"DubsTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }

        [cell setConnectedDubVideo: [videoList objectAtIndex:indexPath.row]];
        cell.tableView = self.tvProfile;
        [cell updatePosition];
    
        return cell;
    }else
    {
        //[self performSelector:@selector(loadMoreVideoInBackground) withObject:nil afterDelay:0.4];
        
        if(!shouldStopLoadingMore)
        {
            [self loadMoreVideoInBackground];
            shouldStopLoadingMore = YES;
        }
        return [self getLoadMoreCell];
    }
    
}

-(IBAction)toggleFollowClicked:(id)sender
{

   
}

- (IBAction)backClicked:(id)sender {
    
    if(self.hidesBottomBarWhenPushed)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
}
}


#pragma UIScrollView
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSArray *a=[self.tvProfile visibleCells];
    
    for(UITableViewCell *topCell in a)
    {
        if([topCell isKindOfClass: [DubsTableViewCell class] ])
            [(DubsTableViewCell*)topCell updatePosition];
    }
}



@end
