//
//  PageMenu.h
//  MyLife
//
//  Created by Venkata ramana Kunapuli on 3/20/17.
//  Copyright © 2017 Venkata ramana Kunapuli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageMenu;

#pragma mark - Delegate functions
@protocol PageMenuDelegate <NSObject>

@optional
- (void)willMoveToPage:(UIViewController *)controller index:(NSInteger)index;
- (void)didMoveToPage:(UIViewController *)controller index:(NSInteger)index;
@end

@interface MenuItemView : UIView

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIView *menuItemSeparator;

- (void)setUpMenuItemView:(CGFloat)menuItemWidth menuScrollViewHeight:(CGFloat)menuScrollViewHeight indicatorHeight:(CGFloat)indicatorHeight separatorPercentageHeight:(CGFloat)separatorPercentageHeight separatorWidth:(CGFloat)separatorWidth separatorRoundEdges:(BOOL)separatorRoundEdges menuItemSeparatorColor:(UIColor *)menuItemSeparatorColor;

- (void)setTitleText:(NSString *)text;

@end

@interface PageMenu : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *menuScrollView;
@property (nonatomic, strong) UIScrollView *controllerScrollView;

@property (nonatomic, readonly) NSArray *controllerArray;
@property (nonatomic, readonly) NSArray *menuItems;
@property (nonatomic, readonly) NSArray *menuItemWidths;

@property (nonatomic) NSInteger currentPageIndex;
@property (nonatomic) NSInteger lastPageIndex;

@property (nonatomic) CGFloat menuHeight;
@property (nonatomic) CGFloat menuMargin;
@property (nonatomic) CGFloat menuItemWidth;
@property (nonatomic) CGFloat selectionIndicatorHeight;
@property (nonatomic) NSInteger scrollAnimationDurationOnMenuItemTap;

@property (nonatomic) UIColor *selectionIndicatorColor;
@property (nonatomic) UIColor *selectedMenuItemLabelColor;
@property (nonatomic) UIColor *unselectedMenuItemLabelColor;
@property (nonatomic) UIColor *scrollMenuBackgroundColor;
@property (nonatomic) UIColor *viewBackgroundColor;
@property (nonatomic) UIColor *bottomMenuHairlineColor;
@property (nonatomic) UIColor *menuItemSeparatorColor;

@property (nonatomic) UIFont *menuItemFont;
@property (nonatomic) CGFloat menuItemSeparatorPercentageHeight;
@property (nonatomic) CGFloat menuItemSeparatorWidth;
@property (nonatomic) BOOL menuItemSeparatorRoundEdges;

@property (nonatomic) BOOL addBottomMenuHairline;
@property (nonatomic) BOOL menuItemWidthBasedOnTitleTextWidth;
@property (nonatomic) BOOL useMenuLikeSegmentedControl;
@property (nonatomic) BOOL centerMenuItems;
@property (nonatomic) BOOL enableHorizontalBounce;
@property (nonatomic) BOOL hideTopMenuBar;

@property (nonatomic, weak) id <PageMenuDelegate> delegate;

- (void)addPageAtIndex:(NSInteger)index;
- (void)moveToPage:(NSInteger)index;

- (instancetype)initWithViewControllers:(NSArray *)viewControllers frame:(CGRect)frame options:(NSDictionary *)options;

extern NSString * const PageMenuOptionSelectionIndicatorHeight;
extern NSString * const PageMenuOptionMenuItemSeparatorWidth;
extern NSString * const PageMenuOptionScrollMenuBackgroundColor;
extern NSString * const PageMenuOptionViewBackgroundColor;
extern NSString * const PageMenuOptionBottomMenuHairlineColor;
extern NSString * const PageMenuOptionSelectionIndicatorColor;
extern NSString * const PageMenuOptionMenuItemSeparatorColor;
extern NSString * const PageMenuOptionMenuMargin;
extern NSString * const PageMenuOptionMenuHeight;
extern NSString * const PageMenuOptionSelectedMenuItemLabelColor;
extern NSString * const PageMenuOptionUnselectedMenuItemLabelColor;
extern NSString * const PageMenuOptionUseMenuLikeSegmentedControl;
extern NSString * const PageMenuOptionMenuItemSeparatorRoundEdges;
extern NSString * const PageMenuOptionMenuItemFont;
extern NSString * const PageMenuOptionMenuItemSeparatorPercentageHeight;
extern NSString * const PageMenuOptionMenuItemWidth;
extern NSString * const PageMenuOptionEnableHorizontalBounce;
extern NSString * const PageMenuOptionAddBottomMenuHairline;
extern NSString * const PageMenuOptionMenuItemWidthBasedOnTitleTextWidth;
extern NSString * const PageMenuOptionScrollAnimationDurationOnMenuItemTap;
extern NSString * const PageMenuOptionCenterMenuItems;
extern NSString * const PageMenuOptionHideTopMenuBar;

@end
