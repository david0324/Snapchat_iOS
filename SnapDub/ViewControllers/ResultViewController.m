//
//  ResultViewController.m
//  SnapDub
//
//  Created by Poland on 08/05/15.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "ResultViewController.h"
#import "DubsTableViewCell.h"
#import "DubsCollectionViewCell.h"

#import <AVFoundation/AVFoundation.h>

@interface ResultViewController ()

@property (nonatomic,strong) NSMutableArray *name;
@property (nonatomic,strong) NSMutableArray *vdParseName;
@property  BOOL pageOpened;


//@property (nonatomic,strong) AVPlayer *Player;
//@property (nonatomic,strong) AVPlayerLayer *layer;
//@property BOOL scrolled;

@property (nonatomic,strong) DubsTableViewCell *PlayingCell;

@end

@implementation ResultViewController
//@synthesize usExplore, uvCollection, uvTable, tvExplore;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // uvTable.hidden = YES;
    
  //  uvTable.hidden  = NO;
   // uvCollection.hidden = YES;
    
    //Fox news accurately recreates a bear encounter.mp4
    
    _pageOpened = NO;
    
    NSArray *name = @[@"/Users/infinidy/Documents/JiaWei Folder/IOS Development/snapdub/SnapDub-FinalVersion/SnapDub/kids.mp4",
                      @"/Users/infinidy/Documents/JiaWei Folder/IOS Development/snapdub/SnapDub-FinalVersion/SnapDub/Penguin falls down.mp4",
                      @"/Users/infinidy/Documents/JiaWei Folder/IOS Development/snapdub/SnapDub-FinalVersion/SnapDub/The funniest 10 second video ever.mp4",
                      @"/Users/infinidy/Documents/JiaWei Folder/IOS Development/snapdub/SnapDub-FinalVersion/SnapDub/What the fuck, richard.mp4"];
    
    _vdParseName = [NSMutableArray array];
    
   // [_vdName addObjectsFromArray:name];
 
        NSArray *videoName = @[@"/Users/infinidy/Desktop/Jiawei/Video Play/Video PlayTests/Video/Dramatic Look.mp4",
                               @"/Users/infinidy/Desktop/Jiawei/Video Play/Video PlayTests/Video/Big Ball Hit.mp4",
                               @"/Users/infinidy/Desktop/Jiawei/Video Play/Video PlayTests/Video/Falcon Kick!.mp4",
                               @"/Users/infinidy/Desktop/Jiawei/Video Play/Video PlayTests/Video/kid gets owned again.mp4",
                               @"/Users/infinidy/Desktop/Jiawei/Video Play/Video PlayTests/Video/THIS KID GETS OWNED BY BALL.mp4"];
    
   //     [_vdParseName addObjectsFromArray:videoName];
    
    
    
    NSArray *ary = @[@"kids",@"Penguin falls down",@"The funniest 10 second video ever",
                     @"What the fuck, richard",@"THIS KID GETS OWNED BY BALL",@"Dramatic Look",
                     @"Big Ball Hit",@"Falcon Kick!",@"THIS KID GETS OWNED BY BALL"];
        
    
    _name = [NSMutableArray array];
    [_name addObjectsFromArray:ary];
    
    
    NSArray *parseLink = @[@"http://files.parsetfss.com/074d71bf-6f3d-41f3-a32c-417134201c1f/tfss-fc8c7649-de44-4e17-9f81-4f148a7873da-Dramatic%20Look.mp4",
                           @"http://files.parsetfss.com/074d71bf-6f3d-41f3-a32c-417134201c1f/tfss-f3136b30-78b1-49d6-9127-6ea96bab24da-Big%20Ball%20Hit.mp4",
                           @"http://files.parsetfss.com/074d71bf-6f3d-41f3-a32c-417134201c1f/tfss-0f863b83-fe03-4707-8fde-5dedcc23b995-Fox%20news%20accurately%20recreates%20a%20bear%20encounter..mp4",
                           @"http://files.parsetfss.com/074d71bf-6f3d-41f3-a32c-417134201c1f/tfss-f4cad5d9-d48c-491b-ba18-d6d29fdb9ed7-kids.mp4",
                           @"http://files.parsetfss.com/074d71bf-6f3d-41f3-a32c-417134201c1f/tfss-17fd55bb-b75d-4608-a221-8fbd467421f1-Penguin%20falls%20down.mp4",
                           @"http://files.parsetfss.com/074d71bf-6f3d-41f3-a32c-417134201c1f/tfss-1d886ac5-baec-456a-bf4b-a5e8480cc978-The%20funniest%2010%20second%20video%20ever.mp4",
                           @"http://files.parsetfss.com/074d71bf-6f3d-41f3-a32c-417134201c1f/tfss-42baca68-a35d-4466-928e-b73ea5d880af-kid%20gets%20owned%20again.mp4"];
    

    [_vdParseName addObjectsFromArray:parseLink];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//- (IBAction)segmentScanController:(id)sender {
