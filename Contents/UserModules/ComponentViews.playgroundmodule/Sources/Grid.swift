/* 
    Wave Lab - Grid
    Copyright © 2020 Alexander Zank. All rights reserved.
    Available under the MIT license.
*/

import Models
import SwiftUI

/// A scalable grid that enables drawing easily in the coordinate plain.
struct Grid<Content: View>: View {
    /// This grid's configuration
    let configuration: GridConfiguration
    /// This grid's actual content. Use this closures `GridDrawing` struct and its `translate(:)` functions to aid with coordinate conversion.
    let content: (GridDrawing) -> Content
    
    var body: some View {
        GeometryReader { geo in
            
            Path { p in
                let xScale = geo.size.width / self.configuration.xTotal
                let yScale = geo.size.height / self.configuration.yTotal
                /// The origin of this grid's coordinate system.
                let origin = CGPoint(
                    x: -self.configuration.xMin * xScale,
                    y: self.configuration.yMax * yScale
                )
                // Draw x-Axis
                p.move(to: CGPoint(x: 0, y: origin.y))
                p.addLine(to: CGPoint(x: geo.size.width, y: origin.y))
                p.move(to: CGPoint(x: geo.size.width - 10, y: origin.y -  5))
                p.addLine(to: CGPoint(x: geo.size.width, y: origin.y))
                p.addLine(to: CGPoint(x: geo.size.width - 10, y: origin.y + 5))
                // Draw y-Axis
                p.move(to: CGPoint(x: origin.x, y: 0))
                p.addLine(to: CGPoint(x: origin.x, y: geo.size.height))
                p.move(to: CGPoint(x: origin.x - 5, y: 10))
                p.addLine(to: CGPoint(x: origin.x, y: 0))
                p.addLine(to: CGPoint(x: origin.x + 5, y: 10))
            }
            .stroke(Color.secondary, lineWidth: 1)
            
            Path { p in
                let originalXScale = geo.size.width / self.configuration.xTotal
                let originalYScale = geo.size.height / self.configuration.yTotal
                /// The origin of this grid's coordinate system.
                let origin = CGPoint(
                    x: -self.configuration.xMin*originalXScale,
                    y: self.configuration.yMax*originalYScale
                )
                let xScale = (geo.size.width - geo.size.height * 0.1) / self.configuration.xTotal
                let yScale = (geo.size.height - geo.size.width * 0.1) / self.configuration.yTotal
                var n: Int
                // Draw positive x-Ledgers
                n = Int(self.configuration.xMax / self.configuration.xStepSize)
                if n>0 {
                    for i in 1...n {
                        let thisX = origin.x+CGFloat(i) * self.configuration.xStepSize * xScale
                        p.move(to: CGPoint(x: thisX, y: 0))
                        p.addLine(to: CGPoint(x: thisX, y: geo.size.height))
                    }
                }
                // Draw negative x-Ledgers
                n = Int(-self.configuration.xMin / self.configuration.xStepSize)
                if n>0 {
                    for i in 1...n {
                        let thisX = origin.x - CGFloat(i) * self.configuration.xStepSize * xScale
                        p.move(to: CGPoint(x: thisX, y: 0))
                        p.addLine(to: CGPoint(x: thisX, y: geo.size.height))
                    }
                }
                // Draw positive y-Ledgers
                n = Int(self.configuration.yMax / self.configuration.yStepSize)
                if n>0 {
                    for i in 1...n {
                        let thisY = origin.y-CGFloat(i) * self.configuration.yStepSize * yScale
                        p.move(to: CGPoint(x: 0, y: thisY))
                        p.addLine(to: CGPoint(x: geo.size.width, y: thisY))
                    }
                }
                // Draw negative y-Ledgers
                n = Int(-self.configuration.yMin / self.configuration.yStepSize)
                if n>0 {
                    for i in 1...n {
                        let thisY = origin.y + CGFloat(i) * self.configuration.yStepSize * yScale
                        p.move(to: CGPoint(x: 0, y: thisY))
                        p.addLine(to: CGPoint(x: geo.size.width, y: thisY))
                    }
                }
            }
            .stroke(Color.secondary.opacity(0.2))
            
            ForEach(self.labels(in: geo.size), id: \.id) { label in
                Text(label.text)
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .position(label.position)
            }
            
            self.content(self.drawingConstants(from: geo.size))
        }
        .padding(.top, 25)
        .padding(.horizontal, 20)
    }
    
    /// An identity for a tuple containing information about a label's text and its position in the coordinate plane.
    typealias LabelInformation = (id: UUID, text: String, position: CGPoint)
    
