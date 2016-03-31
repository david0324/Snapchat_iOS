//  SearchViewController.m
//  SnapDub
//
//  Created by Moin' Victor on 5/22/15.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "SearchViewController.h"
#import "SoundTableViewCell.h"
#import "DubsTableViewCell.h"
#import "DubsSmallTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "AVFoundation/AVFoundation.h"

//changed by jw
#import "DubSound.h"
#import "DubVideo.h"
#import "DubSearchHelper.h"
#import "DubUser.h"
#import "SingleUserCell.h"


#import "CCGoogleSuggest.h"
#import "CCGoogleSuggestResult.h"
#import "SDConstants.h"

@interface SearchViewController ()

@property (nonatomic,strong) UISearchController *searchController;

@end

@implementation SearchViewController {
    NSMutableArray* searchResults;
 //   NSMutableArray* searchQueries;
    

    
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName: EVENT_STOP_PLAYING object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    searchResults = [[NSMutableArray alloc]init ];

    _searchBar.delegate = self;
    self.searchDisplayController.searchResultsTableView.delegate = self;
    [_searchBar becomeFirstResponder];
    //Cassandra start
    [_searchBar setScopeBarButtonTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [_searchBar setScopeBarButtonTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil]
     forState:UIControlStateNormal];
        //Cassandra End
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)updateFilteredForSearchingSounds:(NSString *)searchText{
    [DubSearchHelper GetAllSoundDataInBackground:searchText cachePolicy:kPFCachePolicyNetworkOnly block:^(NSArray *results, NSError *error) {
        if (!error) {
            [searchResults removeAllObjects];
            for (DubSound *sounds in results) {
                [searchResults addObject:sounds];
            }
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
        else{
            //NSLog(@"ERROR: OCCUR in DubSound Searching %@",error.description);
        }
    }];

    
/*
    [DubSearchHelper GetAllDubSoundsInBackground:searchText cachePolicy:kPFCachePolicyNetworkOnly block:^(NSArray *results, NSError *error) {
        if (!error) {
  //      [searchResults removeAllObjects];
            for (DubSound *sounds in results) {
                [searchResults addObject:sounds];
            }
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
        else{
            //NSLog(@"ERROR: OCCUR in DubSound Searching %@",error.description);
        }
    }];
 */
}

- (void)updateFilteredForSearchingVideo:(NSString *)searchText{
    [DubSearchHelper GetAllDubVideoInBackground:searchText cachePolicy:kPFCachePolicyNetworkOnly block:^(NSArray *results, NSError *error) {
        if (!error) {
            [searchResults removeAllObjects];
            for (DubVideo *video in results) {
                [searchResults addObject:video];
            }
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
        else{
            //NSLog(@"ERROR: OCCUR in DubSound Searching %@",error.description);
        }
    }];
}


- (void)updateFilteredForSearchingUser:(NSString *)searchText{
    [DubSearchHelper GetAllDubUserInBackground:searchText cachePolicy:kPFCachePolicyNetworkOnly block:^(NSArray *results, NSError *error) {
        if (!error) {
            [searchResults removeAllObjects];
            for (DubUser *user in results){
                [searchResults addObject:user];
               // //NSLog(@"Searching DubUser Name %@",user.profileName);
            }
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
        else{
            //NSLog(@"ERROR: OCCUR in DubUser Searching %@",error.description);
        }
    }];
}


#pragma searchbar Delegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{

    [_searchBar resignFirstResponder];
    
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//    if ([searchText  isEqual: @""]) {
//        
//    }
//    else if (searchBar.selectedScopeButtonIndex == 0){
//        [self updateFilteredForSearchingSounds:searchText];
//    
//    }
//    else if (_searchBar.selectedScopeButtonIndex == 1){
//        [self updateFilteredForSearchingVideo:searchText];
//    }
//    else{
//        [self updateFilteredForSearchingUser:searchText];
//    }
    
   
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchDisplayController.searchResultsTableView reloadData];
    [_searchBar resignFirstResponder];
}





#pragma SearchDisplayDelegate

-(void)keyboardWillHide:(NSNotification*)notification {
    CGFloat height = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    UITableView *tableView = [[self searchDisplayController] searchResultsTableView];
    UIEdgeInsets inset;
    [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? (inset = UIEdgeInsetsMake(0, 0, height, 0)) : (inset = UIEdgeInsetsZero);
    [tableView setContentInset:inset];
    [tableView setScrollIndicatorInsets:inset];
}

-(void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}



-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    if (searchOption == 0) {
        [searchResults removeAllObjects];
        [self updateFilteredForSearchingSounds:_searchBar.text];
    }
    else if(searchOption == 1){
        [searchResults removeAllObjects];
        [self updateFilteredForSearchingVideo:_searchBar.text];
    }
    else{
        [searchResults removeAllObjects];
        [self updateFilteredForSearchingUser:_searchBar.text];
    }
    
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    
    //NSLog(@"ShouldReloadTableForSearchString Changed to %@",searchString);
    if ([searchString  isEqual: @""]) {
        return NO;
    }
    else if (_searchBar.selectedScopeButtonIndex == 0){
        [self updateFilteredForSearchingSounds:searchString];
        
    }
    else if (_searchBar.selectedScopeButtonIndex == 1){
        [self updateFilteredForSearchingVideo:searchString];
    }
    else{
        [self updateFilteredForSearchingUser:searchString];
    }
    return YES;
}


//adding for solve scope seg problem
-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        CGRect statusBarFrame =  [[UIApplication sharedApplication] statusBarFrame];
        [UIView animateWithDuration:0.25 animations:^{
            for (UIView *subview in self.view.subviews)
                subview.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
        }];
    }
}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [UIView animateWithDuration:0.25 animations:^{
            for (UIView *subview in self.view.subviews)
                subview.transform = CGAffineTransformIdentity;
        }];
    }
}


#pragma UITableView

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (_searchBar.selectedScopeButtonIndex == 0) {
        
        [(SoundTableViewCell*) cell cellIsSelected];
        
        return;
        
    }
    else if (_searchBar.selectedScopeButtonIndex == 1){
        
    }
    else {
     
        [(SingleUserCell *)cell cellIsSelected];
    }
    
}

 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResults count];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_searchBar.selectedScopeButtonIndex == 0) {
        tableView.rowHeight = 64;

        
        static NSString *CellIdentifier = @"soundCell";
        
        SoundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
        cell.navController = self.navigationController;
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"SoundTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        DubSound *sound = [searchResults objectAtIndex:indexPath.row];
        [cell setConnectedDubSound:sound];
        [cell setIndex: (int)indexPath.row];
        return cell;
    }
    else if (_searchBar.selectedScopeButtonIndex == 1){
        tableView.rowHeight = 470;
        
        static NSString *CellIdentifier = @"dubsTableCell";
        
        DubsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.navController = self.navigationController;
        
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"DubsTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        DubVideo *video = [searchResults objectAtIndex:indexPath.row];
        
        [cell setConnectedDubVideo:video];
        
        return cell;
    }
    else{
        
        tableView.rowHeight = 60;
        
        static NSString *CellIdentifier = @"userCell";
        
        SingleUserCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"SingleUserCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        DubUser *user = [searchResults objectAtIndex:indexPath.row];
        [cell setConnectedUser:user];
        
        return cell;
    }

    
}










#pragma UIActionSheet Delegate


- (IBAction)exitButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
