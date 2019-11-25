//
//  NetTools.m
//  PDFReader
//
//  Created by Snow WarLock on 2018/5/15.
//  Copyright © 2018年 com.chineseall.www. All rights reserved.
//

#import "NetTools.h"
#import <CommonCrypto/CommonDigest.h>
#import <CoreLocation/CoreLocation.h>
#import "ConfigManager.h"

#define FileHashDefaultChunkSizeForReadingData 1024*8

@interface NetTools () <CLLocationManagerDelegate>{
    
}

@property (nonatomic,strong) CLLocationManager *locationManager;

@end

@implementation NetTools

+ (id)sharedInstance {
    static NetTools *mcm = nil;
    
    @synchronized(self)
    {
        if (!mcm)
            mcm = [[self alloc]init];
    }
    return mcm;
}

+ (NSString*)getFileMD5WithPath:(NSString*)path {
    return (__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)path, FileHashDefaultChunkSizeForReadingData);
}

CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,size_t chunkSizeForReadingData) {
    // Declare needed variables
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    // Get the file URL
    CFURLRef fileURL =
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  (CFStringRef)filePath,
                                  kCFURLPOSIXPathStyle,
                                  (Boolean)false);
    if (!fileURL) goto done;
    // Create and open the read stream
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            (CFURLRef)fileURL);
    if (!readStream) goto done;
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) goto done;
    // Initialize the hash object
    CC_MD5_CTX hashObject;
    CC_MD5_Init(&hashObject);
    // Make sure chunkSizeForReadingData is valid
    if (!chunkSizeForReadingData) {
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
    }
    // Feed the data to the hash object
    bool hasMoreData = true;
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
        if (readBytesCount == -1) break;
        if (readBytesCount == 0) {
            hasMoreData = false;
            continue;
        }
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
    }
    // Check if the read operation succeeded
    didSucceed = !hasMoreData;
    // Compute the hash digest
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);
    // Abort if the read operation failed
    if (!didSucceed) goto done;
    // Compute the string result
    char hash[2 * sizeof(digest) + 1];
    for (size_t i = 0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
    }
    result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
    
done:
    if (readStream) {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    if (fileURL) {
        CFRelease(fileURL);
    }
    return result;
}

+ (NSString *)md5:(NSString *)input{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

+(long long)getDateTimeTOMilliSeconds:(NSDate *)datetime {
    
    NSTimeInterval interval = [datetime timeIntervalSince1970];
    
    //    NSLog(@"转换的时间戳=%f",interval);
    
    long long totalMilliseconds = interval*1000 ;
    
    //    NSLog(@"totalMilliseconds=%llu",totalMilliseconds);
    
    return totalMilliseconds;
    
}

+ (NSString *)convertToJsonData:(id)dict {
    
    if (!dict) {
        return @"";
    }
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    } else {
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
//    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
//
//    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range];
    
    return mutStr;
    
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSDictionary *)dictionaryUnSymbolWithJsonString:(NSString *)jsonString {

    NSString *changeStr = [jsonString stringByReplacingOccurrencesOfString:@"[" withString:@""];
    changeStr = [changeStr stringByReplacingOccurrencesOfString:@"]" withString:@""];
    
    if (changeStr == nil) {
        return nil;
    }
    
    NSData *jsonData = [changeStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSArray *)arrayWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return arr;
}

+ (NSString *)getDeviceId {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (NSString*)getDateStringWithDate:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    
    return currentDateString;
}

+ (NSString*)getDayStringWithDate:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    
    return currentDateString;
}

+ (NSString *)getIdFromDate {
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    
    //    NSLog(@"转换的时间戳=%f",interval);
    
    long long totalMilliseconds = interval*1000;
    
    return [NSString stringWithFormat:@"%lld",totalMilliseconds];
}

+ (int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}

- (void)startLocating {
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
}

#pragma mark 定位代理
/* 定位完成后 回调 */
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *loc = [locations firstObject];
    
    CLLocationCoordinate2D coordinate = loc.coordinate;
    //  经纬度
    NSLog(@"---x:%f---y:%f",coordinate.latitude,coordinate.longitude);
    
    [[ConfigManager sharedInstance] setCoord:[NSString stringWithFormat:@"%f,%f",coordinate.latitude,coordinate.longitude]];
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0)
        {
            CLPlacemark *placemark = [array objectAtIndex:0];
            //NSLog(@%@,placemark.name);//具体位置
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSLog(@"所在城市:%@",city);
            
            if (city.length == 0) {
                city = @"";
            }
            
            [[ConfigManager sharedInstance] setCity:city];
            
            
            NSString *area = placemark.subLocality;
            NSLog(@"所在区域:%@",area);
            if (area.length == 0) {
                area = @"";
            }
            [[ConfigManager sharedInstance] setArea:area];
            
            
            NSString *country = placemark.country;
            NSLog(@"所在国家:%@",country);
            if (country.length == 0) {
                country = @"";
            }
            [[ConfigManager sharedInstance] setCountry:country];
        }
        
        [manager stopUpdatingLocation];   //停止定位
    }];
    
    
}

/* 定位失败后 回调 */
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    if (error.code == kCLErrorDenied) {
        // 提示用户出错
        NSLog(@"定位失败");
        
    }
    
    [[ConfigManager sharedInstance] setCountry:@""];
    [[ConfigManager sharedInstance] setCity:@""];
    [[ConfigManager sharedInstance] setArea:@""];
    [[ConfigManager sharedInstance] setCoord:@""];
}

NSString *const kInitVector = @"16-Bytes--String";


@end
