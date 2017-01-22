//
//  InterfaceController.swift
//  footballTimer WatchKit Extension
//
//  Created by tvolker on 11/23/16.
//  Copyright © 2016 tvolker. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var DisplayTimerOutlet: WKInterfaceTimer!
    @IBOutlet var sixtyButtonOutlet: WKInterfaceButton!
    @IBOutlet var twentyfiveButtonOutlet: WKInterfaceButton!
    @IBOutlet var groupOutlet: WKInterfaceGroup!
    
    var playClockTimer: Timer?
    let playClockDuration: TimeInterval = 25.1
    
    var playClockWarningTimer: Timer?
    let playClockWarningDuration: TimeInterval = 19.7
    
    var timeoutClockTimer: Timer?
    let timeoutClockDuration: TimeInterval = 60.1
    
    var timeoutClockWarningTimer: Timer?
    let timeoutClockWarningDuration: TimeInterval = 44.7
    
    var hapticWarningTimer: Timer?
    var hapticEndingTimer: Timer?
    let hapticDuration: TimeInterval = 0.6
    
    override func willDisappear(){
        super.willDisappear()
        
        print("willDisappear() Fired")

        //super.presentAlert(withTitle: <#T##String?#>, message: <#T##String?#>, preferredStyle: <#T##WKAlertControllerStyle#>, actions: <#T##[WKAlertAction]#>)
    }
    
    override func didAppear() {
        super.didAppear()
        print("didAppear() Fired")
    }
    
    //override func didDeactivate(){
    //   super.didDeactivate()
    //   print("didDeactivate() Fired")
    //}
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
       //startPlayClockTimers()
       //startTimeoutClockTimers()
    }
    
    func startPlayClockTimers(){
        
        timersReset()
        
        //let configuration = HKWorkoutConfiguration()
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .americanFootball
        configuration.locationType = .indoor
        
        do {
            _ = try HKWorkoutSession(configuration: configuration)
            
            //session.delegate = self
            //healthStore.start(session)
            
            let startDate: Date = Date(timeInterval: playClockDuration,since: Date())
            
            DisplayTimerOutlet.setDate(startDate)
            
            playClockWarningTimer = Timer.scheduledTimer(withTimeInterval: playClockWarningDuration, repeats: false) { timer in
                self.DisplayTimerOutlet.setTextColor(UIColor.black)
                self.groupOutlet.setBackgroundColor(UIColor.yellow)
                //WKInterfaceDevice.current().play(.notification)
                self.playHapticWarning()
                print("myWarningTimer Fired")
            }
            
            playClockTimer = Timer.scheduledTimer(withTimeInterval: playClockDuration, repeats: false) { timer in
                self.DisplayTimerOutlet.setTextColor(UIColor.black)
                //WKInterfaceDevice.current().play(.notification)
                self.groupOutlet.setBackgroundColor(UIColor.red)
                self.playHapticEnding()
                print("myFullTimer Fired")
            }
            
            DisplayTimerOutlet.start()
        }
        catch let error as NSError {
            // Perform proper error handling here...
            fatalError("*** Unable to create the workout session: \(error.localizedDescription) ***")
        }
        
        
    }
    
    @IBAction func rightSwipeAction(_ sender: Any) {
        print("Swiped right")
        startPlayClockTimers()
    }
    
    @IBAction func leftSwipeAction(_ sender: Any) {
        print("Swiped left")
        startPlayClockTimers()
    }
    
    @IBAction func downSwipeAction(_ sender: Any) {
        print("Swiped down")
        startTimeoutClockTimers()
    }
    
    @IBAction func upSwipeAction(_ sender: Any) {
        print("Swiped up")
        startTimeoutClockTimers()
    }
    
    
    func startTimeoutClockTimers(){
        
        timersReset()
        
        let startDate: Date = Date(timeInterval: timeoutClockDuration,since: Date())
        
        DisplayTimerOutlet.setDate(startDate)
        
        timeoutClockWarningTimer = Timer.scheduledTimer(withTimeInterval: timeoutClockWarningDuration, repeats: false) { timer in
            self.DisplayTimerOutlet.setTextColor(UIColor.black)
            WKInterfaceDevice.current().play(.notification)
            self.groupOutlet.setBackgroundColor(UIColor.yellow)
            self.playHapticWarning()
            print("myWarningTimer Fired")
        }
        
        timeoutClockTimer = Timer.scheduledTimer(withTimeInterval: timeoutClockDuration, repeats: false) { timer in
            self.DisplayTimerOutlet.setTextColor(UIColor.black)
            WKInterfaceDevice.current().play(.notification)
            self.groupOutlet.setBackgroundColor(UIColor.red)
            self.playHapticEnding()
            print("myFullTimer Fired")
        }
        
        DisplayTimerOutlet.start()
    }
    
    func timersReset(){
        self.DisplayTimerOutlet.setTextColor(UIColor.red)
        self.groupOutlet.setBackgroundColor(UIColor.black)
        
        if playClockTimer != nil {
            playClockTimer?.invalidate()
        }
        
        if playClockWarningTimer != nil {
            playClockWarningTimer?.invalidate()
        }
        
        if timeoutClockTimer != nil {
            timeoutClockTimer?.invalidate()
        }
        
        if timeoutClockWarningTimer != nil {
            timeoutClockWarningTimer?.invalidate()
        }
    }
    
    func playHapticWarning(){
        let timesInt: Int = 1
        var howManyTimesInt: Int = 1
        
        hapticWarningTimer = Timer.scheduledTimer(withTimeInterval: hapticDuration, repeats: true) { timer in
            if howManyTimesInt >= timesInt {
                self.hapticWarningTimer?.invalidate()
            }
            howManyTimesInt += 1
            WKInterfaceDevice.current().play(.retry)
            print("playHapticWarning Fired \(howManyTimesInt)")
        }
    }
    
    func playHapticEnding(){
        let timesInt: Int = 4
        var howManyTimesInt: Int = 1
        
        hapticEndingTimer = Timer.scheduledTimer(withTimeInterval: hapticDuration, repeats: true) { timer in
            if howManyTimesInt >= timesInt {
                self.hapticEndingTimer?.invalidate()
            }
            howManyTimesInt += 1
            WKInterfaceDevice.current().play(.failure)
            print("playHapticEnding Fired \(howManyTimesInt)")
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        //myFullTimer = Timer.scheduledTimer(duration, #selector(timerExpired), false)
        
    }
}
