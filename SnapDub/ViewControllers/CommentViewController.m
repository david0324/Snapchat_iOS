//
//  CommentViewController.m
//  SnapDub
//
//  Created by Poland on 08/05/15.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTableViewCell.h"
#import "DubVideoParseHelper.h"
#import "DubComment.h"
#import "DubUser.h"
#import "GeneralUtility.h"
#define LIMIT_PER_PAGE 15

@interface CommentViewController ()

@end

@implementation CommentViewController
@synthesize connectedDubVideo;

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)loadView {
    [super loadView];
    
    commentsList = [NSMutableArray array];
    self.txtComment.placeholder = @"Say Something nice";
    //Cassandra
    self.txtComment.font = [UIFont fontWithName:@"Jekyll" size:15];
    
    self.loadingView = [[PFLoadingView alloc] initWithFrame:CGRectZero];
    self.loadingView.frame = self.view.bounds;
    [self.view addSubview:self.loadingView];
}

-(void) loadMore
{
    hasScrolled = NO;
    [DubVideoParseHelper GetCommentsOfADubVideoInBackground:self.connectedDubVideo policy:kPFCachePolicyNetworkElseCache limitPerPage:LIMIT_PER_PAGE pageNum:pageNum block:^(NSArray *results, NSError *error) {
        numNewCell = 0;
        if(!error)
        {
            pageNum++;
            [commentsList addObjectsFromArray: results];
            numNewCell = (int)[results count];
        }
        
        if(error || [results count]<1)
        {
            shouldStopLoadMore = YES;
        }
        
        [self.tvComment reloadData];
        [self goToPreviousPosition];
    }];
}
-(void) loadComments
{
    [self.loadingView setHidden: NO];
    
    [DubVideoParseHelper GetCommentsOfADubVideoInBackground:self.connectedDubVideo policy:kPFCachePolicyNetworkElseCache limitPerPage:LIMIT_PER_PAGE pageNum:pageNum block:^(NSArray *results, NSError *error) {
        
        if(!error)
        {
            pageNum++;
            [commentsList addObjectsFromArray: results];
        }
        
        if(error || [results count]< LIMIT_PER_PAGE)
        {
            shouldStopLoadMore = YES;
        }
        
        [self.tvComment reloadData];
        [self.loadingView setHidden: YES];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.txtComment.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];

    pageNum = 0;
    [self.btnSend setEnabled: NO];
    [self loadComments];
}
   
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self goToBottom];
}

