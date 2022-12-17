// Credits for the implementation of the changelog controller:
// https://github.com/nahtedetihw
// https://github.com/nahtedetihw/MusicBackground


#import "AprilVC.h"

// ! Constants

static NSString *const kImagesPath = @"/var/mobile/Library/Preferences/me.luki.aprilprefs";

static const char *april_image_changed = "me.luki.aprilprefs/imageChanged";
static const char *april_gradient_changed = "me.luki.aprilprefs/gradientChanged";

@interface AprilVC () <AprilGaussianBlurCellDelegate>
@end

@implementation AprilVC {

	UIView *headerView;
	UIImageView *headerImageView;
	APPAnimatedTitleView *aprilTitleView;
	NSMutableDictionary *savedSpecifiers;
	OBWelcomeController *changelogController;

}


// ! Lifecycle

- (NSArray *)specifiers {

	if(_specifiers) return nil;
	_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];

	NSArray *chosenIDs = @[
		@"GroupCell-1",
		@"DarkImage",
		@"LightImage",
		@"BlurSegmentCell",
		@"BlurValue",
		@"GroupCell-2",
		@"AnimateGradientSwitch",
		@"FirstColor",
		@"SecondColor",
		@"GroupCell-3",
		@"GroupCell-4",
		@"GradientDirection",
		@"GroupCell-5",
		@"MorningImage",
		@"AfternoonImage",
		@"SunsetImage",
		@"MidnightImage"
	];

	savedSpecifiers = savedSpecifiers ?: [NSMutableDictionary new];

	for(PSSpecifier *specifier in _specifiers)

		if([chosenIDs containsObject:[specifier propertyForKey:@"id"]])

			[savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];

	return _specifiers;

}


- (id)init {

	self = [super init];
	if(!self) return nil;

	[self setupUI];
	[self setupObservers];

	return self;

}


- (void)setupUI {

	UIImage *bannerImage = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AprilPrefs.bundle/Assets/AprilBanner.png"];
	UIImage *changelogImage = [UIImage systemImageNamed:@"atom"];

	headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,200,200)];
	headerImageView = [UIImageView new];
	headerImageView.image = bannerImage;
	headerImageView.contentMode = UIViewContentModeScaleAspectFill;
	headerImageView.clipsToBounds = YES;
	headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
	[headerView addSubview:headerImageView];

	UIButton *changelogButton =  [UIButton new];
	changelogButton.tintColor = kAprilTintColor;
	[changelogButton setImage:changelogImage forState:UIControlStateNormal];
	[changelogButton addTarget:self action:@selector(showWtfChangedInThisVersion) forControlEvents:UIControlEventTouchUpInside];

	UIBarButtonItem *changelogButtonItem = [[UIBarButtonItem alloc] initWithCustomView:changelogButton];
	self.navigationItem.rightBarButtonItem = changelogButtonItem;

	[self layoutUI];

}


- (void)layoutUI {

	[headerImageView.topAnchor constraintEqualToAnchor: headerView.topAnchor].active = YES;
	[headerImageView.bottomAnchor constraintEqualToAnchor: headerView.bottomAnchor].active = YES;
	[headerImageView.leadingAnchor constraintEqualToAnchor: headerView.leadingAnchor].active = YES;
	[headerImageView.trailingAnchor constraintEqualToAnchor: headerView.trailingAnchor].active = YES;

}


- (void)setupObservers {

	// credits for this dark juju stuff to replace the long ass CoreFoundation syntax ⇝ https://github.com/leptos-null
	int register_token = 0;
	notify_register_dispatch(april_image_changed, &register_token, dispatch_get_main_queue(), ^(int token) {
		[NSNotificationCenter.defaultCenter postNotificationName:AprilApplyImageNotification object:NULL];
	});
	notify_register_dispatch(april_gradient_changed, &register_token, dispatch_get_main_queue(), ^(int token) {
		[NSNotificationCenter.defaultCenter postNotificationName:AprilApplyGradientNotification object:NULL];
	});

	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(presentVC) name:AprilPresentVCNotification object:nil];

}


- (void)viewDidLoad {

	[super viewDidLoad];
	[self reloadSpecifiers];

}


