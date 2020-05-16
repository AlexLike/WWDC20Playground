/* 
    Wave Lab - Arrows
    Copyright © 2020 Alexander Zank. All rights reserved.
    Available under the MIT license.
*/

import SwiftUI

/// A labeled arrow pointing to a given direction.
struct LabeledArrow: View {
    /// An identity for all directions a `LabeledArrow` can face
    enum Orientation {
        case up, down, left, right
    }
    /// This arrow's labeling.
    let label: String
    /// This arrow's orientation.
    let orientation: Orientation
    
    var body: some View {
        switch orientation {
        case .up, .down:
            return AnyView(
                HStack {
                    Text(label)
                    Arrow()
                        .rotation(Angle(
                            degrees: orientation == .down ? 180 : 0
                        ))
                        .stroke()
                        .frame(width: 10, height: 100)
                }
            )
        case .left, .right:
            return AnyView(
                VStack {
                    Arrow()
                        .rotation(Angle(
                            degrees: orientation == .right ? 90 : 270
                        ))
                        .stroke()
                        .frame(width: 10, height: 100)
                        .frame(width: 100, height: 10)
                    Text(label)
                }
            )
        }
    }
}


/// An arrow shape pointing to the top.
struct Arrow: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Line
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        // Tip
        path.move(to: CGPoint(x: rect.midX - 5, y: rect.minY + 10))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX + 5, y: rect.minY + 10))
        return path
    }
}
