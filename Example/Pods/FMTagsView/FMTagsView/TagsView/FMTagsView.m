//
//  FMTagsView.m
//  FollowmeiOS
//
//  Created by Subo on 16/5/25.
//  Copyright © 2016年 com.followme. All rights reserved.
//

#import "FMTagsView.h"

static NSString * const wb_tag_cell_indentifier = @"wb_tag_cell_indentifier";

@interface FMTagModel : NSObject

@property (copy, nonnull) NSString *name;

@property (nonatomic) BOOL selected;
/** 用于计算文字大小 */
@property (strong, nonatomic) UIFont *font;

@property (nonatomic, readonly) CGSize contentSize;

- (instancetype)initWithName:(NSString *)name font:(UIFont *)font;

@end

@implementation FMTagModel

- (instancetype)initWithName:(NSString *)name font:(UIFont *)font {
    if (self = [super init]) {
        _name = name;
        self.font = font;
    }
    return self;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    
    [self calculateContentSize];
}

- (void)calculateContentSize {
    NSDictionary *dict = @{NSFontAttributeName: self.font};
    CGSize textSize = [_name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 1000)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:dict context:nil].size;
    
    _contentSize = CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}

@end

@interface FMTagCell ()

@property (nonatomic, strong) FMTagModel *tagModel;

@end

@implementation FMTagCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        [self wb_viewConfigure];
    }
    return self;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.userInteractionEnabled = NO;
            label;
        });
    }
    return _tagLabel;
}

- (UIButton *)imageButton {
    if (!_imageButton) {
        _imageButton = ({
            UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [imageButton addTarget:self action:@selector(wb_imageAction:) forControlEvents:UIControlEventTouchUpInside];
            imageButton.hidden = YES;
            imageButton;
        });
    }
    return _imageButton;
}

- (void)wb_viewConfigure {
    [self.contentView addSubview:self.tagLabel];
    [self.contentView addSubview:self.imageButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect bounds = self.contentView.bounds;
    CGFloat width = bounds.size.width - self.contentInsets.left - self.contentInsets.right;
    CGRect frame = CGRectMake(0, 0, width, [self.tagModel contentSize].height);
    self.tagLabel.frame = frame;
    self.tagLabel.center = self.contentView.center;
    
    UIImage *image = self.imageButton.imageView.image;
    self.imageButton.hidden = (image == nil);
    if (image) {
        CGFloat w = bounds.size.width / 2.0f;
        CGFloat h = bounds.size.height;
        CGFloat x = bounds.size.width - w;
        CGRect rect = CGRectMake(x, 0.0f, w, h);
        self.imageButton.frame = rect;
        
        UIEdgeInsets imageEdgeInsets = UIEdgeInsetsMake(-(h/3.0f), frame.size.width / 2.0f, 0.0f, -0.0f);
        [self.imageButton setImageEdgeInsets:imageEdgeInsets];
    }
}

- (void)wb_imageAction:(UIButton *)sender {
    !self.imageActionCompletion ?: self.imageActionCompletion();
}

@end

@interface FMEqualSpaceFlowLayout : UICollectionViewFlowLayout

@property (weak, nonatomic) id<UICollectionViewDelegateFlowLayout> delegate;
@property (nonatomic, strong) NSMutableArray *itemAttributes;
@property (assign,nonatomic) CGFloat contentHeight;

@end

@implementation FMEqualSpaceFlowLayout

- (instancetype)init {
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumInteritemSpacing = 5.0f;
        self.minimumLineSpacing = 5.0f;
        self.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    }
    
    return self;
}

- (CGFloat)minimumInteritemSpacingAtSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    }
    
    return self.minimumInteritemSpacing;
}

- (CGFloat)minimumLineSpacingAtSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
    }
    
    return self.minimumLineSpacing;
}

- (UIEdgeInsets)sectionInsetAtSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }
    
    return self.sectionInset;
}

