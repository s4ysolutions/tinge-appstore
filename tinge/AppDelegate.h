//
//  AppDelegate.h
//  tinge
//
//  Created by  Sergey Dolin on 07/10/2019.
//  Copyright © 2019  Sergey Dolin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ScreenshotDelegator.h"

@interface AppDelegate : NSObject <NSApplicationDelegate,ScreenshotDelegator> {
    

    NSStatusItem * _statusItem;
    NSMenu* _statusMenu;
}

@property (assign) IBOutlet NSMenu *statusMenu;

-(void) interrogateHardware;
-(void) disableUI;
-(void) enableUI;
-(int) currentDisplay;

-(IBAction)makeScreenShot:(id)sender;
-(IBAction)toggleDropboxLink:(id)sender;
-(IBAction)toggleRunOnStartup:(id)sender;

@end
