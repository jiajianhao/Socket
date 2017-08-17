//
//  CommonFuc.h
//  SocketUdpClient
//
//  Created by 小雨科技 on 2017/8/17.
//  Copyright © 2017年 jiajianhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CommonFuc : NSObject
+(CGFloat)getBatteryQuantity;
+(UIDeviceBatteryState)getBatteryStauts;
+(long long)getTotalMemorySize;
+(long long)getTotalDiskSize;
+(long long)getAvailableDiskSize;
+(NSString *)fileSizeToString:(unsigned long long)fileSize;
+(NSString *)deviceIPAdress;
+(NSString *)getWifiName;
+(CGFloat)getVersion;
@end
