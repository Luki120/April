#include "APRRootListController.h"




static NSString *plistPath = @"/var/mobile/Library/Preferences/me.luki.aprilprefs.plist";
static BOOL yes;




@implementation APRRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
		NSArray *chosenIDs = @[@"Image"];
		self.savedSpecifiers = (self.savedSpecifiers) ?: [[NSMutableDictionary alloc] init];
		for(PSSpecifier *specifier in _specifiers) {
			if([chosenIDs containsObject:[specifier propertyForKey:@"id"]]) {
				[self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];
			}
		}
	}

	return _specifiers;
}


-(void)reloadSpecifiers {

    [super reloadSpecifiers];

    if (![[self readPreferenceValue:[self specifierForID:@"Switch"]] boolValue]) {
        [self removeSpecifier:self.savedSpecifiers[@"Image"] animated:NO];
    } 
    else if (![self containsSpecifier:self.savedSpecifiers[@"Image"]]) {
        [self insertSpecifier:self.savedSpecifiers[@"Image"] afterSpecifierID:@"Switch" animated:NO];
    
    }
}


-(void)viewDidLoad {

	[super viewDidLoad];
	[self reloadSpecifiers];

}


-(void)loadWithoutAFuckingRespring {

	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];
    yes = prefs[@"yes"] ? [prefs[@"yes"] boolValue] : NO;

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

	NSString *key = [specifier propertyForKey:@"key"];

 		if([key isEqualToString:@"yes"]) {
        
        	if (![value boolValue]) {
            [self removeSpecifier:self.savedSpecifiers[@"Image"] animated:YES];
        	} 
        	else if (![self containsSpecifier:self.savedSpecifiers[@"Image"]]) {
            [self insertSpecifier:self.savedSpecifiers[@"Image"] afterSpecifierID:@"Switch" animated:YES];
        	}
   	 	}
	}



@end