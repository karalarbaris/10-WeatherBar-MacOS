//
//  AppDelegate.swift
//  10-WeatherBar-MacOS
//
//  Created by Baris Karalar on 17.01.2022.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var feed: JSON?
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.button?.title = "Fetching...."
        statusItem.menu = NSMenu()
        addConfigurationMenuItem()
        
        loadSettings()
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
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        guard let vc = storyboard.instantiateController(withIdentifier: "ViewController") as? ViewController else { return }
        
        let popoverView = NSPopover()
        popoverView.contentViewController = vc
        popoverView.behavior = .transient
        popoverView.show(relativeTo: statusItem.button!.bounds, of: statusItem.button!, preferredEdge: .maxY)
        
        
    }
    
    @objc func fetchFeed() {
        
        let defaults = UserDefaults.standard
        
        guard var apiKey = defaults.string(forKey: "apiKey") else { return }
        apiKey = "d2ba5dfb7d4821a8e14a3fc0b41625f4"
        if apiKey == "" {
            statusItem.button?.title = "No api key"
            return
        }
        
        DispatchQueue.global(qos: .utility).async { [unowned self] in
            
            let latitude = defaults.double(forKey: "latitude")
            let longitude = defaults.double(forKey: "longitude")
            
            var dataSource = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
            
            if defaults.integer(forKey: "units") == 0 {
               dataSource += "&units=metric"
            }
            
            guard let url = URL(string: dataSource) else { return }
            
            guard let data = try? String(contentsOf: url) else {
                DispatchQueue.main.async { [unowned self] in
                    statusItem.button?.title = "Bad API call"
                }
                return
            }
            
            let newFeed = JSON(parseJSON: data)
            DispatchQueue.main.async {
                self.feed = newFeed
            }
        }
        
    }
    
    @objc func loadSettings() {
        fetchFeed()
    }
    
}

