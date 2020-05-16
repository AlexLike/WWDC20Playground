/* 
    Wave Lab - Wave 3D Page
    Copyright © 2020 Alexander Zank. All rights reserved.
    Available under the MIT license.
*/

import Colors
import Models
import ComponentViews
import ManagedObjects
import Scenes
import SwiftUI

/// A page demonstrating how waves propagate through 3D-space on an oscillator plane.
public struct Wave3DPage: View {
    let wave: Wave
    let xAmount: Int
    let zAmount: Int
    let centerDistance: Float
    let radius: CGFloat

    public init(wave: Wave, xAmount: Int, zAmount: Int, centerDistance: Float, radius: CGFloat) {
        self.wave = wave
        self.xAmount = xAmount
        self.zAmount = zAmount
        self.centerDistance = centerDistance
        self.radius = radius
    }
    
    public var body: some View {
        VStack {
            HStack {
                Header(
                    tag: "Experiment 2",
                    title: "Waves in 3D-Space",
                    description: "Play around with waves in a three dimensional space. Use Augmented Reality to move around the scene freely."
                )
                Spacer()
            }
            .padding([.horizontal, .top])
            Wave3DSceneView(
                wave: wave,
                scene: Wave3DScene(
                    xAmount: xAmount,
                    zAmount: zAmount,
                    centerDistance: centerDistance,
                    radius: radius
                )
            )
            Text("Tap multiple oscillators to force them into a vertical harmonic motion, and observe how all waves interfere.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
            #if canImport(ARKit)
            Button(action: {
                FullscreenPresenter.shared.present(
                    Wave3DARSceneViewController(
                        wave: self.wave,
                        scene: Wave3DARScene(
                            xAmount: self.xAmount,
                            zAmount: self.zAmount,
                            centerDistance: self.centerDistance,
                            radius: self.radius
                        )
                    )
                )
            }) {
                HStack {
                    Image(systemName: "arkit")
                        .imageScale(.large)
                    Text("Experience in AR")
                }
                .font(.system(.headline))
                .foregroundColor(.white)
                .padding()
                .padding(.horizontal)
                .background(Color.accentColor)
                .clipShape(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                )
            }
            #endif
        }
        .padding(.vertical)
        .accentColor(Colors.vividBlue)
    }
}