    /// A function that generates information about the grid's labelling.
    /// - Parameter size: The `CGSize` of the drawn coordinate plane.
    /// - Returns: An array of `LabelInformation` that contains every label's text string, position and a unique identifier.
    private func labels(in size: CGSize) -> [LabelInformation] {
        var workingArray = [LabelInformation]()
        let originalXScale = size.width / self.configuration.xTotal
        let originalYScale = size.height / self.configuration.yTotal
        /// The origin of this grid's coordinate system.
        let origin = CGPoint(
            x: -self.configuration.xMin*originalXScale,
            y: self.configuration.yMax*originalYScale
        )
        let xScale = (size.width - size.height * 0.1) / self.configuration.xTotal
        let yScale = (size.height - size.width * 0.1) / self.configuration.yTotal
        var n: Int
        // Compute positive x-Labels
        n = Int(self.configuration.xMax / self.configuration.xStepSize)
        if n>0 {
            for i in 1...n {
                let thisX = origin.x + CGFloat(i) * self.configuration.xStepSize * xScale
                let text = numberString(Double(i) * Double(configuration.xStepSize))
                workingArray.append((UUID(), String(text), CGPoint(x: thisX, y: origin.y + 20)))
            }
        }
        // Compute negative x-Labels
        n = Int(-self.configuration.xMin / self.configuration.xStepSize)
        if n>0 {
            for i in 1...n {
                let thisX = origin.x - CGFloat(i) * self.configuration.xStepSize * xScale
                let text = numberString(-Double(i) * Double(configuration.xStepSize))
                workingArray.append((UUID(), String(text), CGPoint(x: thisX, y: origin.y + 20)))
            }
        }
        // Compute positive y-Labels
        n = Int(self.configuration.yMax / self.configuration.yStepSize)
        if n>0 {
            for i in 1...n {
                let thisY = origin.y - CGFloat(i) * self.configuration.yStepSize * yScale
                let text = numberString(Double(i) * 100 * Double(configuration.yStepSize))
                workingArray.append((UUID(), String(text), CGPoint(x: origin.x - 20, y: thisY)))
            }
        }
        // Compute negative y-Labels
        n = Int(-self.configuration.yMin / self.configuration.yStepSize)
        if n>0 {
            for i in 1...n {
                let thisY = origin.y + CGFloat(i) * self.configuration.yStepSize * yScale
                let text = numberString(-Double(i) * 100 * Double(configuration.yStepSize))
                workingArray.append((UUID(), String(text), CGPoint(x: origin.x - 20, y: thisY)))
            }
        }
        // Add labels for origin and axes
        workingArray.append((UUID(), String(0), CGPoint(x: origin.x - 20, y: origin.y)))
        workingArray.append((UUID(), configuration.yTitle, CGPoint(x: origin.x, y: -25)))
        workingArray.append((UUID(), configuration.xTitle, CGPoint(x: size.width + 20, y: origin.y)))
        
        return workingArray
    }
    
    /// A function that creates a formatted string of a `TimeInterval` with a maximum of 3 significant digits.
    /// - Parameter time: The `TimeInterval` to be formatted.
    func numberString(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.usesSignificantDigits = true
        formatter.maximumSignificantDigits = 3
        return formatter.string(from: NSNumber(value: number))!
    }
    
    /// Generates `DrawingConstants` for this grid's current layout.
    /// - Parameter size: The `CGSize` of the drawn coordinate plane.
    private func drawingConstants(from size: CGSize) -> GridDrawing {
        let originalXScale = size.width / self.configuration.xTotal
        let originalYScale = size.height / self.configuration.yTotal
        return GridDrawing(
            origin: CGPoint(
                x: -self.configuration.xMin * originalXScale,
                y: self.configuration.yMax * originalYScale
            ),
            xScale: (size.width - size.height * 0.1) / self.configuration.xTotal,
            yScale: (size.height - size.width * 0.1) / self.configuration.yTotal
        )
    }
    
    
    /// Creates a Grid based on the given parameters.
    /// - Parameters:
    ///   - configuration: An appropriate `GridConfiguration` object.
    ///   - content: `Views` that are drawn onto the coordinate plane. Use the `GridDrawing` proxy to calculate frame and offset values.
    init(configuration: GridConfiguration, @ViewBuilder content: @escaping (GridDrawing) -> Content) {
        self.configuration = configuration
        self.content = content
    }
}

/// A structure containing useful information about a grid's drawable area and functions that translate sizes and coordinates in the drawing plane to actual point values.
struct GridDrawing {
    /// The translated coordinates of this grid's origin.
    let origin: CGPoint
    /// A factor to scale x-values.
    let xScale: CGFloat
    /// A factor to scale y-values.
    let yScale: CGFloat
    
    /// Translates an x-coordinate in this grid to its actual value in-frame.
    /// - Parameter x: An x-coordinate in this grid's coordinate space.
    func translate(x: CGFloat) -> CGFloat { origin.x + x * xScale }
    
    /// Translates a y-coordinate in this grid to its actual value in-frame.
    /// - Parameter x: A y-coordinate in this grid's coordinate space.
    func translate(y: CGFloat) -> CGFloat { origin.y - y * yScale }
    
    /// Translates a point in this grid to its actual value in-frame.
    /// - Parameter p: A `CGPoint` in this grid's coordinate space.
    func translate(_ p: CGPoint) -> CGPoint {
        CGPoint(x: translate(x: p.x), y: translate(y: p.y))
    }
}
