//
//  NativeiOSPlugin.m
//  quickObjc_sample
//
//  Created by samyoung79 on 19/03/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//

#import "NativeiOSPlugin.h"
#import "DataControl.h"


#define XCODE
@implementation NativeiOSPlugin

@end

extern "C"
{
    void JoinReqeust(char * szEmail, char * szPw, char * szName, NativeDelegateNotification handler)
    {
        [[DataControl sharedManager]join:szEmail password:szPw name:szName completion:^(BOOL success, NSString *  resultMessage) {
            NSLog(@"Join");
            handler(success,strdup([resultMessage UTF8String]));
        }];
        
    }
    
    void LoginReqeust(char * szEmail, char * szpw, NativeDelegateNotification handler)
    {
        [[DataControl sharedManager]login:szID password:szpw completion:^(BOOL success, NSString * result) {
            handler(success, strdup([result UTF8String]));
        }];
    }
    
    void DeviceConnectRequest(char * szDevice, NativeDelegateNotification handler){
        
        [[DataControl sharedManager]device_connect:szDevice completion:^(BOOL success, NSString * resultMessage) {
            handler(success,strdup([resultMessage UTF8String]));
        }];
    }
    
    void DeviceQuitRequest(char * szDevice, NativeDelegateNotification handler){
        
        [[DataControl sharedManager]device_quit:szDevice completion:^(BOOL success, NSString * resultMessage) {
            handler(success, strdup([resultMessage UTF8String]));
        }];
    }
    
    void DeviceListRequest(char * szEmail, NativeDelegateDataNotification handler){
        
        [[DataControl sharedManager]device_list:szEmail completion:^(BOOL success, NSString * resultMessage, NSArray * list) {
            
            if(success == YES){
                
                char ** ptr = (char **)malloc((list.count) * sizeof(char *));
                
                for(int i = 0; i < list.count; i++)
                {
                    NSDictionary * pDict = [list objectAtIndex:i];
                    NSString * strDeviceName = [pDict objectForKey:@"DEVICE_NAME"];
                    ptr[i] = strdup([strDeviceName UTF8String]);
                }
                
                handler(success, strdup([resultMessage UTF8String]),ptr);
                free(ptr);
            }
            
        }];
    }
    
    void SendMessageRequest(char * szMessage,NativeDelegateDataNotification handler){
        [[DataControl sharedManager] sendmessage:szMessage completion:^(BOOL success, NSString * _Nullable errorMessage) {
            handler(success, strdup([errorMessage UTF8String]),nil);
        }];
    }
    
}
