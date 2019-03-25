//
//  NativeiOSPlugin.h
//  quickObjc_sample
//
//  Created by samyoung79 on 19/03/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


typedef void (*NativeDelegateNotification)(BOOL bSuccess, const char * szMessage);
typedef void (*NativeDelegateDataNotification)(BOOL bSuccess, char * szMessage, char ** ptr);

@interface NativeiOSPlugin : NSObject
{
    NativeDelegateNotification noti_handler;
    NativeDelegateDataNotification data_hanler;
}

@end


//@property (assign)

NS_ASSUME_NONNULL_END
