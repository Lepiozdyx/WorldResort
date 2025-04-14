//
//  DailyTaskView.swift
//  WorldResort
//
//  Created by Alex on 14.04.2025.
//

import SwiftUI

struct DailyTaskView: View {
    @StateObject private var taskManager = DailyTaskManager.shared
    @EnvironmentObject private var gameViewModel: GameViewModel
    
    var body: some View {
        ZStack {
            ActionView(
                name: .greenCapsule,
                text: taskText,
                maxWidth: 300,
                maxHeight: 70
            )
            .opacity(taskManager.currentTask?.isCompleted == true ? 0.5 : 1.0)
            .overlay(alignment: .topTrailing) {
                Text(taskManager.formattedTimeRemaining())
                    .font(.system(size: 12, weight: .bold, design: .default))
                    .foregroundStyle(.white)
                    .padding(5)
                    .background(
                        Capsule()
                            .fill(Color.black.opacity(0.6))
                    )
            }
        }
    }
    
    // Вычисляемое свойство для текста задания
    private var taskText: String {
        guard let task = taskManager.currentTask else {
            return "Daily Task"
        }
        
        if task.isCompleted {
            return "Task completed! +500 coins"
        } else {
            return "\(task.type.rawValue) (\(task.progress)/\(task.type.requirement))"
        }
    }
}

#Preview {
    DailyTaskView()
}