#pragma mark - Methods to Override
- (void)prepareLayout
{
    [super prepareLayout];
    
    _contentHeight = 0;
    NSInteger itemCount = [[self collectionView] numberOfItemsInSection:0];
    self.itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];
    
    CGFloat minimumInteritemSpacing = [self minimumInteritemSpacingAtSection:0];
    CGFloat minimumLineSpacing = [self minimumLineSpacingAtSection:0];
    UIEdgeInsets sectionInset = [self sectionInsetAtSection:0];
    
    CGFloat xOffset = sectionInset.left;
    CGFloat yOffset = sectionInset.top;
    CGFloat xNextOffset = sectionInset.left;
    CGRect colloctionViewBounds = [self collectionView].bounds;
    
    for (NSInteger idx = 0; idx < itemCount; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];

        xNextOffset += (minimumInteritemSpacing + itemSize.width);
        
        if (xNextOffset - minimumInteritemSpacing > colloctionViewBounds.size.width - sectionInset.right) {
            xOffset = sectionInset.left;
            xNextOffset = (sectionInset.left + minimumInteritemSpacing + itemSize.width);
            yOffset += (itemSize.height + minimumLineSpacing);
        }
        else
        {
            xOffset = xNextOffset - (minimumInteritemSpacing + itemSize.width);
        }
        
        UICollectionViewLayoutAttributes *layoutAttributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        layoutAttributes.frame = CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height);
        [_itemAttributes addObject:layoutAttributes];
        
        _contentHeight = MAX(_contentHeight, CGRectGetMaxY(layoutAttributes.frame));
    }
    
    _contentHeight += sectionInset.bottom;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.itemAttributes)[indexPath.item];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.itemAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, [evaluatedObject frame]);
    }]];
}

- (CGSize)collectionViewContentSize {
    /** 重新计算布局 */
    [self prepareLayout];

    CGSize contentSize  = CGSizeMake(self.collectionView.frame.size.width, self.contentHeight);
    return contentSize;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    if (!CGSizeEqualToSize(oldBounds.size, newBounds.size)) {
        return YES;
    }
    return NO;
}

@end

@interface FMTagsView ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray<NSString *> *tagsMutableArray;
@property (strong, nonatomic) NSMutableArray<FMTagModel *> *tagModels;

@end

@implementation FMTagsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor whiteColor];
    
    _contentInsets  = UIEdgeInsetsMake(10.0f, 15.0f, 10.0f, 15.0f);
    _tagInsets      = UIEdgeInsetsMake(5.0f, 10.0f, 5.0f, 10.0f);
    
    _tagBorderWidth = 0.0f;
    
    _tagBackgroundColor = [UIColor colorWithRed:239.0f/255.0f
                                          green:239.0f/255.0f
                                           blue:244.0f/255.0f
                                          alpha:1.0];
    
    _tagSelectedBackgroundColor = [UIColor colorWithRed:51.0f/255.0f
                                                  green:82.0f/255.0f
                                                   blue:254.0f/255.0f
                                                  alpha:1.0];
    
    _tagFont         = [UIFont systemFontOfSize:14.0f];
    _tagSelectedFont = [UIFont systemFontOfSize:14.0f];
    
    _tagTextColor = [UIColor colorWithRed:23.0f/255.0f
                                    green:36.0f/255.0f
                                     blue:52.0f/255.0f
                                    alpha:1.0];
    
    _tagSelectedTextColor = [UIColor whiteColor];
    
    _tagHeight       = 34.0f;
    _mininumTagWidth = 0.0f;
    _maximumTagWidth = CGFLOAT_MAX;
    
    _lineSpacing      = 10.0f;
    _interitemSpacing = 15.0f;
    
    _allowsSelection          = YES;
    _allowsMultipleSelection  = NO;
    _allowEmptySelection      = YES;
    _maximumNumberOfSelection = NSIntegerMax;
    
    [self addSubview:self.collectionView];
    
    UICollectionView *collectionView = self.collectionView;
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(collectionView);
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|"
                                                                   options:NSLayoutFormatAlignAllTop
                                                                   metrics:nil
                                                                     views:views];
    constraints = [constraints arrayByAddingObjectsFromArray:
                   [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|"
                                                           options:0
                                                           metrics:nil
                                                             views:views]];
    [self addConstraints:constraints];
}

- (CGSize)intrinsicContentSize {
    CGSize contentSize = self.collectionView.collectionViewLayout.collectionViewContentSize;
    return CGSizeMake(UIViewNoIntrinsicMetric, contentSize.height);
}

- (void)setTagsArray:(NSArray<NSString *> *)tagsArray {
    _tagsMutableArray = [tagsArray mutableCopy];
    [self.tagModels removeAllObjects];
    [tagsArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FMTagModel *tagModel = [[FMTagModel alloc] initWithName:obj font:self.tagFont];
        [self.tagModels addObject:tagModel];
    }];
    [self.collectionView reloadData];
    [self invalidateIntrinsicContentSize];
}

