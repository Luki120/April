// Credits for the implementation of the changelog controller:
// https://github.com/nahtedetihw
// https://github.com/nahtedetihw/MusicBackground




#include "APRRootListController.h"
#import <AudioToolbox/AudioServices.h>




static NSString *plistPath = @"/var/mobile/Library/Preferences/me.luki.aprilprefs.plist";


#define tint [UIColor colorWithRed: 1.00 green: 0.55 blue: 0.73 alpha: 1.00]


UIColor *tintDynamicColor;




static void postNSNotification() {


    [NSNotificationCenter.defaultCenter postNotificationName:@"changeImage" object:NULL];
    [NSNotificationCenter.defaultCenter postNotificationName:@"changeGradient" object:NULL];
    [NSNotificationCenter.defaultCenter postNotificationName:@"changeBlur" object:NULL];


}


@implementation APRRootListController


- (NSArray *)specifiers {

    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
        NSArray *chosenIDs = @[@"GroupCell-1", @"Image", @"LightImage", @"SegmentCell", @"BlurValue", @"AlphaValue", @"GroupCell-5", @"AnimateGradientSwitch", @"FirstColor", @"SecondColor", @"GroupCell-6", @"GroupCell-7", @"GradientDirection"];
        self.savedSpecifiers = (self.savedSpecifiers) ?: [[NSMutableDictionary alloc] init];
        for(PSSpecifier *specifier in _specifiers) {
            if([chosenIDs containsObject:[specifier propertyForKey:@"id"]]) {
                [self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];
            }
        }
    }
    return _specifiers;
}


- (void)reloadSpecifiers {

    [super reloadSpecifiers];

    if (![[self readPreferenceValue:[self specifierForID:@"YesSwitch"]] boolValue]) {

        [self removeSpecifier:self.savedSpecifiers[@"GroupCell-1"] animated:NO];
        [self removeSpecifier:self.savedSpecifiers[@"Image"] animated:NO];
        [self removeSpecifier:self.savedSpecifiers[@"LightImage"] animated:NO];

    }


    else if (![self containsSpecifier:self.savedSpecifiers[@"GroupCell-1"]]) {

        [self insertSpecifier:self.savedSpecifiers[@"GroupCell-1"] afterSpecifierID:@"YesSwitch" animated:NO];
        [self insertSpecifier:self.savedSpecifiers[@"Image"] afterSpecifierID:@"GroupCell-1" animated:NO];
        [self insertSpecifier:self.savedSpecifiers[@"LightImage"] afterSpecifierID:@"Image" animated:NO];

    }


    if (![[self readPreferenceValue:[self specifierForID:@"BlurSwitch"]] boolValue]) {

        [self removeSpecifier:self.savedSpecifiers[@"SegmentCell"] animated:NO];
        [self removeSpecifier:self.savedSpecifiers[@"BlurValue"] animated:NO];

    }


    else if (![self containsSpecifier:self.savedSpecifiers[@"SegmentCell"]]) {

        [self insertSpecifier:self.savedSpecifiers[@"SegmentCell"] afterSpecifierID:@"BlurSwitch" animated:NO];
        [self insertSpecifier:self.savedSpecifiers[@"BlurValue"] afterSpecifierID:@"SegmentCell" animated:NO];

    }


    if (![[self readPreferenceValue:[self specifierForID:@"AlphaSwitch"]] boolValue])

        [self removeSpecifier:self.savedSpecifiers[@"AlphaValue"] animated:NO];


    else if (![self containsSpecifier:self.savedSpecifiers[@"AlphaValue"]])

        [self insertSpecifier:self.savedSpecifiers[@"AlphaValue"] afterSpecifierID:@"AlphaSwitch" animated:NO];



    if (![[self readPreferenceValue:[self specifierForID:@"GradientSwitch"]] boolValue])

        [self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-5"], self.savedSpecifiers[@"AnimateGradientSwitch"], self.savedSpecifiers[@"GroupCell-6"], self.savedSpecifiers[@"FirstColor"], self.savedSpecifiers[@"SecondColor"], self.savedSpecifiers[@"GroupCell-7"], self.savedSpecifiers[@"GradientDirection"]] animated:NO];


    else if (![self containsSpecifier:self.savedSpecifiers[@"GroupCell-5"]])

        [self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-5"], self.savedSpecifiers[@"AnimateGradientSwitch"], self.savedSpecifiers[@"GroupCell-6"], self.savedSpecifiers[@"FirstColor"], self.savedSpecifiers[@"SecondColor"], self.savedSpecifiers[@"GroupCell-7"], self.savedSpecifiers[@"GradientDirection"]] afterSpecifierID:@"GradientSwitch" animated:NO];


}


- (void)viewDidLoad {
	
    [super viewDidLoad];
    [self reloadSpecifiers];
	
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)postNSNotification, CFSTR("me.luki.aprilprefs/imageChanged"), NULL, 0);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)postNSNotification, CFSTR("me.luki.aprilprefs/gradientChanged"), NULL, 0);
    
    UIImage *banner = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AprilPrefs.bundle/epicbanner.png"];
	
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,UIScreen.mainScreen.bounds.size.width,UIScreen.mainScreen.bounds.size.width * banner.size.height / banner.size.width)];
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,200,200)];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.image = banner;
    self.headerImageView.translatesAutoresizingMaskIntoConstraints = NO;


    [self.headerView addSubview:self.headerImageView];

    UIButton *changelogButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    changelogButton.frame = CGRectMake(0,0,30,30);
    changelogButton.layer.cornerRadius = changelogButton.frame.size.height / 2;
    changelogButton.layer.masksToBounds = YES;
    [changelogButton setImage:[UIImage systemImageNamed:@"atom"] forState:UIControlStateNormal];
    [changelogButton addTarget:self action:@selector(showWtfChangedInThisVersion:) forControlEvents:UIControlEventTouchUpInside];
    changelogButton.tintColor = [UIColor colorWithRed: 1.00 green: 0.55 blue: 0.73 alpha: 1.00];


    changelogButtonItem = [[UIBarButtonItem alloc] initWithCustomView:changelogButton];

    self.navigationItem.rightBarButtonItem = changelogButtonItem;


    [NSLayoutConstraint activateConstraints:@[

        [self.headerImageView.topAnchor constraintEqualToAnchor:self.headerView.topAnchor],
        [self.headerImageView.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
        [self.headerImageView.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],   
        [self.headerImageView.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],

    ]];

    _table.tableHeaderView = self.headerView;

}


