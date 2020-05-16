/* 
    Wave Lab - Header
    Copyright © 2020 Alexander Zank. All rights reserved.
    Available under the MIT license.
*/

import SwiftUI

/// A standardized header component for consistent looks.
public struct Header: View {
    let tag: String
    let title: String
    let description:  String
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text(tag.uppercased())
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.accentColor)
            Text(title)
                .font(.title)
                .fontWeight(.bold)
            Text(description)
                .padding(.vertical)
        }
    }
    
    public init(tag: String, title: String, description: String) {
        self.tag = tag
        self.title = title
        self.description = description
    }
}
