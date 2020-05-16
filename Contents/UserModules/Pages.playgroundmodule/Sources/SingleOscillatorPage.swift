/* 
    Wave Lab - Single Oscillator Page
    Copyright © 2020 Alexander Zank. All rights reserved.
    Available under the MIT license.
*/

import Colors
import ComponentViews
import Models
import ManagedObjects
import SwiftUI

/// A page demonstrating how a single harmonic oscillator moves through space in an interactive simulation with real-time diagrams.
public struct SingleOscillatorPage: View {
    /// The oscillation to be demoed.
    public let oscillation: Oscillation
    /// An object that manages playback.
    private let player: Player
    
    /// Initializes a new page view for a given oscillation.
    /// - Parameter oscillation: The oscillation to be demoed.
    public init(oscillation: Oscillation) {
        self.oscillation = oscillation
        self.player = Player(maxTime: oscillation.T)
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Header(
                tag: "Experiment 1",
                title: "Single Oscillator",
                description: "Observe how a single harmonic oscillator moves through space under ideal circumstances."
            )
                .padding(.top)
            SingleOscillatorSimulation(oscillation: oscillation, player: player)
            SingleOscillatorDiagrams(oscillation: oscillation, player: player)
        }
        .padding()
        .accentColor(Colors.vividBlue)
    }
}