//    if (usExplore.selectedSegmentIndex == 0) {
//        uvTable.hidden  = YES;
//        uvCollection.hidden = NO;
//    }
//    else
//    {
//        uvTable.hidden  = NO;
//        uvCollection.hidden = YES;
//    }
//}



-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView

{
    return 1;
    
}



#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return [aryPosts count];
    return _vdParseName.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"dubsTableCell";
    DubsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    cell.navController = self.navigationController;
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"DubsTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    //        if ([aryPosts count])
    //        {
    //            NSDictionary *dicpost = [aryPosts objectAtIndex:indexPath.row];
    //            cell.imgprofile.image = [dicUser objectForKey:@"image"];
    //            cell.lblName.text = [dicUser objectForKey:@"name"];
    //            cell.lblTime.text = [dicpost objectForKey:@"time"];
    //            cell.lblViews.text = [dicpost objectForKey:@"views"];
    //            cell.imgPost.image = [UIImage imageWithData:[dicpost objectForKey:@"postImage"]];
    //            cell.lblDetail.text = [dicpost objectForKey:@"detail"];
    //            cell.lblTag.text = [dicpost objectForKey:@"tag"];
    //            cell.lblLikes.text = [dicpost objectForKey:@"likes"];
    //            cell.lblComment.text = [dicpost objectForKey:@"comment"];
    //            cell.lblShare.text = [dicpost objectForKey:@"share"];
    //        }
    

 //   [cell.btnComment addTarget:self action:@selector(commentClicked:) forControlEvents:UIControlEventTouchUpInside];
//     [cell.btnDub addTarget:self action:@selector(doDubThis:) forControlEvents:UIControlEventTouchUpInside];
    [self processUserImage:cell.imgprofile];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    if (!_pageOpened) {
//        _pageOpened = YES;
    
        
    
        
    //NSString *strpath = [[NSBundle mainBundle] pathForResource:[_name objectAtIndex:indexPath.row] ofType:@"mp4"];
    //NSURL *path = [NSURL fileURLWithPath:strpath];
    
    // NSURL *path = [NSURL fileURLWithPath:[_vdName objectAtIndex:indexPath.row]];

    
    NSURL *path = [[NSURL alloc]initWithString:[_vdParseName objectAtIndex:indexPath.row]];
    //NSLog(@"%@",[_vdParseName objectAtIndex:indexPath.row]);
    //NSLog(@"%@",path.absoluteString);
    
    [cell.celPlayer replaceCurrentItemWithPlayerItem:nil];

    cell.celPlayer = [AVPlayer playerWithURL:path];
    cell.celPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(playerItemDidReachEnd:)
                                                name:AVPlayerItemDidPlayToEndTimeNotification
                                                object:[cell.celPlayer currentItem]];
    

    cell.celLayer = [AVPlayerLayer playerLayerWithPlayer:cell.celPlayer];
    cell.celLayer.frame = cell.imgPost.bounds;
    cell.celLayer.videoGravity =  AVLayerVideoGravityResizeAspectFill;
    [cell.imgPost.layer addSublayer:cell.celLayer];
    
   // //NSLog(@"x: %f y: %f w: %f h %f",cell.imgPost.bounds.origin.x,cell.imgPost.bounds.origin.y,
    //      cell.imgPost.bounds.size.width,cell.imgPost.bounds.size.height);
    if (!_pageOpened) {
        [cell.celPlayer play];
        _pageOpened = YES;
        _PlayingCell = cell;
    }
    
    return cell;
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

