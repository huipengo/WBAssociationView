//
//  WBGestureView.m
//
//  Created by penghui8 on 2018/10/23.
//  Copyright © 2018 penghui8. All rights reserved.
//

#import "WBGestureView.h"
#import "UIView+Ex.h"

static NSTimeInterval const wb_duration = 0.25f;

typedef NS_ENUM(NSInteger, WBMenuSwipeLocation) {
    WBMenuSwipeInit,
    WBMenuSwipeLeft,
    WBMenuSwipeRight,
    WBMenuSwipeUp,
    WBMenuSwipeDown
};

@interface WBGestureView () <UIGestureRecognizerDelegate>

@property (nonatomic, assign, readwrite) BOOL wb_show;

@property (nonatomic, assign) CGPoint beginPoint;

@property (nonatomic, assign) CGPoint changePoint;

@property (nonatomic, assign) WBMenuSwipeLocation swipeLocation;

@property (nonatomic, strong) UIView *mask_view;

@end

@implementation WBGestureView

- (void)dealloc {
    NSLog(@"dealloc: %@\n", self.debugDescription);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setGesture_enable:(BOOL)gesture_enable {
    _gesture_enable = gesture_enable;
    if (gesture_enable) {
        [self wb_addPanGesture];
    }
}

- (void)wb_addPanGesture {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(panGestureRecognizer:)];
    pan.delegate = self;
    [self addGestureRecognizer:pan];
}

- (void)wb_addTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapGestureRecognizer:)];
    [self.mask_view addGestureRecognizer:tap];
}

- (void)wb_showInView:(UIView * _Nonnull)superView {
    if (![self.wb_superView isDescendantOfView:self]) {
        self.wb_superView = superView;
        
        if (self.show_mask_view) {
            [self.wb_superView addSubview:self.mask_view];
        }
        
        [self.wb_superView addSubview:self];
    }
    
    if (self.show_mask_view) {
        self.mask_view.alpha = 1.0f;
    }

    self.top = self.wb_superView.height;
    [self wb_showView];
}

- (void)wb_showView {
    [UIView animateWithDuration:wb_duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.top -= (self.height - (self.wb_superView.height - self.top));
        self.top -= self.bottom_margin;
        [self wb_panGestureWithPercent:0.0f];
    } completion:^(BOOL finished) {
        self.wb_show = finished;
    }];
}

- (void)wb_hiddenView {
    if (!self.wb_show) { return; }
    [UIView animateWithDuration:wb_duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.top += (self.wb_superView.height - self.top);
        [self wb_panGestureWithPercent:1.0f];
        if (self.show_mask_view) {
            self.mask_view.alpha = 0.0f;
        }
    } completion:^(BOOL finished) {
        self.wb_show = !finished;
        if (self.show_mask_view) {
            [self.mask_view removeFromSuperview];
        }
        if (self.hidden_remove) {
            [self removeFromSuperview];
        }
        !self.hiddenCompletion ?: self.hiddenCompletion(YES);
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    else if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
        return YES;
    }
    return NO;
}

#pragma mark Private Method
- (void)tapGestureRecognizer:(UITapGestureRecognizer *)gesture {
    [self wb_hiddenView];
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)gesture {
    CGPoint point   = [gesture translationInView:self];
    CGFloat percent = point.y / self.wb_superView.height;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            self.swipeLocation = WBMenuSwipeInit;
            self.beginPoint = point;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            self.changePoint = point;
            if (self.changePoint.y - self.beginPoint.y > 0) {
                self.swipeLocation = WBMenuSwipeDown;
            }
            else {
                self.swipeLocation = WBMenuSwipeUp;
            }
            
            if ((self.top < self.wb_superView.size.height - self.height || self.top > self.wb_superView.size.height)) {
                return;
            }
            
            if (self.wb_show) {
                // hide
                if (percent < 0) { return; }
                if (self.top < self.wb_superView.height) {
                    self.top += self.height*percent - (self.top - (self.wb_superView.height - self.height));
                }
            } else {
                // show
                if (percent > 0) { return; }
                if (self.top > self.wb_superView.height - self.height) {
                    self.top -= (-self.height*percent - (self.wb_superView.height - self.top));
                }
            }

            [self wb_panGestureWithPercent:fabs(percent)];
            
            break;
        }
        default:
            if (fabs(percent) > 0.3f) {
                [self swipGestureRecognizer];
            }
            else {
                if (self.wb_show) {
                    [self wb_showView];
                }
                else {
                    [self swipHideView];
                }
            }
            break;
    }
}

- (void)wb_panGestureWithPercent:(CGFloat)percent {
    if (_gesture_delegate && [self.gesture_delegate respondsToSelector:@selector(wb_panGestureRecognizerView:percent:)]) {
        [self.gesture_delegate wb_panGestureRecognizerView:self percent:percent];
    }
}

- (void)swipHideView {
    self.wb_show = YES;
    [self wb_hiddenView];
}

- (void)swipGestureRecognizer {
    if (self.wb_show) {
        if (self.swipeLocation == WBMenuSwipeDown) {
            self.wb_show = YES;
            [self wb_hiddenView];
        }
        else {
            [self wb_showView];
        }
    }
    else {
        if (self.swipeLocation == WBMenuSwipeUp) {
            [self wb_showView];
        }
        else {
            [self swipHideView];
        }
    }
}

- (UIView *)mask_view {
    if (!_mask_view) {
        _mask_view = [[UIView alloc] initWithFrame:self.wb_superView.bounds];
        _mask_view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        [self wb_addTapGesture];
    }
    return _mask_view;
}

@end
