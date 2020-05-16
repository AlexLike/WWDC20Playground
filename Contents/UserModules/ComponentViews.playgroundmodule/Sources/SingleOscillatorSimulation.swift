/* 
    Wave Lab - Single Oscillator Simulation
    Copyright © 2020 Alexander Zank. All rights reserved.
    Available under the MIT license.
*/

import Models
import ManagedObjects
import SwiftUI

/// A simulation of a single harmonic oscillator.
public struct SingleOscillatorSimulation: View {
    /// The oscillation to be demoed.
    let oscillation: Oscillation
    /// An object that manages playback.
    @ObservedObject var player: Player
    
    /// Instantiates a view providing a simulation of a single harmonic oscillator.
    /// - Parameter oscillation: The oscillation to be demoed.
    /// - Parameter player: An object that manages playback.
    public init(oscillation: Oscillation, player: Player) {
        self.oscillation = oscillation
        self.player = player
    }
    
    public var body: some View {
        HStack {
            HStack(spacing: 30) {
                LabeledArrow(label: "y", orientation: .up)
                    .foregroundColor(.secondary)
                Circle()
                    .fill(Color.accentColor)
                    .frame(width: 30, height: 30)
                    .offset(y: -oscillation.y(player.time) * 5000)
            }
            .padding()
            VStack {
                HStack(spacing: 30) {
                    Button(action: { self.goBackward() }) {
                        Image(systemName: "gobackward.minus")
                            .imageScale(.small)
                    }
                    Button(action: { self.player.toggle() }) {
                        Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                            .imageScale(.medium)
                    }
                    Button(action: { self.goForward() }) {
                        Image(systemName: "goforward.plus")
                            .imageScale(.small)
                    }
                }
                .font(.title)
                .foregroundColor(.primary)
                .padding(.vertical)
                Slider(value: $player.time, in: 0...oscillation.T)
                HStack {
                    Text("0s")
                    Spacer()
                    Text(timeString(from: oscillation.T) + "s")
                }
                .font(.footnote)
                .foregroundColor(.secondary)
            }
            .frame(minHeight: 2 * oscillation.ŷ * 5000)
            .padding()
        }
    }
    
    /// A function that creates a formatted string of a `TimeInterval` with a maximum of 3 significant digits.
    /// - Parameter time: The `TimeInterval` to be formatted.
    func timeString(from time: TimeInterval) -> String {
        let formatter = NumberFormatter()
        formatter.usesSignificantDigits = true
        formatter.maximumSignificantDigits = 3
        return formatter.string(from: NSNumber(value: time))!
    }
    
    /// A function that skips back to the preceding significant point in time.
    private func goBackward() {
        player.pause()
        let significantInterval = oscillation.T/4
        let desiredTime = floor((player.time-1e-12) / significantInterval) * significantInterval
        if desiredTime < 0 { player.time = significantInterval * 3 }
        else { player.time = desiredTime }
    }
    
    /// A function that skips forward to the succeeding significant point in time.
    private func goForward() {
        player.pause()
        let significantInterval = oscillation.T/4
        let desiredTime = ceil((player.time+1e-12) / significantInterval) * significantInterval
        if desiredTime >= oscillation.T { player.time = 0 }
        else { player.time = desiredTime }
    }
}
