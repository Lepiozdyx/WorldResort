//
//  Tool.swift
//  WorldResort
//
//  Created by Alex on 13.04.2025.
//

import Foundation

enum ToolType {
    case food
    case cleaning
    
    var name: String {
        switch self {
        case .food: return "kitchen"
        case .cleaning: return "cleaning"
        }
    }
    
    var image: ImageResource {
        switch self {
        case .food: return .bell
        case .cleaning: return .cleaningBrush
        }
    }
    
    var dragType: DraggableState.DragType {
        switch self {
        case .food: return .bell
        case .cleaning: return .brush
        }
    }
}
