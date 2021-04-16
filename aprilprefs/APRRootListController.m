#include "APRRootListController.h"




static NSString *plistPath = @"/var/mobile/Library/Preferences/me.luki.aprilprefs.plist";
static BOOL yes;
static BOOL blur;
static BOOL alpha;
float cellAlpha = 1.0f;
float intensity = 1.0f;


#define tint [UIColor colorWithRed: 0.02 green: 0.79 blue: 0.95 alpha: 1.00]


static void postNSNotification() {

	[NSNotificationCenter.defaultCenter postNotificationName:@"changeImage" object:NULL];

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
}


-(void)loadWithoutAFuckingRespring {

	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];
    yes = prefs[@"yes"] ? [prefs[@"yes"] boolValue] : NO;
	blur = prefs[@"blur"] ? [prefs[@"blur"] boolValue] : NO;
	alpha = prefs[@"alphaEnabled"] ? [prefs[@"alphaEnabled"] boolValue] : YES;
	cellAlpha = prefs[@"cellAlpha"] ? [prefs[@"cellAlpha"] floatValue] : 1.0f;
	intensity = prefs[@"intensity"] ? [prefs[@"intensity"] floatValue] : 1.0f;

}


-(id)readPreferenceValue:(PSSpecifier*)specifier {
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:plistPath]];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];
}


-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
    
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:plistPath]];
    [settings setObject:value forKey:specifier.properties[@"key"]];
    [settings writeToFile:plistPath atomically:YES];
    CFStringRef notificationName = (__bridge CFStringRef)specifier.properties[@"PostNotification"];
    if (notificationName) {
        [self loadWithoutAFuckingRespring];
    }
	
	[NSNotificationCenter.defaultCenter postNotificationName:@"changeImage" object:NULL];
	[NSNotificationCenter.defaultCenter postNotificationName:@"changeBlur" object:NULL];
	[NSNotificationCenter.defaultCenter postNotificationName:@"changeAlpha" object:NULL];
}


-(void)discord {


	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://discord.gg/3ktkSq5ACK"] options:@{} completionHandler:nil];


}


-(void)paypal {


    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://paypal.me/Luki120"] options:@{} completionHandler:nil];


}


-(void)github {


	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/Luki120/Arizona"] options:@{} completionHandler:nil];


}


-(void)meredith {


	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://parcility.co/package/com.twickd.luki120.meredith"] options:@{} completionHandler:nil];


}


-(void)perfectSpotify {


	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://parcility.co/package/com.twickd.luki120.perfectspotify/twickd"] options:@{} completionHandler:nil];


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