- (void)selectTagAtIndex:(NSUInteger)index animate:(BOOL)animate {
    if (index >= self.tagModels.count || !self.allowsSelection) {
        return;
    }
    
    if (self.allowsSelection && !self.allowsMultipleSelection) {
        [self deSelectAll];
    }
    
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                                      animated:animate
                                scrollPosition:UICollectionViewScrollPositionNone];
    [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

- (void)deSelectTagAtIndex:(NSUInteger)index animate:(BOOL)animate {
    if (index >= self.tagModels.count) {
        return;
    }
    FMTagModel *tagModel = self.tagModels[index];
    tagModel.selected = NO;

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];

    if ([self.delegate respondsToSelector:@selector(tagsView:didDeSelectTagAtIndex:)]) {
        [self.delegate tagsView:self didDeSelectTagAtIndex:index];
    }
}

- (void)deSelectAll {
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems) {
        FMTagModel *tagModel = self.tagModels[indexPath.row];
        tagModel.selected = NO;
        [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
    [self.collectionView reloadData];
}

- (FMTagCell *)cellForItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    return (FMTagCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
}

#pragma mark - ......::::::: Edit :::::::......

- (NSUInteger)indexOfTag:(NSString *)tagName {
    __block NSUInteger index = NSNotFound;
    [self.tagsMutableArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:tagName]) {
            index = idx;
            *stop = YES;
        }
    }];
    
    return index;
}

- (void)addTag:(NSString *)tagName {
    [self.tagsMutableArray addObject:tagName];
    FMTagModel *tagModel = [[FMTagModel alloc] initWithName:tagName font:self.tagFont];
    [self.tagModels addObject:tagModel];
    [self.collectionView reloadData];
    [self invalidateIntrinsicContentSize];
}

- (void)insertTag:(NSString *)tagName AtIndex:(NSUInteger)index {
    if (index >= self.tagsMutableArray.count) {
        return;
    }
    
    [self.tagsMutableArray insertObject:tagName atIndex:index];
    FMTagModel *tagModel = [[FMTagModel alloc] initWithName:tagName font:self.tagFont];
    [self.tagModels insertObject:tagModel atIndex:index];
    [self.collectionView reloadData];
    [self invalidateIntrinsicContentSize];
}

- (void)removeTagWithName:(NSString *)tagName {
    return [self removeTagAtIndex:[self indexOfTag:tagName]];
}

- (void)removeTagAtIndex:(NSUInteger)index {
    if (index >= self.tagsMutableArray.count || index == NSNotFound) {
        return ;
    }
    
    [self.tagsMutableArray removeObjectAtIndex:index];
    [self.tagModels removeObjectAtIndex:index];
    [self.collectionView reloadData];
    [self invalidateIntrinsicContentSize];
}

- (void)removeAllTags {
    [self.tagsMutableArray removeAllObjects];
    [self.tagModels removeAllObjects];
    [self.collectionView reloadData];
}

#pragma mark - ......::::::: CollectionView DataSource :::::::......

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tagModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FMTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:wb_tag_cell_indentifier
                                                                forIndexPath:indexPath];
    
    FMTagModel *tagModel = [self.tagModels objectAtIndex:indexPath.row];
    cell.tagModel = tagModel;
    
    cell.tagLabel.text = tagModel.name;

    if (self.suffix_image) {
        [cell.imageButton setImage:self.suffix_image forState:UIControlStateNormal];
    }
    
    cell.layer.cornerRadius = self.tagcornerRadius;
    cell.layer.masksToBounds = self.tagcornerRadius > 0;
    
    cell.contentInsets = self.tagInsets;
    cell.layer.borderWidth = self.tagBorderWidth;
    [self setCell:cell selected:tagModel.selected];
    
    __weak typeof(self)weakSelf = self;
    cell.imageActionCompletion = ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf removeTagAtIndex:indexPath.row];

        if ([strongSelf.delegate respondsToSelector:@selector(tagsView:imageTagAtIndex:)]) {
            [strongSelf.delegate tagsView:strongSelf imageTagAtIndex:indexPath.row];
        }
    };
    
    return cell;
}

- (void)setCell:(FMTagCell *)cell selected:(BOOL)selected {
    
    if (selected) {
        cell.backgroundColor = self.tagSelectedBackgroundColor;
        cell.tagLabel.font = self.tagSelectedFont;
        cell.tagLabel.textColor = self.tagSelectedTextColor;
        cell.layer.borderColor = self.tagSelectedBorderColor.CGColor;
    }
    else {
        cell.backgroundColor = self.tagBackgroundColor;
        cell.tagLabel.font = self.tagFont;
        cell.tagLabel.textColor = self.tagTextColor;
        cell.layer.borderColor = self.tagBorderColor.CGColor;
    }
}