#pragma UIScrollView
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    static CGPoint lastOffset;
    NSTimeInterval lastOffsetCapture;
    
    //    //NSLog(@"last offset x%f y%f",lastOffset.x,lastOffset.y);
    //    //NSLog(@"last time %f",lastOffsetCapture);
    
    CGPoint currentOffset = scrollView.contentOffset;
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    
    //    //NSLog(@"cur offset x%f y%f",currentOffset.x,currentOffset.y);
    //    //NSLog(@"cur time %f",currentTime);
    
    NSTimeInterval timeDiff = currentTime - lastOffsetCapture;
    //if(timeDiff > 0.1) {}
        CGFloat distance = currentOffset.y - lastOffset.y;
        CGFloat scrollSpeedNotAbs = (distance * 10) / 1000; //in pixels per millisecond
        CGFloat scrollSpeed = fabs(scrollSpeedNotAbs);
        
        // //NSLog(@"scrollSpeed %f scrollSoeedNotAbs %f",scrollSpeed,scrollSpeedNotAbs);
        //if (scrollSpeed <= 0.05) {}
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"test" object:nil];
    NSArray *a=[self.tvExplore visibleCells];
    if (a.count == 2) {
        DubsTableViewCell *topCell = a[0];
        DubsTableViewCell *botCell = a[1];
        ////NSLog(@"Top cell %f  Bot cell %f",topCell.frame.origin.y,botCell.frame.origin.y);
        ////NSLog(@"Play cell %f",_PlayingCell.frame.origin.y);
                    
        if (scrollSpeedNotAbs < 0 && _PlayingCell == botCell) {
            //NSLog(@"Botcell %f cur %f height %f",botCell.frame.origin.y,currentOffset.y,topCell.frame.size.height);
            if (botCell.frame.origin.y - currentOffset.y > topCell.frame.size.height/3) {
                            
                _PlayingCell = topCell;
                [botCell.celPlayer pause];
                [botCell.celPlayer seekToTime:kCMTimeZero];
                [topCell.celPlayer play];
                //NSLog(@"Play after change to play topcell  cell %f",_PlayingCell.frame.origin.y);

/*
                            _scrolled = NO;
                            _Player = nil;
                            [_layer removeFromSuperlayer];
                            //the index of video will play
                            int index = topCell.frame.origin.y / topCell.frame.size.height;
                            
                            NSString *strpath = [[NSBundle mainBundle] pathForResource:[_name objectAtIndex:index] ofType:@"mp4"];
                            NSURL *path = [NSURL fileURLWithPath:strpath];
                            //NSURL *path = [NSURL fileURLWithPath:[_vdName objectAtIndex:index]];
                            
                            _Player = [[AVPlayer alloc] initWithURL:path];
                            _Player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
                            [[NSNotificationCenter defaultCenter] addObserver:self
                                                                     selector:@selector(playerItemDidReachEnd:)
                                                                         name:AVPlayerItemDidPlayToEndTimeNotification
                                                                       object:[_Player currentItem]];
                            _layer = [AVPlayerLayer playerLayerWithPlayer:_Player];
                            _layer.frame = topCell.imgPost.bounds;
                            _layer.videoGravity =  AVLayerVideoGravityResizeAspectFill;
                            [topCell.imgPost.layer addSublayer:_layer];
*/
                        }
                    }
        else if(scrollSpeedNotAbs > 0 && _PlayingCell == topCell){
             //NSLog(@"topcell %f cur %f height %f",topCell.frame.origin.y,currentOffset.y,topCell.frame.size.height);
            if (currentOffset.y - topCell.frame.origin.y > topCell.frame.size.height/3) {
                _PlayingCell = botCell;
                [topCell.celPlayer pause];
                [topCell.celPlayer seekToTime:kCMTimeZero];
                [botCell.celPlayer play];
                //NSLog(@"Play after change  cell %f",_PlayingCell.frame.origin.y);
                
/*
                            _scrolled = NO;
                            _Player = nil;
                            [_layer removeFromSuperlayer];
                            int index = botCell.frame.origin.y / botCell.frame.size.height;
 
                            NSString *strpath = [[NSBundle mainBundle] pathForResource:[_name objectAtIndex:index] ofType:@"mp4"];
                            NSURL *path = [NSURL fileURLWithPath:strpath];
                            NSURL *path = [NSURL fileURLWithPath:[_vdName objectAtIndex:index]];
                            _Player = [[AVPlayer alloc] initWithURL:path];
                            _Player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
                            [[NSNotificationCenter defaultCenter] addObserver:self
                                                                         selector:@selector(playerItemDidReachEnd:)
                                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                                   object:[_Player currentItem]];
                            _layer = [AVPlayerLayer playerLayerWithPlayer:_Player];
                            _layer.frame = botCell.imgPost.bounds;
                            _layer.videoGravity =  AVLayerVideoGravityResizeAspectFill;
                            [botCell.imgPost.layer addSublayer:_layer];
                            [[NSNotificationCenter defaultCenter]
*/

                            }
                        }
                }
    else if (a.count == 1){
        DubsTableViewCell *cell = a[0];
        //NSLog(@"Single visible cell before change %f",_PlayingCell.frame.origin.y);
        if (_PlayingCell != cell) {
            [_PlayingCell.celPlayer pause];
            [_PlayingCell.celPlayer seekToTime:kCMTimeZero];
            _PlayingCell = cell;
            
            //NSLog(@"Single visible cell %f",cell.frame.origin.y);
        }
         [_PlayingCell.celPlayer play];
    }
    
    
  //  if (timeDiff > 0.1) {
   //     //NSLog(@"current offset %f",currentOffset.y);
  //  }
    
    lastOffset = currentOffset;
    lastOffsetCapture = currentTime;
  
}









-(void) processUserImage:(UIImageView *)imageview
{
    imageview.layer.cornerRadius = imageview.frame.size.height / 2;
    imageview.layer.masksToBounds = YES;
    imageview.layer.borderWidth = 0;
    [imageview.layer setBorderColor:[[UIColor colorWithRed:255.0 / 255.0 green:255.0 / 255.0 blue:255.0 / 255.0 alpha:1.0] CGColor]];
    float fBorderWidth = imageview.frame.size.height / 50;
    [imageview.layer setBorderWidth:fBorderWidth];
}

-(void)doDubThis:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"goDubThis" sender:nil];
}

-(IBAction)commentClicked:(id)sender
{
   [self performSegueWithIdentifier:@"gocomment" sender:nil];
}
@end
