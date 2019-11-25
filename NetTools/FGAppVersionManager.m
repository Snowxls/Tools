//
//  FGAppVersionManager.m
//  PDFReader
//
//  Created by 王放歌 on 2019/6/14.
//  Copyright © 2019 com.chineseall.www. All rights reserved.
//

#import "FGAppVersionManager.h"
#define promptingFroVersion @"promptingFroVersion"
@interface FGAppVersionManager()<DQAlertViewDelegate>
@property (nonatomic,assign) BOOL isDetecting;
@property (nonatomic,copy) NSString *updateUrl;
@property (nonatomic,copy) NSString *lastVersion;
@end
@implementation FGAppVersionManager

static FGAppVersionManager *manager;

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [super allocWithZone:zone];
        }
    });
    return manager;
}

+ (instancetype) sharedInstance {
    return [[self alloc] init];
}

// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
- (id)copyWithZone:(NSZone *)zone {
    return manager;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return manager;
}
- (void)checkFroUpdatesIsSuccessPrompting:(BOOL)isSuccessPrompting{
    
    if (!_isDetecting) {
        _isDetecting = YES;
        NSString *localVersion =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *url = [NSString stringWithFormat:@"%@?version_code=%@",[[ConfigManager sharedInstance] getVersionUpdateUrl] ,localVersion];
//        NSString *url = [NSString stringWithFormat:@"%@%@",AppSupport,api];
        __weak typeof(self)weakSelf = self;
        [NetConfig getURL:url Api:@"" Key:@"" Body:nil Parameters:nil DownProgressBlock:^(NSProgress *progress) {
            
        } SuccessBlock:^(NSURLSessionDataTask *task, id responseObject) {
            NSString *newVersion = localVersion;
            id d = [responseObject objectForKey:@"data"];
            if (!d) {
                if (isSuccessPrompting) {
                    DQAlertView *av = [[DQAlertView alloc] initWithTitle:@"提示" message:@"已经是最新版本" cancelButtonTitle:@"确认" otherButtonTitle:nil];
                    [av show];
                }
            }else{
                
                NSDictionary *dic = [responseObject objectForKey:@"data"];
                NSString *vStr = [dic valueForKey:@"version_code"];
                newVersion = vStr;
                weakSelf.lastVersion = vStr;
                NSString *updateType = [dic valueForKey:@"update_type"];
                weakSelf.updateUrl = [dic valueForKey:@"download_url"];
                NSString *message = [dic valueForKey:@"content"];
                
                if ([updateType isEqualToString:@"ADVICE"]) {
                    //建议更新
                    if ((!isSuccessPrompting && [self isPromptingFroVersion:vStr]) || isSuccessPrompting) {
                        DQAlertView *av = [[DQAlertView alloc] initWithTitle:@"提示" message:@"有新版本存在,是否现在更新" delegate:weakSelf cancelButtonTitle:@"立即更新" otherButtonTitles:@"稍后再说"];
                        [av show];
                    }
                } else if([updateType isEqualToString:@"FORCE"])  {
                    //强制更新
                    DQAlertView *av = [[DQAlertView alloc] initWithTitle:@"提示" message:message delegate:weakSelf cancelButtonTitle:@"立即更新" otherButtonTitles:nil];
                    [av show];
                }
            }
            
            //日志
            [LogExtra Event_PersonCenter_CheckVersionWithCurrent:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] NewVersion:newVersion];
            weakSelf.isDetecting = NO;
            
        } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
            
            [CenterMask showHUDInWindowWithTitle:Offline autoRelease:YES];
        }];
        
    }
    
    
}
#pragma mark AlertViewControllerDelegate
- (void)cancelButtonClickedOnAlertView:(DQAlertView *)alertView {
    if (![_updateUrl hasPrefix:@"http"]) {
        _updateUrl = [NSString stringWithFormat:@"http://%@",_updateUrl];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_updateUrl]];
}

- (void)otherButtonClickedOnAlertView:(DQAlertView *)alertView {
    [[NSUserDefaults standardUserDefaults] setObject:_lastVersion forKey:promptingFroVersion];
}

- (BOOL)isPromptingFroVersion:(NSString *)version{
    NSString *oldVersion=[[NSUserDefaults standardUserDefaults] objectForKey:promptingFroVersion];
    if ([oldVersion isEqualToString:version]) {
        return NO;
    }else{
        return YES;
    }
}
@end
