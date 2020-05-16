/* 
    Wave Lab - Player
    Copyright © 2020 Alexander Zank. All rights reserved.
    Available under the MIT license.
*/

import Foundation
import QuartzCore
import Combine

/// An `ObservableObject` that tracks time synchronized with the display's refresh rate.
public final class Player: ObservableObject {
    /// The current time tracked by this player.
    @Published public var time: TimeInterval
    /// A value indicating whether time currently progresses.
    @Published private(set) public var isPlaying: Bool = false
    /// The maximum time, after which time will wrap back to zero.
    public let maxTime: TimeInterval
    
    /// Initialize an `ObservableObject` that tracks time synchronized with the display's refresh rate.
    public init(startTime: TimeInterval = 0, maxTime: TimeInterval) {
        self.time = startTime
        self.maxTime = maxTime
    }
    
    /// An object that schedules the updates of `time`.
    lazy var displayLink: CADisplayLink = {
        let _displayLink = CADisplayLink(target: self, selector: #selector(advanceTime))
        _displayLink.isPaused = true
        _displayLink.add(to: .main, forMode: .common)
        return _displayLink
    }()
    
    /// A function that starts, pauses and resumes playback.
    public func toggle() {
        displayLink.isPaused.toggle()
        isPlaying.toggle()
    }
    
    /// A function that pauses playback.
    public func pause() {
        displayLink.isPaused = true
        isPlaying = false
    }
    
    /// A function specifically called by `displayLink` to update `time`.
    @objc private func advanceTime(displayLink: CADisplayLink) {
        time += displayLink.targetTimestamp - displayLink.timestamp
        if time > maxTime { time -= maxTime }
    }
    
    deinit {
        displayLink.invalidate()
    }
    
}
