

#import <Foundation/Foundation.h>

@interface NetworkCalculator : NSObject
+(NSArray*)getAllHostsForIP:(NSString*)ipAddress andSubnet:(NSString*)subnetMask;
@end
