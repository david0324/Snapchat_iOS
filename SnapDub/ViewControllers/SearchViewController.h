//
//  SearchViewController.h
//  SnapDub
//
//  Created by Moin' Victor on 5/22/15.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController< UITableViewDataSource, UITableViewDelegate,
UICollectionViewDelegate,UICollectionViewDataSource,
UISearchDisplayDelegate,UISearchBarDelegate,
UISearchControllerDelegate,UIActionSheetDelegate> {
   
    
    
    
    IBOutlet UILabel *lblHeader;
    IBOutlet UIButton *btnBack;
    
//    IBOutlet UICollectionView *popularSearchCollectionView;
    //    IBOutlet UICollectionView *trendingSearchCollectionView;
    
//    IBOutlet UIView *searchSuggestView;
//    IBOutlet UIView *searchResultsView;
    
//    IBOutlet UITableView *searchresultsTable;
//    IBOutlet UISegmentedControl *segmentControl;
    
    IBOutlet UISearchBar *_searchBar;
}
//- (IBAction)segmentControllerSelected:(id)sender;
- (IBAction)moreButtonClicked:(id)sender;
- (IBAction)exitButtonClicked:(id)sender;
@end
