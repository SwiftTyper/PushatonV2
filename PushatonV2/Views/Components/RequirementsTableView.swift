//
//  RequirementsTableView.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 18/12/2024.
//

import Foundation
import SwiftUI

struct RequirementRow: View {
    let requirement: Requirement
    
    var body: some View {
        HStack {
            Text(requirement.name)
                .lineLimit(1)
                .truncationMode(.tail)
                .foregroundStyle(Color.secondary)
            
            Spacer()
            
            Image(systemName: requirement.isMet ? "checkmark" : "xmark")
                .font(.title2)
                .symbolVariant(.circle.fill)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(requirement.isMet ? Color.green.gradient : Color.red.gradient)
                .contentTransition(.symbolEffect(.replace))
                .animation(.easeInOut, value: requirement.isMet)
        }
    }
}

struct RequirementsTableView: View {
    let requirements: [Requirement]
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(requirements) { requirement in
                RequirementRow(requirement: requirement)
            }
        }
        .padding(16)
        .background(Color(UIColor.tertiarySystemFill))
        .cornerRadius(12)
    }
}