- (void)showWtfChangedInThisVersion:(id)sender {
    
    AudioServicesPlaySystemSound(1521);

    self.changelogController = [[OBWelcomeController alloc] initWithTitle:@"April" detailText:@"1.0.6" icon:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AprilPrefs.bundle/April.png"]];

    [self.changelogController addBulletedListItemWithTitle:@"General" description:@"Fixed a bug in which rotating the device on settings would change the background image despite the interface style being the same (light/dark mode)." image:[UIImage systemImageNamed:@"checkmark.circle.fill"]];

//    [self.changelogController addBulletedListItemWithTitle:@"Prefs" description:@"Added pretty libGC twitter cells for contributors." image:[UIImage systemImageNamed:@"checkmark.circle.fill"]];

    _UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

    _UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithSettings:settings];
    backdropView.layer.masksToBounds = YES;
    backdropView.clipsToBounds = YES;
    backdropView.frame = self.changelogController.viewIfLoaded.frame;
    [self.changelogController.viewIfLoaded insertSubview:backdropView atIndex:0];
    
    backdropView.translatesAutoresizingMaskIntoConstraints = NO;
    [backdropView.bottomAnchor constraintEqualToAnchor:self.changelogController.viewIfLoaded.bottomAnchor].active = YES;
    [backdropView.leftAnchor constraintEqualToAnchor:self.changelogController.viewIfLoaded.leftAnchor].active = YES;
    [backdropView.rightAnchor constraintEqualToAnchor:self.changelogController.viewIfLoaded.rightAnchor].active = YES;
    [backdropView.topAnchor constraintEqualToAnchor:self.changelogController.viewIfLoaded.topAnchor].active = YES;

    self.changelogController.viewIfLoaded.backgroundColor = [UIColor clearColor];
    self.changelogController.view.tintColor = [UIColor colorWithRed: 1.00 green: 0.55 blue: 0.73 alpha: 1.00];
    self.changelogController.modalPresentationStyle = UIModalPresentationPageSheet;
    self.changelogController.modalInPresentation = NO;
    [self presentViewController:self.changelogController animated:YES completion:nil];

}


- (void)dismissVC {

    [self.changelogController dismissViewControllerAnimated:YES completion:nil];

}


- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];

    if ([[self traitCollection] userInterfaceStyle] == UIUserInterfaceStyleDark) [self.navigationController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    else if ([[self traitCollection] userInterfaceStyle] == UIUserInterfaceStyleLight) [self.navigationController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];

}


- (void)viewDidAppear:(BOOL)animated {


    [super viewDidAppear:animated];


    if(!self.navigationItem.titleView) {


        APPAnimatedTitleView *titleView = [[APPAnimatedTitleView alloc] initWithTitle:@"April 1.0.6" minimumScrollOffsetRequired:-68];

        self.navigationItem.titleView = titleView;
        self.titleView.superview.clipsToBounds = YES;


    }

}


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    CGRect frame = self.table.bounds;
    frame.origin.y = -frame.size.height;

    [self.navigationController.navigationController.navigationBar setShadowImage: [UIImage new]];
    self.navigationController.navigationController.navigationBar.tintColor = [UIColor whiteColor];

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat offsetY = scrollView.contentOffset.y;

    if (offsetY > 0) offsetY = 0;
    self.headerImageView.frame = CGRectMake(0, offsetY, self.headerView.frame.size.width, 200 - offsetY);


    if([self.navigationItem.titleView respondsToSelector:@selector(adjustLabelPositionToScrollOffset:)]) {
        [(APPAnimatedTitleView *)self.navigationItem.titleView adjustLabelPositionToScrollOffset:scrollView.contentOffset.y];

    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    tableView.tableHeaderView = self.headerView;
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];

}


