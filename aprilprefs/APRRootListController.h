#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSListController.h>




@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (instancetype)defaultCenter;
- (void)postNotificationName:(NSString *)name object:(NSString *)object userInfo:(NSDictionary *)userInfo;
@end



@interface APRRootListController : PSListController
@property (nonatomic, retain) NSMutableDictionary *savedSpecifiers;
@end


@interface PSListController (Private)
-(BOOL)containsSpecifier:(PSSpecifier *)arg1;
@end