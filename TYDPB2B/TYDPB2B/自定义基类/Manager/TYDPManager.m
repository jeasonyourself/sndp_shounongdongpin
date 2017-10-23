//
//  TYDPManager.m
//  myShopping
//
//  Created by Wangye on 16/6/30.
//  Copyright © 2016年 泰洋冻品. All rights reserved.
//

#import "TYDPManager.h"
#import "TYDPHttpManager.h"
#import <CommonCrypto/CommonDigest.h>
#define ServerIP @"http://test.taiyanggo.com/app/api.php"
@implementation TYDPManager

/**
 *   @brief 获取 Manager单例
 *
 *   @return Manager单例
 */
static TYDPManager *_instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
+(TYDPManager *)sharedTYDPManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
+ (void)tydp_baseGetReqWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params success:(TYDPRequetSuccess)success failure:(TYDPRequetFailure)failure
{
    NSDictionary *newParams = [self addCommomParam:params];
    [TYDPHttpManager reqWithBaseUrlStr:ServerIP urlStr:urlStr method:@"GET" params:newParams success:^(id json){
        if (success) {
            success(json);
        }
    } failure:^(NSError *error){
        TYDPError *err  = [TYDPError errorWithErrorCode:-1 errorMsg:@"服务器异常"];
        if (failure) {
            failure(err);
        }
    }];
}
+ (void)tydp_basePostReqWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params success:(TYDPRequetSuccess)success failure:(TYDPRequetFailure)failure
{
//    here
    NSDictionary *newParams = [self addCommomParam:params];
    [TYDPHttpManager reqWithBaseUrlStr:ServerIP urlStr:urlStr method:@"POST" params:newParams success:^(id json){
        if (success) {
            success(json);
        }
    } failure:^(NSError *error){
        TYDPError *err  = [TYDPError errorWithErrorCode:-1 errorMsg:nil];
        if (failure) {
            failure(err);
        }
    }];
}
+(NSDictionary *)addCommomParam:(NSDictionary *)params
{
    NSMutableDictionary *resultDic = [params mutableCopy];
    [resultDic setValue:[self tydp_dictionaryToJson:params] forKey:@"post_data"];
    return resultDic;
}
+(NSString*)tydp_dictionaryToJson:(NSDictionary *)dic

{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
+(void)upLoadPic:(NSDictionary *)params withImage:(UIImage *)image withName:(NSString*)nameString withView:(UIView *)superView {
    NSDictionary *newParams = [self addCommomParam:params];
    [[TYDPHttpManager sharedAFManager:ServerIP] POST:@"" parameters:newParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData: [self resetSizeOfImageData:image maxSize:300] name:nameString fileName:[NSString stringWithFormat:@"%@.jpg",nameString] mimeType:@"image/jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        debugLog(@"responseObjectssss:%@",responseObject);
        debugLog(@"responseObject:%@",responseObject[@"error"]);
        if ([responseObject[@"error"] isEqualToString:@"0"]) {
            MBProgressHUD *mbHud = [[MBProgressHUD alloc] init];
            [mbHud setMode:MBProgressHUDModeText];
            mbHud.labelText = @"图片上传成功！";
            [superView addSubview:mbHud];
            [mbHud show:YES];
            [mbHud hide:YES afterDelay:1.5f];
        //跳转去新的订单详情页面
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
}
/**
 *  压缩图片
 */
+(NSData *)resetSizeOfImageData:(UIImage*)sourceImage maxSize:(NSInteger)maxSize {
    //先调整分辨率
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    CGFloat tmpHeight = newSize.height/1024;
    CGFloat tmpWidth = newSize.width/1024;
    if (tmpWidth>1.0&&tmpWidth>tmpHeight) {
        newSize = CGSizeMake(sourceImage.size.width/tmpWidth, sourceImage.size.height/tmpWidth);
    } else if (tmpHeight>1.0&&tmpWidth<tmpHeight){
        newSize = CGSizeMake(sourceImage.size.width/tmpHeight, sourceImage.size.height/tmpHeight);
    }
    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage, 1.0);
    NSUInteger sizeOrigin = [imageData length];
    NSUInteger sizeOriginKB = sizeOrigin/1024;
    if (sizeOriginKB > maxSize) {
        NSData *finalImageData = UIImageJPEGRepresentation(newImage, 0.50);
        return finalImageData;
    }
    return imageData;
}

@end