- (id)readPreferenceValue:(PSSpecifier*)specifier {

    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:plistPath]];
    return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
    
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:plistPath]];
    [settings setObject:value forKey:specifier.properties[@"key"]];
    [settings writeToFile:plistPath atomically:YES];

    [NSNotificationCenter.defaultCenter postNotificationName:@"changeImage" object:NULL];
    [NSNotificationCenter.defaultCenter postNotificationName:@"changeAlpha" object:NULL];
    [NSNotificationCenter.defaultCenter postNotificationName:@"changeGradient" object:NULL];
    [NSNotificationCenter.defaultCenter postNotificationName:@"changeBlur" object:NULL];


    NSString *key = [specifier propertyForKey:@"key"];

    if([key isEqualToString:@"yes"]) {
        
        if (![value boolValue]) {
            [self removeSpecifier:self.savedSpecifiers[@"GroupCell-1"] animated:YES];
            [self removeSpecifier:self.savedSpecifiers[@"Image"] animated:YES];
            [self removeSpecifier:self.savedSpecifiers[@"LightImage"] animated:NO];
        }

        else if (![self containsSpecifier:self.savedSpecifiers[@"Image"]]) {
            [self insertSpecifier:self.savedSpecifiers[@"GroupCell-1"] afterSpecifierID:@"YesSwitch" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"Image"] afterSpecifierID:@"GroupCell-1" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"LightImage"] afterSpecifierID:@"Image" animated:NO];        
        }

    }


    if([key isEqualToString:@"blur"]) {

        if (![value boolValue]) {
            [self removeSpecifier:self.savedSpecifiers[@"SegmentCell"] animated:YES];
            [self removeSpecifier:self.savedSpecifiers[@"BlurValue"] animated:YES];
        }
        
        else if (![self containsSpecifier:self.savedSpecifiers[@"BlurValue"]]) {
            [self insertSpecifier:self.savedSpecifiers[@"SegmentCell"] afterSpecifierID:@"BlurSwitch" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"BlurValue"] afterSpecifierID:@"SegmentCell" animated:YES];
        }
       
    }

    if([key isEqualToString:@"alphaEnabled"]) {
        
        if (![value boolValue]) {
            [self removeSpecifier:self.savedSpecifiers[@"AlphaValue"] animated:YES];
        }

        else if (![self containsSpecifier:self.savedSpecifiers[@"AlphaValue"]]) {
            [self insertSpecifier:self.savedSpecifiers[@"AlphaValue"] afterSpecifierID:@"AlphaSwitch" animated:YES];
        }

    }

    if([key isEqualToString:@"setGradientAsBackground"]) {
        
        if (![value boolValue]) {
            [self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-5"], self.savedSpecifiers[@"AnimateGradientSwitch"], self.savedSpecifiers[@"GroupCell-6"], self.savedSpecifiers[@"FirstColor"], self.savedSpecifiers[@"SecondColor"], self.savedSpecifiers[@"GroupCell-7"], self.savedSpecifiers[@"GradientDirection"]] animated:YES];
        }

        else if (![self containsSpecifier:self.savedSpecifiers[@"GroupCell-5"]]) {    
            [self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-5"], self.savedSpecifiers[@"AnimateGradientSwitch"], self.savedSpecifiers[@"GroupCell-6"], self.savedSpecifiers[@"FirstColor"], self.savedSpecifiers[@"SecondColor"], self.savedSpecifiers[@"GroupCell-7"], self.savedSpecifiers[@"GradientDirection"]] afterSpecifierID:@"GradientSwitch" animated:YES];
        }

    }

}


@end




@implementation AprilContributorsRootListController


- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"AprilContributors" target:self];
    }

    return _specifiers;
}


@end




@implementation AprilLinksRootListController


- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"AprilLinks" target:self];
    }

    return _specifiers;
}


- (void)discord {


    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://discord.gg/jbE3avwSHs"] options:@{} completionHandler:nil];


}


- (void)paypal {


    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://paypal.me/Luki120"] options:@{} completionHandler:nil];


}


- (void)github {


    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/Luki120/April"] options:@{} completionHandler:nil];


}


- (void)arizona {


    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://repo.twickd.com/get/com.twickd.luki120.arizona"] options:@{} completionHandler:nil];


}


- (void)meredith {


    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://repo.twickd.com/get/com.twickd.luki120.meredith"] options:@{} completionHandler:nil];


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
