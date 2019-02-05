//
//  Director.swift
//  TableRead
//
//  Created by Tom Stovall on 10/15/18.
//  Copyright © 2018 TOM STOVALL. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation

class Director: NSObject, AVSpeechSynthesizerDelegate, NSFetchedResultsControllerDelegate {

    var session: AVAudioSession;
    var synth = AVSpeechSynthesizer();
    var stack: [ AVSpeechUtterance ] = [];
    public var currentUtterance: AVSpeechUtterance? = nil;
    var isPaused: Bool = false;
    var scenes: [ NSManagedObjectID ] = [];
    var isStopped: Bool = true;

    
    override init() {

        self.session = AVAudioSession.sharedInstance();
        super.init();
        self.synth.delegate = self;
        let notificationCenter = NotificationCenter.default;

        notificationCenter.addObserver(
            self,
            selector: #selector(self.play),
            name: NotificationService.currentlySpeakingShouldPlayNotificationName,
            object: nil
        );
        notificationCenter.addObserver(
            self,
            selector: #selector(self.pause),
            name: NotificationService.currentlySpeakingShouldPauseNotificationName,
            object: nil
        );
        notificationCenter.addObserver(
            self,
            selector: #selector(self.stop),
            name: NotificationService.currentlySpeakingShouldStopNotificationName,
            object: nil
        );
        notificationCenter.addObserver(
            self,
            selector: #selector(self.next),
            name: NotificationService.currentlySpeakingShouldNextNotificationName,
            object: nil
        );
        
    }
    
    func action() {
        print("action!");
        do {
            self.isStopped = false;
            
            print("STACK ====>");
            dump(self.stack);
            try self.session.setCategory(AVAudioSession.Category.playback,
                                         mode: AVAudioSession.Mode.spokenAudio);
            try self.session.setActive(true);
            self.speakNextLine();
        } catch {
            print(" Error: \"(error)");
        }

    }
    
    func speakNextLine() -> Bool {
        print("Speak next line");
        if ( (self.getNextLine() == true) && self.currentUtterance != nil )  {
            self.speakCurrentUtterance()
        } else {
            self.doneSpeaking();
        }
        return self.synth.isSpeaking;
    }
    
    
    func getNextLine() -> Bool {
        print("getNextLine");
        if (self.stack.count > 0) {
            self.currentUtterance = self.stack.removeFirst();
            return true;
        } else {
            return self.nextScene()
        }
    }
    
    func nextScene() -> Bool {
        if self.scenes.count > 0 {
            return true;
        }
        print("no more scenes");
        return false;
    }
    
    func speakCurrentUtterance() {
        self.synth.speak(self.currentUtterance!);
        var notification = Notification.init(name: NotificationService.currentlySpeakingDidChangeNotificationName);
        notification.object = self.currentUtterance;
        NotificationCenter.default.post(notification);
    }
    
    
    func doneSpeaking() {
        print("Done speaking...???");
        do {
            try self.session.setActive(false);
            self.scenes = [];
        } catch {
            self.handleError(error);
        }
    }

    @objc func play() {
        print("received play notification");
        if (self.isStopped == true) {
            self.action();
        } else {
            if (self.synth.isPaused) {
                self.synth.continueSpeaking();
            } else {
                self.synth.pauseSpeaking(at: AVSpeechBoundary.immediate);
            }
        }
    }
    
    @objc func pause() {
        print("received pause notification");

        self.synth.pauseSpeaking(at: AVSpeechBoundary.immediate);
    }
    
    @objc func stop() {
        print("received stop notification");
        self.isStopped = true;
        self.synth.stopSpeaking(
            at: AVSpeechBoundary.immediate
        );
        self.doneSpeaking();
    }
    
    @objc func next() {
        print("received next notification");
        self.synth.stopSpeaking(at: AVSpeechBoundary.immediate);
    }
    
    func speechSynthesizer(_
        synthesizer: AVSpeechSynthesizer,
        didFinish utterance: AVSpeechUtterance) {
        if (self.isStopped == false) {
            self.speakNextLine();
        } else {
            self.scenes = [];
        }
    }
    
    public func handleError(_ error: Any?) {
        print("Error:!!!!!!!!!!!");
        dump(error);
    }
    
    @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
        print("managedObjectContextObjectsDidChange");
        dump(notification);
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self);
    }

}
