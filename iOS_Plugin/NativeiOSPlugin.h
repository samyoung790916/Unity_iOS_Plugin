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

@interface NativeiOSPlugin : NSObject
{
    NativeDelegateNotification noti_handler;
}

@end


//@property (assign)

NS_ASSUME_NONNULL_END
