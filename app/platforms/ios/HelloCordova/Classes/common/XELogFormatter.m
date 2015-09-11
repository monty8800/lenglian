//
//  XELogFormatter.m
//  HelloCordova
//
//  Created by ywen on 15/7/21.
//
//

#import "XELogFormatter.h"

@implementation XELogFormatter

-(NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel;
    switch (logMessage->_flag) {
        case DDLogFlagError:
            logLevel = @"Err";
            break;
            
        case DDLogFlagWarning:
            logLevel = @"Warn";
            break;
            
        case DDLogFlagDebug:
            logLevel = @"Debug";
            break;
            
        case DDLogFlagInfo:
            logLevel = @"Info";
            break;
            
        case DDLogFlagVerbose:
            
        default:
            logLevel = @"Verbose";
            break;
            break;
    }
    return [NSString stringWithFormat:@"%@ | %@:%@-%@: %@", logLevel, logMessage.file, @(logMessage.line) , logMessage.function, logMessage.message];
}

@end
