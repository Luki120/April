#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSListController.h>




@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (instancetype)defaultCenter;
- (void)postNotificationName:(NSString *)name object:(NSString *)object userInfo:(NSDictionary *)userInfo;
@end


@interface AprilContributorsRootListController : PSListController
@end


@interface APRRootListController : PSListController
@end


@interface AprilTableCell : PSTableCell
@end