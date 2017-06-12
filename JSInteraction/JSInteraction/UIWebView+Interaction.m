//
//  UIWebView+Interaction.m
//  JSInteraction
//
//  Created by zmz on 2017/6/9.
//  Copyright © 2017年 zmz. All rights reserved.
//

#import "UIWebView+Interaction.h"
#import <objc/runtime.h>

@implementation UIWebView (Interaction)

/**
 *  toJS
 */
- (void)InterActionToJs:(NSString *)JsCode {
    [self initContext];
    NSAssert((JsCode && [JsCode isKindOfClass:[NSString class]]), @"请输入正确的JS代码");
    [self.context evaluateScript:JsCode];
}

/**
 *  toOC
 */
- (void)InterActionToOc:(InterActionOcBlock)block {
    [self initContext];
    self.block = block;
}

//初始化
- (void)initContext {
    //空则创建
    if (!self.context) {
        JSContext *context = [self valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
            context.exception = exceptionValue;
            NSLog(@"%@", exceptionValue);
        };
        context[@"AiCaiTest"] = self;
        self.context = context;
    }
}

#pragma mark - JSExport Methods
- (void)awakeOC:(InterActionOcType)type param:(NSDictionary *)param {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.block) {
            self.block(type, param);
        }
    });
}

#pragma mark - 动态绑定
static char block_bind;
- (void)setBlock:(InterActionOcBlock)block {
    objc_setAssociatedObject(self, &block_bind, block, OBJC_ASSOCIATION_COPY);
}

- (InterActionOcBlock)block {
    return objc_getAssociatedObject(self, &block_bind);
}

static char context_bind;
- (void)setContext:(JSContext *)context {
    objc_setAssociatedObject(self, &context_bind, context, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JSContext *)context {
    JSContext *context = objc_getAssociatedObject(self, &context_bind);
    return context;
}

@end
