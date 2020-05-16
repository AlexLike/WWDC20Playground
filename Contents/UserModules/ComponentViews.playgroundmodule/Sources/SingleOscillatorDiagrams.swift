/* 
    Wave Lab - Single Oscillator Diagrams
    Copyright © 2020 Alexander Zank. All rights reserved.
    Available under the MIT license.
*/

import ManagedObjects
import Models
import SwiftUI

/// An interactive diagram for a single oscillator's motion, speed and acceleration.
public struct SingleOscillatorDiagrams: View {
    /// A value indicating which diagram is currently displayed.
    @State private var diagramSelection: DiagramType = .yt
    /// The oscillation to be demoed.
    let oscillation: Oscillation
    /// An object that manages playback.
    @ObservedObject var player: Player
    
    /// Instantiates a view providing an interactive diagram for a single oscillator's motion, speed and acceleration.
    /// - Parameter oscillation: The oscillation to be demoed.
    /// - Parameter player: An object that manages playback.
    public init(oscillation: Oscillation, player: Player) {
        self.oscillation = oscillation
        self.player = player
    }
    
    public var body: some View {
        let parameters = getAppropriateParameters()
        return VStack {
            DiagramPicker(selection: $diagramSelection)
            ZStack {
                Grid(
                    configuration: GridConfiguration(
                        xTitle: "t\n[s]",
                        xMax: CGFloat(oscillation.T),
                        xMin: 0,
                        xStepSize: CGFloat(oscillation.T / 4),
                        yTitle: parameters.yLabel,
                        yMax: parameters.yMax,
                        yMin: -parameters.yMax,
                        yStepSize: parameters.yMax / 4
                    )
                ) { d in
                    
                    SineCurve(φ₀: parameters.φ₀)
                        .stroke(Color.accentColor, lineWidth: 2)
                        .animation(.easeOut)
                        .frame(
                            width: d.translate(x: CGFloat(self.oscillation.T)),
                            height: d.translate(y: parameters.yMax) - d.translate(y: -parameters.yMax)
                    )
                        .position(d.translate(CGPoint(
                            x: self.oscillation.T / 2,
                            y: 0
                        )))
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                        .position(d.translate(CGPoint(
                            x: CGFloat(self.player.time),
                            y: self.getAppropriateY()
                        )))
                }
                .padding()
            }
        }
    }
    
    /// An identity for user-updatable diagram parameters.
    private typealias DiagramParameters = (yLabel: String, φ₀: CGFloat, yMax: CGFloat)
    
    /// A function that returns the correct `DiagramParameters` for the current selection.
    private func getAppropriateParameters() -> DiagramParameters {
        switch diagramSelection {
        case .yt:
            return (
                yLabel: "y\n[cm]",
                φ₀: 0 + CGFloat(oscillation.φ₀),
                yMax: oscillation.ŷ
            )
        case .vt:
            return (
                yLabel: "v\n[cm/s]",
                φ₀: .pi / 2 + CGFloat(oscillation.φ₀),
                yMax: oscillation.v̂
            )
        case .at:
            return (
                yLabel: "a\n[cm/s²]",
                φ₀: .pi + CGFloat(oscillation.φ₀),
                yMax: oscillation.â
            )
        }
    }
    
    /// A function that returns the the diagram pointer's correct y-coordinates for the current selection.
    private func getAppropriateY() -> CGFloat {
        switch diagramSelection {
        case .yt: return oscillation.y(player.time)
        case .vt: return oscillation.v(player.time)
        case .at: return oscillation.a(player.time)
        }
    }
}
