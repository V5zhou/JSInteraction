//
//  WKWebView+Interaction.h
//  JSInteraction
//
//  Created by zmz on 2017/6/12.
//  Copyright © 2017年 zmz. All rights reserved.
//

#import <WebKit/WebKit.h>

//自定义添加功能类型
typedef NS_ENUM(NSUInteger, WKInterActionOcType) {
    WKInterActionOcType_alert = 0,
    WKInterActionOcType_dismiss,
    WKInterActionOcType_xxxxxxx,      //有啥需求就和这里添加
};

typedef void(^WKInterActionOcBlock)(WKInterActionOcType functionType, NSDictionary *param);

@interface WKWebView (Interaction) <WKScriptMessageHandler>

/**
 *  注册类型 key:name value:WKInterActionOcType
 */
- (void)registerScriptTypes:(NSDictionary *)typeDict;

/**
 *  toJS
 */
- (void)InterActionToJs:(NSString *)JsCode;

/**
 *  toOC
 */
- (void)InterActionToOc:(WKInterActionOcBlock)block;

@property (nonatomic, strong) NSDictionary *typeDict;
@property (nonatomic, copy) WKInterActionOcBlock block;

@end
