//
//  UIWebView+Interaction.h
//  JSInteraction
//
//  Created by zmz on 2017/6/9.
//  Copyright © 2017年 zmz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

//自定义添加功能类型
typedef NS_ENUM(NSUInteger, InterActionOcType) {
    InterActionOcType_alert = 0,
    InterActionOcType_present,
    InterActionOcType_xxxxxxx,      //有啥需求就和这里添加
};

@protocol WebViewJSExport <JSExport>
JSExportAs
(callBack  /** callBack 作为js方法的别名 */,
 - (void)awakeOC:(InterActionOcType)type param:(NSDictionary *)param
 );
@end

typedef void(^InterActionOcBlock)(InterActionOcType functionType, NSDictionary *param);

@interface UIWebView (Interaction) <WebViewJSExport>

/**
 *  toJS
 */
- (void)InterActionToJs:(NSString *)JsCode;

/**
 *  toOC
 */
- (void)InterActionToOc:(InterActionOcBlock)block;

@property (nonatomic, copy) JSContext *context;
@property (nonatomic, copy) InterActionOcBlock block;

@end
