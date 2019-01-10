//
//  WBGestureView.h
//
//  Created by penghui8 on 2018/10/23.
//  Copyright © 2018 penghui8. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WBGestureProtocol <NSObject>

@optional
- (void)wb_panGestureRecognizerView:(UIView *)view percent:(CGFloat)percent;

@end

NS_ASSUME_NONNULL_BEGIN

@interface WBGestureView : UIView

@property (nonatomic, strong, nullable) UIView *wb_superView;

@property (nonatomic, weak) id<WBGestureProtocol> gesture_delegate;

/** default NO */
@property (nonatomic, assign) BOOL gesture_enable;

@property (nonatomic, assign, readonly) BOOL wb_show;

@property (nonatomic, assign) CGFloat bottom_margin;

/** default NO */
@property (nonatomic, assign) BOOL hidden_remove;

/** default NO */
@property (nonatomic, assign) BOOL show_mask_view;

@property (nonatomic, copy) void(^hiddenCompletion)(BOOL finished);

/**
 show view
 */
- (void)wb_showInView:(UIView * _Nonnull)superView;

/**
 hidden view
 */
- (void)wb_hiddenView;

@end

NS_ASSUME_NONNULL_END
