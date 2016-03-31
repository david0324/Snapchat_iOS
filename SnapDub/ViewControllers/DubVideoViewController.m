//
//  DubVideoViewController.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-07-06.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "DubVideoViewController.h"
#import "DubVideo.h"
#import "DubsTableViewCell.h"
#import "SDConstants.h"

@implementation DubVideoViewController
@synthesize connectedDubVideo, videoTable;


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.connectedDubVideo!=nil? 1:0;
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
    
    cell.tableView = self.videoTable;
    
    
    [cell setConnectedDubVideo: self.connectedDubVideo];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[cell.celPlayer currentItem]];
    
    [cell updatePosition];
    
    return cell;
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 470;
}

- (IBAction)cancelClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName: EVENT_STOP_PLAYING object:nil];
}
@end