- (void)viewDidAppear:(BOOL)animated {

	[super viewDidAppear: animated];

	if(self.navigationItem.titleView) return;

	aprilTitleView = [[APPAnimatedTitleView alloc] initWithTitle:@"April 2.2" minimumScrollOffsetRequired: -68];
	self.navigationItem.titleView = aprilTitleView;

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

	if([self.navigationItem.titleView respondsToSelector:@selector(adjustLabelPositionToScrollOffset:)])
		[(APPAnimatedTitleView *)self.navigationItem.titleView adjustLabelPositionToScrollOffset:scrollView.contentOffset.y];

}


- (void)reloadSpecifiers {

	[super reloadSpecifiers];

	if(![[self readPreferenceValue:[self specifierForID:@"YesSwitch"]] boolValue]) {

		[self removeSpecifier:savedSpecifiers[@"GroupCell-1"] animated:NO];
		[self removeSpecifier:savedSpecifiers[@"DarkImage"] animated:NO];
		[self removeSpecifier:savedSpecifiers[@"LightImage"] animated:NO];

	}

	else if(![self containsSpecifier:savedSpecifiers[@"GroupCell-1"]]) {

		[self insertSpecifier:savedSpecifiers[@"GroupCell-1"] afterSpecifierID:@"YesSwitch" animated:NO];
		[self insertSpecifier:savedSpecifiers[@"DarkImage"] afterSpecifierID:@"GroupCell-1" animated:NO];
		[self insertSpecifier:savedSpecifiers[@"LightImage"] afterSpecifierID:@"DarkImage" animated:NO];

	}

	if(![[self readPreferenceValue:[self specifierForID:@"BlurSwitch"]] boolValue]) {

		[self removeSpecifier:savedSpecifiers[@"BlurSegmentCell"] animated:NO];
		[self removeSpecifier:savedSpecifiers[@"BlurValue"] animated:NO];

	}

	else if(![self containsSpecifier:savedSpecifiers[@"BlurSegmentCell"]]) {

		[self insertSpecifier:savedSpecifiers[@"BlurSegmentCell"] afterSpecifierID:@"BlurSwitch" animated:NO];
		[self insertSpecifier:savedSpecifiers[@"BlurValue"] afterSpecifierID:@"BlurSegmentCell" animated:NO];

	}

	if(![[self readPreferenceValue:[self specifierForID:@"GradientSwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-2"], savedSpecifiers[@"AnimateGradientSwitch"], savedSpecifiers[@"GroupCell-3"], savedSpecifiers[@"FirstColor"], savedSpecifiers[@"SecondColor"], savedSpecifiers[@"GroupCell-4"], savedSpecifiers[@"GradientDirection"]] animated:NO];

	else if(![self containsSpecifier:savedSpecifiers[@"GroupCell-2"]])

		[self insertContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-2"], savedSpecifiers[@"AnimateGradientSwitch"], savedSpecifiers[@"GroupCell-3"], savedSpecifiers[@"FirstColor"], savedSpecifiers[@"SecondColor"], savedSpecifiers[@"GroupCell-4"], savedSpecifiers[@"GradientDirection"]] afterSpecifierID:@"GradientSwitch" animated:NO];

	if(![[self readPreferenceValue:[self specifierForID:@"ScheduledImagesSwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-5"], savedSpecifiers[@"MorningImage"], savedSpecifiers[@"AfternoonImage"], savedSpecifiers[@"SunsetImage"], savedSpecifiers[@"MidnightImage"]] animated:NO];

	else if(![self containsSpecifier:savedSpecifiers[@"GroupCell-5"]])

		[self insertContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-5"], savedSpecifiers[@"MorningImage"], savedSpecifiers[@"AfternoonImage"], savedSpecifiers[@"SunsetImage"], savedSpecifiers[@"MidnightImage"]] afterSpecifierID:@"ScheduledImagesSwitch" animated:NO];

}

// ! Selectors

- (void)showWtfChangedInThisVersion {

	AudioServicesPlaySystemSound(1521);

	UIImage *tweakImage = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AprilPrefs.bundle/Assets/AprilIcon.png"];
	UIImage *checkmarkImage = [UIImage systemImageNamed:@"checkmark.circle.fill"];

	if(changelogController) { [self presentViewController:changelogController animated:YES completion:nil]; return; }
	changelogController = [[OBWelcomeController alloc] initWithTitle:@"April" detailText:@"2.2" icon:tweakImage];
	[changelogController addBulletedListItemWithTitle:@"Code" description:@"Even more refactoring ⇝ everything works the same, but better." image:checkmarkImage];

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

	_UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
	backdropView.clipsToBounds = YES;
	[changelogController.viewIfLoaded insertSubview:backdropView atIndex:0];

	changelogController.viewIfLoaded.backgroundColor = UIColor.clearColor;
	changelogController.view.tintColor = kAprilTintColor;
	changelogController.modalInPresentation = NO;
	changelogController.modalPresentationStyle = UIModalPresentationPageSheet;

	[self presentViewController:changelogController animated:YES completion:nil];

}


- (void)shatterThePrefsToPieces {

	AudioServicesPlaySystemSound(1521);

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"April" message:@"Do you want to start fresh?" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Shoot" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {

		[[NSFileManager defaultManager] removeItemAtPath:kPath error:nil];
		[[NSFileManager defaultManager] removeItemAtPath:kImagesPath error:nil];

		[self crossDissolveBlur];

	}];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Meh" style:UIAlertActionStyleCancel handler:nil];

	[alertController addAction: confirmAction];
	[alertController addAction: cancelAction];

	[self presentViewController:alertController animated:YES completion:nil];

}


- (void)crossDissolveBlur {

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

	_UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
	backdropView.alpha = 0;
	backdropView.clipsToBounds = YES;
	[self.view addSubview: backdropView];

	[UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		backdropView.alpha = 1;

	} completion:^(BOOL finished) { [self killSettings]; }];

}


- (void)killSettings {

	pid_t pid;
	const char* args[] = {"killall", "Preferences", NULL};
	posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);

}


