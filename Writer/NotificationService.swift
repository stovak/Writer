//
//  NotificationService.swift
//  TableRead
//
//  Created by TOM STOVALL on 10/18/18.
//  Copyright © 2018 TOM STOVALL. All rights reserved.
//

import Foundation


class NotificationService {
    
    public static var currentlySpeakingDidChangeNotificationName = Notification.Name(rawValue: "com.stovak.TableRead.currentlySpeakingDidChange");
    public static var volumeSliderDidChangeNotificationName      = Notification.Name(rawValue: "com.stovak.TableRead.volumeDidChange");
    
    public static var currentlySpeakingShouldPlayNotificationName = Notification.Name(rawValue: "com.stovak.TableRead.currentlySpeakingShouldPlay");
    public static var currentlySpeakingShouldPauseNotificationName = Notification.Name(rawValue: "com.stovak.TableRead.currentlySpeakingShouldPause");
    public static var currentlySpeakingShouldStopNotificationName = Notification.Name(rawValue: "com.stovak.TableRead.currentlySpeakingShouldStop");
    public static var currentlySpeakingShouldNextNotificationName = Notification.Name(rawValue: "com.stovak.TableRead.currentlySpeakingShouldNext");
    public static var currentlySpeakingDidStopNotificationName = Notification.Name(rawValue: "com.stovak.TableRead.currentlySpeakingDidStop");
    
    
    
    
    public static var charactersDidChange = Notification.Name(rawValue: "com.stovak.TableRead.charactersDidChange");
    public static var linesDidChange      = Notification.Name(rawValue: "com.stovak.TableRead.linesDidChange");
    public static var actorsDidChange     = Notification.Name(rawValue: "com.stovak.TableRead.actorsDidChange");
    public static var scenesDidChange     = Notification.Name(rawValue: "com.stovak.TableRead.scenesDidChange");

    
}
