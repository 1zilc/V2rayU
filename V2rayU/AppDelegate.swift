//
//  AppDelegate.swift
//  V2rayU
//
//  Created by yanue on 2018/10/9.
//  Copyright © 2018 yanue. All rights reserved.
//

import Cocoa
import ServiceManagement
import os.log

let launcherAppIdentifier = "net.yanue.V2rayU.Launcher"

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    // bar menu
    @IBOutlet weak var statusMenu: NSMenu!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        os_log("v2rayu init.")
        
        let startedAtLogin = NSWorkspace.shared.runningApplications.contains {
            $0.bundleIdentifier == launcherAppIdentifier
        }
        
        if startedAtLogin {
            DistributedNotificationCenter.default().post(name: Notification.Name("terminateV2rayU"), object: Bundle.main.bundleIdentifier!)
        }

        V2rayLaunch.generateLauchAgentPlist()
        if UserDefaults.getBool(forKey: .v2rayTurnOn) {
            V2rayLaunch.Start()
        }
        
        // auto check updates
        if UserDefaults.getBool(forKey: .autoCheckVersion) {
            // check version
            ShiftyUpdater.checkForUpdatesInBackground()
            // check v2ray core
            V2rayCore().check()
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        V2rayLaunch.Stop()
    }
}