- (void)launchGradientPresets {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://digitalsynopsis.com/design/beautiful-gradient-color-palettes/"] options:@{} completionHandler:nil];

}

// ! UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	tableView.tableHeaderView = headerView;

	AprilGaussianBlurCell *cell = (AprilGaussianBlurCell *)[super tableView:tableView cellForRowAtIndexPath: indexPath];
	if([cell isKindOfClass: AprilGaussianBlurCell.class]) cell.delegate = self;
	return cell;

}

// ! Preferences

- (id)readPreferenceValue:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile: kPath]];
	return settings[specifier.properties[@"key"]] ?: specifier.properties[@"default"];

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile: kPath]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:kPath atomically:YES];

	[super setPreferenceValue:value specifier:specifier];

	[NSNotificationCenter.defaultCenter postNotificationName:AprilApplyImageNotification object:NULL];
	[NSNotificationCenter.defaultCenter postNotificationName:AprilApplyAlphaNotification object:NULL];
	[NSNotificationCenter.defaultCenter postNotificationName:AprilApplyGradientNotification object:NULL];

	NSString *key = [specifier propertyForKey:@"key"];

	if([key isEqualToString:@"yes"]) {

		if(![value boolValue]) {

			[self removeSpecifier:savedSpecifiers[@"GroupCell-1"] animated:YES];
			[self removeSpecifier:savedSpecifiers[@"DarkImage"] animated:YES];
			[self removeSpecifier:savedSpecifiers[@"LightImage"] animated:YES];

		}

		else if(![self containsSpecifier:savedSpecifiers[@"DarkImage"]]) {

			[self insertSpecifier:savedSpecifiers[@"GroupCell-1"] afterSpecifierID:@"YesSwitch" animated:YES];
			[self insertSpecifier:savedSpecifiers[@"DarkImage"] afterSpecifierID:@"GroupCell-1" animated:YES];
			[self insertSpecifier:savedSpecifiers[@"LightImage"] afterSpecifierID:@"DarkImage" animated:YES];

		}

	}

	if([key isEqualToString:@"blur"]) {

		if(![value boolValue]) {

			[self removeSpecifier:savedSpecifiers[@"BlurSegmentCell"] animated:YES];
			[self removeSpecifier:savedSpecifiers[@"BlurValue"] animated:YES];

		}

		else if(![self containsSpecifier:savedSpecifiers[@"BlurValue"]]) {

			[self insertSpecifier:savedSpecifiers[@"BlurSegmentCell"] afterSpecifierID:@"BlurSwitch" animated:YES];
			[self insertSpecifier:savedSpecifiers[@"BlurValue"] afterSpecifierID:@"BlurSegmentCell" animated:YES];

		}

	}

	if([key isEqualToString:@"setGradientAsBackground"]) {

		if(![value boolValue])

			[self removeContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-2"], savedSpecifiers[@"AnimateGradientSwitch"], savedSpecifiers[@"GroupCell-3"], savedSpecifiers[@"FirstColor"], savedSpecifiers[@"SecondColor"], savedSpecifiers[@"GroupCell-4"], savedSpecifiers[@"GradientDirection"]] animated:YES];

		else if (![self containsSpecifier:savedSpecifiers[@"GroupCell-2"]])

			[self insertContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-2"], savedSpecifiers[@"AnimateGradientSwitch"], savedSpecifiers[@"GroupCell-3"], savedSpecifiers[@"FirstColor"], savedSpecifiers[@"SecondColor"], savedSpecifiers[@"GroupCell-4"], savedSpecifiers[@"GradientDirection"]] afterSpecifierID:@"GradientSwitch" animated:YES];

	}

	if([key isEqualToString:@"scheduledImages"]) {

		if(![[self readPreferenceValue:[self specifierForID:@"ScheduledImagesSwitch"]] boolValue])

			[self removeContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-5"], savedSpecifiers[@"MorningImage"], savedSpecifiers[@"AfternoonImage"], savedSpecifiers[@"SunsetImage"], savedSpecifiers[@"MidnightImage"]] animated:YES];

		else if(![self containsSpecifier:savedSpecifiers[@"GroupCell-5"]])

			[self insertContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-5"], savedSpecifiers[@"MorningImage"], savedSpecifiers[@"AfternoonImage"], savedSpecifiers[@"SunsetImage"], savedSpecifiers[@"MidnightImage"]] afterSpecifierID:@"ScheduledImagesSwitch" animated:YES];    

	}

}

// ! AprilGaussianBlurCellDelegate

- (void)aprilGaussianBlurCellDidTapGaussianBlurButton {

	[[AprilImageManager sharedInstance] blurImage];
	[self presentViewController:[AprilImageManager sharedInstance]->firstAlertVC animated:YES completion:nil];

}


- (void)aprilGaussianBlurCellDidTapGaussianBlurInfoButton {

	AudioServicesPlaySystemSound(1521);

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"April" message:@"The gaussian blur is an actual blur applied to the image, rather than an overlay view, like the epic one. This means you can save any image you want with the blur applied, and with any intensity you want. Since generating the blur takes quite some resources, including it directly as an option wouldn't be the best performance wise without sacrificing on the fly preferences. However, you can save any image you want and then come back here and apply it. The image that'll be saved is the one you currently have selected depending on dark/light mode." preferredStyle: UIAlertControllerStyleAlert];
	UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleDefault handler: nil];
	[alertController addAction: dismissAction];
	[self presentViewController:alertController animated:YES completion: nil];

}


- (void)presentVC {

	[self presentViewController:[AprilImageManager sharedInstance]->secondAlertVC animated:YES completion:nil];

}

@end


@implementation AprilContributorsVC

- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"AprilContributors" target:self];
	return _specifiers;

}

@end


@implementation AprilLinksVC

- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"AprilLinks" target:self];
	return _specifiers;

}


- (void)launchDiscord { [self launchURL: [NSURL URLWithString: @"https://discord.gg/jbE3avwSHs"]]; }
- (void)launchGitHub { [self launchURL: [NSURL URLWithString: @"https://github.com/Luki120/April"]]; }
- (void)launchPayPal { [self launchURL: [NSURL URLWithString: @"https://paypal.me/Luki120"]]; }
- (void)launchAmelija { [self launchURL: [NSURL URLWithString:@"https://repo.twickd.com/get/me.luki.amelija"]]; }
- (void)launchMeredith { [self launchURL: [NSURL URLWithString: @"https://repo.twickd.com/get/com.twickd.luki120.meredith"]]; }

- (void)launchURL:(NSURL *)url { [UIApplication.sharedApplication openURL:url options:@{} completionHandler:nil]; }

@end


@implementation AprilTableCell

- (void)setTitle:(NSString *)title {

	[super setTitle: title];
	self.titleLabel.textColor = kAprilTintColor;

}

@end
