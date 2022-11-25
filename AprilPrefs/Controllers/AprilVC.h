@import AudioToolbox.AudioServices;
@import Preferences.PSSpecifier;
@import Preferences.PSListController;
#import "../Cells/AprilGaussianBlurCell.h"
#import "../Views/APPAnimatedTitleView.h"
#import "Headers/Common.h"
#import <spawn.h>


@interface OBWelcomeController : UIViewController
- (id)initWithTitle:(id)arg1 detailText:(id)arg2 icon:(id)arg3;
- (void)addBulletedListItemWithTitle:(id)arg1 description:(id)arg2 image:(id)arg3;
@end


@interface AprilVC : PSListController
@end


@interface AprilLinksVC : PSListController
@end


@interface AprilContributorsVC : PSListController
@end


@interface PSTableCell ()
- (void)setTitle:(NSString *)t;
@end


@interface AprilTableCell : PSTableCell
@end


@interface PSListController (Private)
- (BOOL)containsSpecifier:(PSSpecifier *)arg1;
@end
