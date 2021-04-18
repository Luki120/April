#include "APRRootListController.h"




static NSString *plistPath = @"/var/mobile/Library/Preferences/me.luki.aprilprefs.plist";


#define tint [UIColor colorWithRed: 1.00 green: 0.55 blue: 0.73 alpha: 1.00]


static void postNSNotification() {

	[NSNotificationCenter.defaultCenter postNotificationName:@"changeImage" object:NULL];
	[NSNotificationCenter.defaultCenter postNotificationName:@"changeGradient" object:NULL];
    [NSNotificationCenter.defaultCenter postNotificationName:@"changeBlur" object:NULL];

}


@implementation APRRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];

	}

	return _specifiers;

}


-(void)viewDidLoad{
	
	[super viewDidLoad];
	
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)postNSNotification, CFSTR("me.luki.aprilprefs/imageChanged"), NULL, 0);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)postNSNotification, CFSTR("me.luki.aprilprefs/gradientChanged"), NULL, 0);

	UIImage *banner = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AprilPrefs.bundle/epicbanner.png"];
	
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,UIScreen.mainScreen.bounds.size.width,UIScreen.mainScreen.bounds.size.width * banner.size.height / banner.size.width)];
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,200,200)];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.image = banner;
    self.headerImageView.translatesAutoresizingMaskIntoConstraints = NO;


	[self.headerView addSubview:self.headerImageView];


	self.navigationItem.titleView = [UIView new];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,10,10)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
	self.titleLabel.text = @"1.0";
	if ([[self traitCollection] userInterfaceStyle] == UIUserInterfaceStyleDark) self.titleLabel.textColor = [UIColor whiteColor];
	else if ([[self traitCollection] userInterfaceStyle] == UIUserInterfaceStyleLight) self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navigationItem.titleView addSubview:self.titleLabel];

    self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,10,10)];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AprilPrefs.bundle/icon@2x.png"];
    self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
    self.iconView.alpha = 0.0;
    [self.navigationItem.titleView addSubview:self.iconView];

	[NSLayoutConstraint activateConstraints:@[
    	[self.headerImageView.topAnchor constraintEqualToAnchor:self.headerView.topAnchor],
    	[self.headerImageView.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
        [self.headerImageView.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],   
        [self.headerImageView.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
		[self.titleLabel.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
        [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
        [self.iconView.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
        [self.iconView.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
        [self.iconView.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
        [self.iconView.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],

	]];

	 _table.tableHeaderView = self.headerView;
}


-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    CGRect frame = self.table.bounds;
    frame.origin.y = -frame.size.height;

    //self.navigationController.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    [self.navigationController.navigationController.navigationBar setShadowImage: [UIImage new]];
    self.navigationController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

 
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.tableHeaderView = self.headerView;
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;

    if (offsetY > 200) {
        [UIView animateWithDuration:0.2 animations:^{
            self.iconView.alpha = 1.0;
            self.titleLabel.alpha = 0.0;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.iconView.alpha = 0.0;
            self.titleLabel.alpha = 1.0;
        }];
    }

    if (offsetY > 0) offsetY = 0;
    self.headerImageView.frame = CGRectMake(0, offsetY, self.headerView.frame.size.width, 200 - offsetY);
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

	if ([[self traitCollection] userInterfaceStyle] == UIUserInterfaceStyleDark)

    	[self.navigationController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
	else if ([[self traitCollection] userInterfaceStyle] == UIUserInterfaceStyleLight)
		[self.navigationController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];	
}


-(id)readPreferenceValue:(PSSpecifier*)specifier {
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:plistPath]];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];
}


-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
    
    NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    [settings setObject:value forKey:specifier.properties[@"key"]];
    [settings writeToFile:plistPath atomically:YES];
	
	[NSNotificationCenter.defaultCenter postNotificationName:@"changeImage" object:NULL];
	[NSNotificationCenter.defaultCenter postNotificationName:@"changeAlpha" object:NULL];
	[NSNotificationCenter.defaultCenter postNotificationName:@"changeGradient" object:NULL];
	[NSNotificationCenter.defaultCenter postNotificationName:@"changeBlur" object:NULL];

}


-(void)discord {


	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://discord.gg/3ktkSq5ACK"] options:@{} completionHandler:nil];


}


-(void)paypal {


    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://paypal.me/Luki120"] options:@{} completionHandler:nil];


}


-(void)github {


	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/Luki120/April"] options:@{} completionHandler:nil];


}


-(void)arizona {


	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://repo.twickd.com/package/com.twickd.luki120.arizona"] options:@{} completionHandler:nil];


}


-(void)meredith {


	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://parcility.co/package/com.twickd.luki120.meredith"] options:@{} completionHandler:nil];


}


@end




@implementation AprilContributorsRootListController


- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"AprilContributors" target:self];
	}

	return _specifiers;
}


-(void)luki {


	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://twitter.com/Lukii120"] options:@{} completionHandler:nil];


}


-(void)wizard {


	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://twitter.com/runtimeoverflow"] options:@{} completionHandler:nil];


}


-(void)ethn {


	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://twitter.com/ethanwhited"] options:@{} completionHandler:nil];


}


-(void)ben {


	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://twitter.com/BenOwl3"] options:@{} completionHandler:nil];


}


@end




@implementation AprilTableCell


- (void)tintColorDidChange {

	[super tintColorDidChange];

	self.textLabel.textColor = tint;
	self.textLabel.highlightedTextColor = tint;
}


- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {

	[super refreshCellContentsWithSpecifier:specifier];

	if ([self respondsToSelector:@selector(tintColor)]) {
		self.textLabel.textColor = tint;
		self.textLabel.highlightedTextColor = tint;
	}
}


@end