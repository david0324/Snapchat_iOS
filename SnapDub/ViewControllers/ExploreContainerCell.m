//
//  ORGContainerCell.m
//  HorizontalCollectionViews
//
//  Created by James Clark on 4/22/13.
//  Copyright (c) 2013 OrgSync, LLC. All rights reserved.
//

#import "ExploreContainerCell.h"
#import "ExploreContainerCellView.h"

@interface ExploreContainerCell ()
@property (strong, nonatomic) ExploreContainerCellView *collectionView;
@end

@implementation ExploreContainerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _collectionView = [[NSBundle mainBundle] loadNibNamed:@"ExploreContainerCellView" owner:self options:nil][0];
        _collectionView.frame = self.bounds;
        [self.contentView addSubview:_collectionView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}



-(void) setCollectionData:(NSArray *)collectionData bgColor:(UIColor *)color
{
    [_collectionView setCollectionData:collectionData bgColor:color];
}

-(void)setCollectionBackgroundColor:(UIColor *)color
{
    [_collectionView setBackgroundColor:color];
}


@end
