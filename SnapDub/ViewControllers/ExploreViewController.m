//categoryButton

//  ExploreViewController.m
//  SnapDub
//
//  Created by Poland on 06/05/15.
//  Copyright (c) 2015 Yuan. All rights reserved.
//

#import "ExploreViewController.h"
#import "DubsCollectionViewCell.h"
#import "ExploreContainerCell.h"
#import "ExploreResultViewController.h"
#import "ExploreContainerCellView.h"
#import "DubCategoryManager.h"
#import "DubCategoryTableViewCell.h"
#import "FeaturedContentsManager.h"
#import "DubCategory.h"
#import "TrendingCategoryListViewController.h"

@interface ExploreViewController ()
    @property (strong, nonatomic) NSArray *sampleData;
@end

@implementation ExploreViewController
@synthesize thetableView;

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass: [ExploreResultViewController class] ])
    {
        ExploreResultViewController *detailVC = segue.destinationViewController;
  //  detailVC.category = [categoryList objectAtIndex:indexPath.row];
        detailVC.category = sender;
    }
}

- (void)loadView {
    [super loadView];
    
    
    self.loadingView = [[PFLoadingView alloc] initWithFrame:CGRectZero];
    self.loadingView.frame = self.view.bounds;
    [self.view addSubview:self.loadingView];
}

-(void) getCategoryContents
{
    [self.loadingView setHidden: NO];
    [FeaturedContentsManager GetAllCategories:^(NSArray * categories, NSError * error) {
        if (!error) {
            categoryList = [NSArray arrayWithArray: categories];
        }else
        {
            categoryList = [NSArray array];
        }
        
        [self.thetableView reloadData];
        [self.loadingView setHidden: YES];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Register the table cell
    [self.thetableView registerClass:[ExploreContainerCell class] forCellReuseIdentifier:@"SoundTableViewCell"];
    
    [self getCategoryContents];
}



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [categoryList count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"dubCategoryCell";
    DubCategoryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"DubCategoryTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    DubCategory* category = [categoryList objectAtIndex: indexPath.row];
    [cell setConnectedCategory: category];
    cell.uiController = self;
    cell.mode = SHOW_VIDEO_MODE;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if([cell isKindOfClass: [DubCategoryTableViewCell class]])
    {
        [(DubCategoryTableViewCell*)cell cellIsSelected];
    }
}

#pragma mark UITableViewDelegate methods

- (IBAction)processSearch:(id)sender {
    [self performSegueWithIdentifier:@"goExplore" sender:nil];
}


- (IBAction)categoryButtonClicked:(id)sender {
    
}
#pragma mark Funcs

- (UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}



@end