#pragma mark - ......::::::: UICollectionViewDelegate :::::::......

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    FMTagCell *tagCell = (FMTagCell *)cell;
    if ([self.delegate respondsToSelector:@selector(tagsView:willDispayCell:atIndex:)]) {
        [self.delegate tagsView:self willDispayCell:tagCell atIndex:indexPath.row];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tagsView:shouldSelectTagAtIndex:)]) {
        return [self.delegate tagsView:self shouldSelectTagAtIndex:indexPath.row];
    }
    
    return _allowsSelection;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tagsView:shouldDeselectItemAtIndex:)]) {
        return [self.delegate tagsView:self shouldDeselectItemAtIndex:indexPath.row];
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FMTagModel *tagModel = self.tagModels[indexPath.row];
    FMTagCell *cell = (FMTagCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (self.allowsMultipleSelection) {
        if (self.collectionView.indexPathsForSelectedItems.count > self.maximumNumberOfSelection) {
            if ([self.delegate respondsToSelector:@selector(tagsViewDidBeyondMaximumNumberOfSelection:)]) {
                [self.delegate tagsViewDidBeyondMaximumNumberOfSelection:self];
            }
            return;
        }
    }
    else {
        /** 修复单选情况下，无法取消选中的问题 */
        if (tagModel.selected) {
            /** 修复单选情况下，无法取消选中的问题 */
            if (!self.allowEmptySelection && self.collectionView.indexPathsForSelectedItems.count == 1) {
                return;
            }
            
            cell.selected = NO;
            collectionView.allowsMultipleSelection = YES;
            [collectionView deselectItemAtIndexPath:indexPath animated:NO];
            [self collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
            collectionView.allowsMultipleSelection = NO;
            return;
        }
    }
    
    tagModel.selected = YES;
    [self setCell:cell selected:YES];
    
    if ([self.delegate respondsToSelector:@selector(tagsView:didSelectTagAtIndex:)]) {
        [self.delegate tagsView:self didSelectTagAtIndex:indexPath.row];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FMTagModel *tagModel = self.tagModels[indexPath.row];
    FMTagCell *cell = (FMTagCell *)[collectionView cellForItemAtIndexPath:indexPath];
    tagModel.selected = NO;
    [self setCell:cell selected:NO];
    
    if ([self.delegate respondsToSelector:@selector(tagsView:didDeSelectTagAtIndex:)]) {
        [self.delegate tagsView:self didDeSelectTagAtIndex:indexPath.row];
    }
}

#pragma mark - ......::::::: UICollectionViewDelegateFlowLayout :::::::......

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    FMTagModel *tagModel = self.tagModels[indexPath.row];
    CGFloat width = tagModel.contentSize.width + self.tagInsets.left + self.tagInsets.right;
    if (width < self.mininumTagWidth) {
        width = self.mininumTagWidth;
    }
    if (width > self.maximumTagWidth) {
        width = self.maximumTagWidth;
    }
    
    return CGSizeMake(width, self.tagHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.interitemSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.lineSpacing;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return self.contentInsets;
}

#pragma mark - ......::::::: Getter and Setter :::::::......

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        FMEqualSpaceFlowLayout *flowLayout = [[FMEqualSpaceFlowLayout alloc] init];
        flowLayout.delegate = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:FMTagCell.class
            forCellWithReuseIdentifier:wb_tag_cell_indentifier];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    
    _collectionView.allowsSelection         = _allowsSelection;
    _collectionView.allowsMultipleSelection = _allowsMultipleSelection;
    
    return _collectionView;
}

- (UIFont *)tagSelectedFont {
    if (!_tagSelectedFont) {
        return _tagFont;
    }
    
    return _tagSelectedFont;
}

- (UIColor *)tagSelectedBorderColor {
    if (!_tagSelectedBorderColor) {
        return _tagBorderColor;
    }
    
    return _tagSelectedBorderColor;
}

- (NSUInteger)selectedIndex {
    return self.collectionView.indexPathsForSelectedItems.firstObject.row;
}

- (NSArray<NSString *> *)selecedTags {
//    if (!self.allowsMultipleSelection) {
//        return nil;
//    }
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems) {
        [result addObject:self.tagsMutableArray[indexPath.row]];
    }
    
    return result.copy;
}

- (NSArray<NSNumber *> *)selectedIndexes {
//    if (!self.allowsMultipleSelection) {
//        return nil;
//    }
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems) {
        [result addObject:@(indexPath.row)];
    }
    
    return result.copy;
}

- (NSMutableArray<FMTagModel *> *)tagModels {
    if (!_tagModels) {
        _tagModels = [[NSMutableArray alloc] init];
    }
    return _tagModels;
}

- (NSArray<NSString *> *)tagsArray {
    return [self.tagsMutableArray copy];
}

@end
