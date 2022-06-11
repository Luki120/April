// Credits for the implementation of the changelog controller:
// https://github.com/nahtedetihw
// https://github.com/nahtedetihw/MusicBackground


#import "AprilVC.h"


static void postNSNotification() {

	[NSNotificationCenter.defaultCenter postNotificationName:@"applyImage" object:NULL];
	[NSNotificationCenter.defaultCenter postNotificationName:@"applyGradient" object:NULL];
	[NSNotificationCenter.defaultCenter postNotificationName:@"applyScheduledImage" object:NULL];

}


@implementation AprilVC {

	APPAnimatedTitleView *aprilTitleView;
	UIView *headerView;
	UIImageView *headerImageView;
	NSMutableDictionary *savedSpecifiers;
	OBWelcomeController *changelogController;

}


#pragma mark Lifecycle

- (NSArray *)specifiers {

	if(_specifiers) return nil;
	_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];

	NSArray *chosenIDs = @[

		@"GroupCell-1",
		@"Image",
		@"LightImage",
		@"SegmentCell",
		@"BlurValue",
		@"AlphaValue",
		@"GroupCell-5",
		@"AnimateGradientSwitch",
		@"FirstColor",
		@"SecondColor",
		@"GroupCell-6",
		@"GroupCell-7",
		@"GradientDirection",
		@"GroupCell8",
		@"MorningImage",
		@"AfternoonImage",
		@"SunsetImage",
		@"MidnightImage"

	];

	savedSpecifiers = (savedSpecifiers) ?: [NSMutableDictionary new];

	for(PSSpecifier *specifier in _specifiers)

		if([chosenIDs containsObject:[specifier propertyForKey:@"id"]])

			[savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];

	return _specifiers;

}


- (id)init {

	self = [super init];
	if(!self) return nil;

	[self setupUI];

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)postNSNotification, CFSTR("me.luki.aprilprefs/imageChanged"), NULL, 0);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)postNSNotification, CFSTR("me.luki.aprilprefs/gradientChanged"), NULL, 0);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)postNSNotification, CFSTR("me.luki.aprilprefs/scheduledImageChanged"), NULL, 0);

	[NSNotificationCenter.defaultCenter removeObserver:self];
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(presentVC) name:@"presentVC" object:nil];

	return self;

}


- (void)viewDidLoad {

	[super viewDidLoad];
	[self reloadSpecifiers];

}


