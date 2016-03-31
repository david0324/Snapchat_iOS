//
//  ORGContainerCellView.m
//  HorizontalCollectionViews
//
//  Created by James Clark on 4/22/13.
//  Copyright (c) 2013 OrgSync, LLC. All rights reserved.
//

#import "ExploreContainerCellView.h"
#import "DubsCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface ExploreContainerCellView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *collectionData;
@end

@implementation ExploreContainerCellView

- (void)awakeFromNib {
    
    self.collectionView.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // The device is an iPad running iOS 3.2 or later.
         flowLayout.itemSize = CGSizeMake(150.0, 120.0);    }
    else
    {
        // The device is an iPhone or iPod touch.
         flowLayout.itemSize = CGSizeMake(150.0, 120.0);
    }
    [self.collectionView setCollectionViewLayout:flowLayout];

    // Register the colleciton cell
    [_collectionView registerNib:[UINib nibWithNibName:@"DubsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"dubsGridCell"];

}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark - Getter/Setter overrides
-(void) setCollectionData:(NSArray *)collectionData bgColor:(UIColor *)color
{   _collectionData = collectionData;
    [_collectionView setContentOffset:CGPointZero animated:NO];
    [_collectionView reloadData];
    self.collectionView.backgroundColor = color;
}


#pragma mark - UICollectionViewDataSource methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.collectionData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DubsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"dubsGridCell" forIndexPath:indexPath];
    NSDictionary *cellData = [self.collectionData objectAtIndex:[indexPath row]];
   // cell.articleTitle.text = [cellData objectForKey:@"title"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *cellData = [self.collectionData objectAtIndex:[indexPath row]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectItemFromCollectionView" object:cellData];
}


@end