-(void) goToPreviousPosition
{
    NSIndexPath* path = [NSIndexPath indexPathForRow:tempIndex+numNewCell-1 inSection:0];
    //NSLog(@"lastIndexPath %d", (int)path.row);
    [self.tvComment scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

-(void)goToBottom
{
    if([commentsList count]<1)
        return;
    NSIndexPath *lastIndexPath = [self lastIndexPath];
    //NSLog(@"lastIndexPath %d", (int)lastIndexPath.row);
    [self.tvComment scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(NSIndexPath *)lastIndexPath
{
    NSInteger lastSectionIndex = MAX(0, [self.tvComment numberOfSections] - 1);
    NSInteger lastRowIndex = MAX(0, [self.tvComment numberOfRowsInSection:lastSectionIndex] -1);
    return [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
}


- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    theKBSize = kbSize;
    
    //NSLog(@"kbsize height %f width %f",kbSize.height ,kbSize.width);
    //NSLog(@"table View original x: %f y: %f height %f width: %f",_tvComment.frame.origin.x,_tvComment.frame.origin.y,_tvComment.frame.size.height,_tvComment.frame.size.width);
    //NSLog(@"total height %f",self.view.frame.size.height);

   
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height - 10 , 0.0);
    self.tvComment.contentInset = contentInsets;
    self.tvComment.scrollIndicatorInsets = contentInsets;
    
    
    
    CGRect uvFrame = _uvComment.frame;
    uvFrame.origin.y = self.view.frame.size.height - kbSize.height - _uvComment.frame.size.height;
    _uvComment.frame = uvFrame;
    
    [self goToBottom];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _tvComment.contentInset = contentInsets;
    _tvComment.scrollIndicatorInsets = contentInsets;
    
    [self goToBottom];
   // //NSLog(@"table View x: %f y: %f height %f width: %f",_tvComment.frame.origin.x,_tvComment.frame.origin.y,_tvComment.frame.size.height,_tvComment.frame.size.width);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)processCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(string==nil || [string length]<1)
    {
        [self.btnSend setEnabled: NO];
    }else
    {
        [self.btnSend setEnabled: YES];
		}

    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
   // _txtComment = textField;
    textField.placeholder = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!shouldStopLoadMore)
    {
        return [commentsList count] + 1 ;
    }


    return [commentsList count];
}

- (UITableViewCell *) getLoadMoreCell
{


    static NSString *CellIdentifier = @"loadMoreCell";
    UITableViewCell* cell = [self.tvComment dequeueReusableCellWithIdentifier: CellIdentifier];
    if (!cell)
{
        [self.tvComment registerNib:[UINib nibWithNibName:@"LoadMoreCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell =[self.tvComment dequeueReusableCellWithIdentifier:CellIdentifier];
}
    cell.tag = 30000;
    return cell;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    /*
    NSArray *a=[self.tvComment visibleCells];
    
    for(UITableViewCell *topCell in a)
    {
        if(topCell.tag == 30000)
        {
            [self loadMore];
            return;
        }
    }
     */
    if([[self.tvComment indexPathsForVisibleRows] count]>0)
        tempIndex = (int)((NSIndexPath*)[[self.tvComment indexPathsForVisibleRows] lastObject]).row;
    
    hasScrolled = YES;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!shouldStopLoadMore && indexPath.row == 0)
    {
        if(hasScrolled)
            [self loadMore];
        
        return [self getLoadMoreCell];
    }
    
    int commentIndex;
    
    if(!shouldStopLoadMore)
    {
        commentIndex = ((int)[commentsList count]-1) - ((int)indexPath.row -1);
    }else
    {
        commentIndex = ((int)[commentsList count]-1) - (int)indexPath.row;
    }
    
    DubComment* comment = [commentsList objectAtIndex: commentIndex];
    
    //NSLog(@"Comment page cell Row num %d and comment count %d", (int) indexPath.row, (int) [commentsList count]);
    static NSString *cellIdentifier = @"commentCell";
    
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    cell.commentField.text = comment.comment;
    cell.dateLabel.text = [GeneralUtility getDateDiffString: comment.date];
    [cell setConnectedUser: comment.creator];
    [self processUserImage1:cell.imageView];
    
   
  //  if(indexPath.row >= [commentsList count]-1)
   // {
    if(!hasInitial)
    {
        hasInitial = YES;
        [self goToBottom];
    }
  //  }
   
    return cell;

}

-(void) processUserImage1:(UIImageView *)imageview
{
    imageview.layer.cornerRadius = imageview.frame.size.height / 2;
    imageview.layer.masksToBounds = YES;
    imageview.layer.borderWidth = 0;
    [imageview.layer setBorderColor:[[UIColor colorWithRed:255.0 / 255.0 green:255.0 / 255.0 blue:255.0 / 255.0 alpha:1.0] CGColor]];
    float fBorderWidth = 0;
    [imageview.layer setBorderWidth:fBorderWidth];
}

- (IBAction)sendComment:(id)sender {
    [DubVideoParseHelper SaveACommentToADubVideoEventually: self.connectedDubVideo comment: self.txtComment.text];
    
    DubComment* temp = [[DubComment alloc] init];
    temp.comment = self.txtComment.text;
    temp.creator = [DubUser CurrentDubUser];
    temp.date = [NSDate date];

     self.txtComment.text = @"";
     self.txtComment.placeholder = @"Say something...";
    [self.txtComment resignFirstResponder];

    [commentsList insertObject: temp atIndex:0];
    [self.tvComment reloadData];
    [self goToBottom];
}

@end
