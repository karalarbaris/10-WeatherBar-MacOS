//
//  AppDelegate.swift
//  10-WeatherBar-MacOS
//
//  Created by Baris Karalar on 17.01.2022.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.button?.title = "Fetching...."
        statusItem.menu = NSMenu()
        addConfigurationMenuItem()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    func addConfigurationMenuItem() {
        let seperator = NSMenuItem(title: "Settings", action: #selector(showSettings), keyEquivalent: "")
        statusItem.menu?.addItem(seperator)
    }
    
    @objc func showSettings(_ sender: NSMenuItem) {
        
    }
}

