//
//  OmokakeShaders.m
//  OmokakeShaders
//
//  Created by takedatakashiki on 2025/08/24.
//

#import "OmokakeShaders.h"

@implementation OmokakeShaders

- (nullable instancetype) init
{
    self = [super init];
    if (nil == self)
    {
        return nil;
    }
    
    _bundle = [self findResourceBundle];
    
    return self;
}

- (NSBundle *)findResourceBundle
{
    NSString *bundleName = @"OmokakeShaders_OmokakeShaders";
    
    NSMutableArray<NSURL *> *candidates = [NSMutableArray array];
    
#if DEBUG
    // DEBUGビルドでは環境変数からのオーバーライドをチェック
    NSString *override = [[NSProcessInfo processInfo] environment][@"PACKAGE_RESOURCE_BUNDLE_PATH"];
    if (!override) {
        override = [[NSProcessInfo processInfo] environment][@"PACKAGE_RESOURCE_BUNDLE_URL"];
    }
    if (override) {
        [candidates addObject:[NSURL fileURLWithPath:override]];
    }
#endif
    
    // 候補となるURL群を追加
    NSURL *mainResourceURL = [[NSBundle mainBundle] resourceURL];
    if (mainResourceURL) {
        [candidates addObject:mainResourceURL];
    }
    
    NSURL *classResourceURL = [[NSBundle bundleForClass:[self class]] resourceURL];
    if (classResourceURL) {
        [candidates addObject:classResourceURL];
    }
    
    NSURL *mainBundleURL = [[NSBundle mainBundle] bundleURL];
    if (mainBundleURL) {
        [candidates addObject:mainBundleURL];
    }
    
    // 各候補でバンドルを検索
    for (NSURL *candidate in candidates) {
        NSURL *bundlePath = [candidate URLByAppendingPathComponent:[bundleName stringByAppendingString:@".bundle"]];
        NSBundle *bundle = [NSBundle bundleWithURL:bundlePath];
        if (bundle) {
            return bundle;
        }
    }
    
    // バンドルが見つからない場合はfatalError相当の処理
    NSString *errorMessage = [NSString stringWithFormat:@"unable to find bundle named %@", bundleName];
    @throw [NSException exceptionWithName:@"BundleNotFound" reason:errorMessage userInfo:nil];
}

@end
