//
//  CommonFuc.m
//  SocketUdpClient
//
//  Created by 小雨科技 on 2017/8/17.
//  Copyright © 2017年 jiajianhao. All rights reserved.
//

#import "CommonFuc.h"
#include <mach/machine/vm_types.h>
#include <sys/mount.h>//获取总磁盘容量
#import <ifaddrs.h>//用于获取IP地址
#import <arpa/inet.h>//用于获取IP地址
#import <SystemConfiguration/CaptiveNetwork.h>//用于当前手机连接的WIFI名称(SSID)
@implementation CommonFuc


/**
 获取电池电量,一般用百分数表示
 */
+(CGFloat)getBatteryQuantity
{
    return [[UIDevice currentDevice] batteryLevel];
}

/**
获取电池状态 
 */
+(UIDeviceBatteryState)getBatteryStauts
{
    return [UIDevice currentDevice].batteryState;
}

/**
 获取总内存大小
*/
+(long long)getTotalMemorySize
{
    return [NSProcessInfo processInfo].physicalMemory;
}

///**
// 获取当前可用内存
//*/
//-(long long)getAvailableMemorySize
//{
//    vm_statistics_data_t vmStats;
//    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
//    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
//    if (kernReturn != KERN_SUCCESS)
//    {
//        return NSNotFound;
//    }
//    return ((vm_page_size * vmStats.free_count + vm_page_size * vmStats.inactive_count));
//}


/**
 获取已使用内存
 */
//- (double)getUsedMemory
//{
//    task_basic_info_data_t taskInfo;
//    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
//    kern_return_t kernReturn = task_info(mach_task_self(),
//                                         TASK_BASIC_INFO,
//                                         (task_info_t)&taskInfo,
//                                         &infoCount);
//    
//    if (kernReturn != KERN_SUCCESS
//        ) {
//        return NSNotFound;
//    }
//    
//    return taskInfo.resident_size;
//}


/**
 
获取总磁盘容量
*/
+(long long)getTotalDiskSize
{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_blocks);
    }
    return freeSpace;
}


/**
 获取可用磁盘容量
*/
+(long long)getAvailableDiskSize
{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }
    return freeSpace;
}


/**
 
容量转换
 */
+(NSString *)fileSizeToString:(unsigned long long)fileSize
{
    NSInteger KB = 1024;
    NSInteger MB = KB*KB;
    NSInteger GB = MB*KB;
    
    if (fileSize < 10)  {
        return @"0 B";
    }else if (fileSize < KB)    {
        return @"< 1 KB";
    }else if (fileSize < MB)    {
        return [NSString stringWithFormat:@"%.1f KB",((CGFloat)fileSize)/KB];
    }else if (fileSize < GB)    {
        return [NSString stringWithFormat:@"%.1f MB",((CGFloat)fileSize)/MB];
    }else   {
        return [NSString stringWithFormat:@"%.1f GB",((CGFloat)fileSize)/GB];
    }
}


/**
 IP地址
 */
+ (NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    return address;
}


/**
 当前手机连接的WIFI名称(SSID)
 */
+(NSString *)getWifiName
{
    NSString *wifiName = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    if (!wifiInterfaces) {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    return wifiName;
}

/**
 当前手机系統版本
 */
+(CGFloat)getVersion{
  return   [[[UIDevice currentDevice] systemVersion] floatValue] ;
}
@end
