/* 
    Wave Lab - Diagram Pickers
    Copyright © 2020 Alexander Zank. All rights reserved.
    Available under the MIT license.
*/

import SwiftUI

enum DiagramType {
    case yt
    case vt
    case at
}

struct DiagramPicker: View {
    /// The current diagram selection.
    @Binding var selection: DiagramType
    
    var body: some View {
        HStack(spacing: 20) {
            Text("Live Diagrams")
                .font(.headline)
            Picker(selection: $selection, label: Text("Select a diagram")) {
                Text("y(t)").tag(DiagramType.yt)
                Text("v(t)").tag(DiagramType.vt)
                Text("a(t)").tag(DiagramType.at)
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}