- (void)viewDidAppear:(BOOL)animated {

	[super viewDidAppear:animated];

	if(self.navigationItem.titleView) return;

	aprilTitleView = [[APPAnimatedTitleView alloc] initWithTitle:@"April 2.1" minimumScrollOffsetRequired:-68];
	self.navigationItem.titleView = aprilTitleView;

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


- (void)reloadSpecifiers {

	[super reloadSpecifiers];

	if(![[self readPreferenceValue:[self specifierForID:@"YesSwitch"]] boolValue]) {

		[self removeSpecifier:savedSpecifiers[@"GroupCell-1"] animated:NO];
		[self removeSpecifier:savedSpecifiers[@"Image"] animated:NO];
		[self removeSpecifier:savedSpecifiers[@"LightImage"] animated:NO];

	}

	else if(![self containsSpecifier:savedSpecifiers[@"GroupCell-1"]]) {

		[self insertSpecifier:savedSpecifiers[@"GroupCell-1"] afterSpecifierID:@"YesSwitch" animated:NO];
		[self insertSpecifier:savedSpecifiers[@"Image"] afterSpecifierID:@"GroupCell-1" animated:NO];
		[self insertSpecifier:savedSpecifiers[@"LightImage"] afterSpecifierID:@"Image" animated:NO];

	}

	if(![[self readPreferenceValue:[self specifierForID:@"BlurSwitch"]] boolValue]) {

		[self removeSpecifier:savedSpecifiers[@"SegmentCell"] animated:NO];
		[self removeSpecifier:savedSpecifiers[@"BlurValue"] animated:NO];

	}

	else if(![self containsSpecifier:savedSpecifiers[@"SegmentCell"]]) {

		[self insertSpecifier:savedSpecifiers[@"SegmentCell"] afterSpecifierID:@"BlurSwitch" animated:NO];
		[self insertSpecifier:savedSpecifiers[@"BlurValue"] afterSpecifierID:@"SegmentCell" animated:NO];

	}

	if(![[self readPreferenceValue:[self specifierForID:@"GradientSwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-5"], savedSpecifiers[@"AnimateGradientSwitch"], savedSpecifiers[@"GroupCell-6"], savedSpecifiers[@"FirstColor"], savedSpecifiers[@"SecondColor"], savedSpecifiers[@"GroupCell-7"], savedSpecifiers[@"GradientDirection"]] animated:NO];

	else if(![self containsSpecifier:savedSpecifiers[@"GroupCell-5"]])

		[self insertContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-5"], savedSpecifiers[@"AnimateGradientSwitch"], savedSpecifiers[@"GroupCell-6"], savedSpecifiers[@"FirstColor"], savedSpecifiers[@"SecondColor"], savedSpecifiers[@"GroupCell-7"], savedSpecifiers[@"GradientDirection"]] afterSpecifierID:@"GradientSwitch" animated:NO];

	if(![[self readPreferenceValue:[self specifierForID:@"ScheduledImagesSwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[savedSpecifiers[@"GroupCell8"], savedSpecifiers[@"MorningImage"], savedSpecifiers[@"AfternoonImage"], savedSpecifiers[@"SunsetImage"], savedSpecifiers[@"MidnightImage"]] animated:NO];

	else if(![self containsSpecifier:savedSpecifiers[@"GroupCell8"]])

		[self insertContiguousSpecifiers:@[savedSpecifiers[@"GroupCell8"], savedSpecifiers[@"MorningImage"], savedSpecifiers[@"AfternoonImage"], savedSpecifiers[@"SunsetImage"], savedSpecifiers[@"MidnightImage"]] afterSpecifierID:@"ScheduledImagesSwitch" animated:NO];

}


- (void)showWtfChangedInThisVersion {

	AudioServicesPlaySystemSound(1521);

	UIImage *tweakImage = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AprilPrefs.bundle/Assets/AprilIcon.png"];
	UIImage *checkmarkImage = [UIImage systemImageNamed:@"checkmark.circle.fill"];

	changelogController = [[OBWelcomeController alloc] initWithTitle:@"April" detailText:@"2.1" icon:tweakImage];
	[changelogController addBulletedListItemWithTitle:@"Code" description:@"Refactoring." image:checkmarkImage];
	[changelogController addBulletedListItemWithTitle:@"Tweak" description:@"Added a Gaussian blur option." image:checkmarkImage];

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

	_UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithSettings:settings];
	backdropView.clipsToBounds = YES;
	backdropView.layer.masksToBounds = YES;
	backdropView.translatesAutoresizingMaskIntoConstraints = NO;
	[changelogController.viewIfLoaded insertSubview:backdropView atIndex:0];

	[backdropView.topAnchor constraintEqualToAnchor: changelogController.viewIfLoaded.topAnchor].active = YES;
	[backdropView.bottomAnchor constraintEqualToAnchor: changelogController.viewIfLoaded.bottomAnchor].active = YES;
	[backdropView.leadingAnchor constraintEqualToAnchor: changelogController.viewIfLoaded.leadingAnchor].active = YES;
	[backdropView.trailingAnchor constraintEqualToAnchor: changelogController.viewIfLoaded.trailingAnchor].active = YES;

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

		NSFileManager *fileM = [NSFileManager defaultManager];

		[fileM removeItemAtPath:@"/var/mobile/Library/Preferences/me.luki.aprilprefs.plist" error:nil];
		[fileM removeItemAtPath:@"/var/mobile/Library/Preferences/me.luki.aprilprefs" error:nil];

		[self crossDissolveBlur];

	}];

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Meh" style:UIAlertActionStyleCancel handler:nil];

	[alertController addAction:confirmAction];
	[alertController addAction:cancelAction];

	[self presentViewController:alertController animated:YES completion:nil];

}


- (void)crossDissolveBlur {

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

	_UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithSettings:settings];
	backdropView.alpha = 0;
	backdropView.frame = self.view.bounds;
	backdropView.clipsToBounds = YES;
	backdropView.layer.masksToBounds = YES;
	[self.view addSubview:backdropView];

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


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

	if([self.navigationItem.titleView respondsToSelector:@selector(adjustLabelPositionToScrollOffset:)])

		[(APPAnimatedTitleView *)self.navigationItem.titleView adjustLabelPositionToScrollOffset:scrollView.contentOffset.y];

}


#pragma mark Table View Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	tableView.tableHeaderView = headerView;
	return [super tableView:tableView cellForRowAtIndexPath:indexPath];

}


- (id)readPreferenceValue:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile: kPath]];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile: kPath]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:kPath atomically:YES];

	[super setPreferenceValue:value specifier:specifier];

	[NSNotificationCenter.defaultCenter postNotificationName:@"applyImage" object:NULL];
	[NSNotificationCenter.defaultCenter postNotificationName:@"applyAlpha" object:NULL];
	[NSNotificationCenter.defaultCenter postNotificationName:@"applyGradient" object:NULL];
	[NSNotificationCenter.defaultCenter postNotificationName:@"applyScheduledImage" object:NULL];

	NSString *key = [specifier propertyForKey:@"key"];

	if([key isEqualToString:@"yes"]) {

		if(![value boolValue]) {

			[self removeSpecifier:savedSpecifiers[@"GroupCell-1"] animated:YES];
			[self removeSpecifier:savedSpecifiers[@"Image"] animated:YES];
			[self removeSpecifier:savedSpecifiers[@"LightImage"] animated:NO];

		}

		else if(![self containsSpecifier:savedSpecifiers[@"Image"]]) {

			[self insertSpecifier:savedSpecifiers[@"GroupCell-1"] afterSpecifierID:@"YesSwitch" animated:YES];
			[self insertSpecifier:savedSpecifiers[@"Image"] afterSpecifierID:@"GroupCell-1" animated:YES];
			[self insertSpecifier:savedSpecifiers[@"LightImage"] afterSpecifierID:@"Image" animated:NO];

		}

	}

	if([key isEqualToString:@"blur"]) {

		if(![value boolValue]) {

			[self removeSpecifier:savedSpecifiers[@"SegmentCell"] animated:YES];
			[self removeSpecifier:savedSpecifiers[@"BlurValue"] animated:YES];

		}

		else if(![self containsSpecifier:savedSpecifiers[@"BlurValue"]]) {

			[self insertSpecifier:savedSpecifiers[@"SegmentCell"] afterSpecifierID:@"BlurSwitch" animated:YES];
			[self insertSpecifier:savedSpecifiers[@"BlurValue"] afterSpecifierID:@"SegmentCell" animated:YES];

		}

	}

	if([key isEqualToString:@"setGradientAsBackground"]) {

		if(![value boolValue])

			[self removeContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-5"], savedSpecifiers[@"AnimateGradientSwitch"], savedSpecifiers[@"GroupCell-6"], savedSpecifiers[@"FirstColor"], savedSpecifiers[@"SecondColor"], savedSpecifiers[@"GroupCell-7"], savedSpecifiers[@"GradientDirection"]] animated:YES];

		else if (![self containsSpecifier:savedSpecifiers[@"GroupCell-5"]])

			[self insertContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-5"], savedSpecifiers[@"AnimateGradientSwitch"], savedSpecifiers[@"GroupCell-6"], savedSpecifiers[@"FirstColor"], savedSpecifiers[@"SecondColor"], savedSpecifiers[@"GroupCell-7"], savedSpecifiers[@"GradientDirection"]] afterSpecifierID:@"GradientSwitch" animated:YES];

	}

	if([key isEqualToString:@"scheduledImages"]) {

		if(![[self readPreferenceValue:[self specifierForID:@"ScheduledImagesSwitch"]] boolValue])

			[self removeContiguousSpecifiers:@[savedSpecifiers[@"GroupCell8"], savedSpecifiers[@"MorningImage"], savedSpecifiers[@"AfternoonImage"], savedSpecifiers[@"SunsetImage"], savedSpecifiers[@"MidnightImage"]] animated:YES];


		else if(![self containsSpecifier:savedSpecifiers[@"GroupCell8"]])

			[self insertContiguousSpecifiers:@[savedSpecifiers[@"GroupCell8"], savedSpecifiers[@"MorningImage"], savedSpecifiers[@"AfternoonImage"], savedSpecifiers[@"SunsetImage"], savedSpecifiers[@"MidnightImage"]] afterSpecifierID:@"ScheduledImagesSwitch" animated:YES];    

	}

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


- (void)launchDiscord {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://discord.gg/jbE3avwSHs"] options:@{} completionHandler:nil];

}


- (void)launchPayPal {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://paypal.me/Luki120"] options:@{} completionHandler:nil];

}


- (void)launchGitHub {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://github.com/Luki120/April"] options:@{} completionHandler:nil];

}


- (void)launchAmelija {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://repo.twickd.com/get/me.luki.amelija"] options:@{} completionHandler:nil];

}


- (void)launchMeredith {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://repo.twickd.com/get/com.twickd.luki120.meredith"] options:@{} completionHandler:nil];

}


@end


@implementation AprilTableCell

- (void)setTitle:(NSString *)t {

	[super setTitle:t];
	self.titleLabel.textColor = kAprilTintColor;

}

@end
