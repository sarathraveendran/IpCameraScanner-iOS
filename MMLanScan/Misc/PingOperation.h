
#import "SimplePing.h"

@interface PingOperation : NSOperation <SimplePingDelegate> {
    BOOL _isFinished;
    BOOL _isExecuting;
}
-(nullable instancetype)initWithIPToPing:(nonnull NSString*)ip andCompletionHandler:(nullable void (^)(NSError  * _Nullable error, NSString  * _Nonnull ip))result;

@end
