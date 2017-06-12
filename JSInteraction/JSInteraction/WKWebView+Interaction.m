//
//  WKWebView+Interaction.m
//  JSInteraction
//
//  Created by zmz on 2017/6/12.
//  Copyright © 2017年 zmz. All rights reserved.
//

#import "WKWebView+Interaction.h"
#import <objc/runtime.h>

@implementation WKWebView (Interaction)

/**
 *  注册类型
 */
- (void)registerScriptTypes:(NSDictionary *)typeDict {
    self.typeDict = typeDict;
    WKUserContentController *userCC = self.configuration.userContentController;
    for (NSString *name in [typeDict allKeys]) {
        [userCC addScriptMessageHandler:self name:name];
    }
}

/**
 *  toJS
 */
- (void)InterActionToJs:(NSString *)JsCode {
    [self evaluateJavaScript:JsCode completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        //TODO
        NSLog(@"%@ %@",response,error);
    }];
}

/**
 *  toOC
 */
- (void)InterActionToOc:(WKInterActionOcBlock)block {
    self.block = block;
}

// 从web界面中接收到一个脚本时调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *name = message.name;
        NSDictionary *value = message.body;
        WKInterActionOcType type = [self.typeDict[name] integerValue];
        if (self.block) {
            self.block(type, value);
        }
    });
}

#pragma mark - 动态绑定
static char typeDict_bind;
- (void)setTypeDict:(NSDictionary *)typeDict {
    objc_setAssociatedObject(self, &typeDict_bind, typeDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)typeDict {
    return objc_getAssociatedObject(self, &typeDict_bind);
}

static char block_bind;
- (void)setBlock:(WKInterActionOcBlock)block {
    objc_setAssociatedObject(self, &block_bind, block, OBJC_ASSOCIATION_COPY);
}

- (WKInterActionOcBlock)block {
    return objc_getAssociatedObject(self, &block_bind);
}

@end
