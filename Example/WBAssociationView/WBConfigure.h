//
//  WBConfigure.h
//  WBAssociationView_Example
//
//  Created by penghui8 on 2019/1/9.
//  Copyright © 2019 penghui8. All rights reserved.
//

#ifndef WBConfigure_h
#define WBConfigure_h

static inline BOOL wb_iPhoneXSeries(void) NS_EXTENSION_UNAVAILABLE_IOS("") {
    static BOOL iPhoneXSeries = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
            iPhoneXSeries = NO;
        }
        
        if (@available(iOS 11.0, *)) {
            UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
            if (mainWindow.safeAreaInsets.bottom > 0.0) {
                iPhoneXSeries = YES;
            }
        }
    });
    
    return iPhoneXSeries;
}

static inline CGFloat wb_safeBottomMargin(void) NS_EXTENSION_UNAVAILABLE_IOS("") {
    return (wb_iPhoneXSeries() ? 34.0f : 0.0f);
}

static inline CGFloat wb_statusBarHeight(void) NS_EXTENSION_UNAVAILABLE_IOS("") {
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

static inline CGFloat wb_navBarHeight(void) {
    return 44.0f;
}

static inline CGFloat wb_status_navBarHeight(void) NS_EXTENSION_UNAVAILABLE_IOS("") {
    return (wb_statusBarHeight() + wb_navBarHeight());
}

#endif /* WBConfigure_h */
