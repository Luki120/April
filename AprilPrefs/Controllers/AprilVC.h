@import AudioToolbox.AudioServices;
@import ObjectiveC.message;
@import ObjectiveC.runtime;
@import Preferences.PSSpecifier;
@import Preferences.PSListController;
@import Preferences.PSSliderTableCell;
#import "../Cells/AprilGaussianBlurCell.h"
#import "../Views/APPAnimatedTitleView.h"
#import "../../Managers/AprilImageManager.h"
#import <notify.h>
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


@interface PSListController (Private)
- (BOOL)containsSpecifier:(PSSpecifier *)arg1;
@end
