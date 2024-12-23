//
//  ContentView.swift
//  floating_todo
//
//  Created by sarahtxy on 12/22/24.
//

import SwiftUI

struct TodoItem: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var isHighlighted: Bool = false
    let color: Color
    
    static let colors: [Color] = [
        .blue, .green, .orange, .purple, .pink, .red, .yellow, .mint, .teal, .indigo
    ]
}

struct ContentView: View {
    @State private var todoItems: [TodoItem] = []
    @State private var newTaskTitle: String = ""
    
    var body: some View {
        VStack(spacing: 12) {
            // Add task button
            Button(action: addTask) {
                Image(systemName: "plus.app.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.blue)
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal)
            
            // Task boxes
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach($todoItems) { $item in
                        TaskBox(item: $item, onTap: { tappedItem in
                            handleTaskTap(tappedItem)
                        })
                    }
                }
                .padding(.horizontal)
            }
        }
        .frame(minWidth: 300, minHeight: 400)
        .padding(.vertical)
    }
    
    private func addTask() {
        let colorIndex = todoItems.count % TodoItem.colors.count
        let newItem = TodoItem(
            title: "New Task",
            color: TodoItem.colors[colorIndex]
        )
        todoItems.append(newItem)
    }
    
    private func handleTaskTap(_ tappedItem: TodoItem) {
        for index in todoItems.indices {
            if todoItems[index].id == tappedItem.id {
                // Toggle the tapped item
                todoItems[index].isHighlighted.toggle()
            } else {
                // Ensure other items are not highlighted
                todoItems[index].isHighlighted = false
            }
        }
    }
}

struct TaskBox: View {
    @Binding var item: TodoItem
    let onTap: (TodoItem) -> Void
    @State private var isEditing = false
    
    var body: some View {
        TextField("Task", text: Binding(
            get: { item.title },
            set: { item.title = $0 }
        ))
        .font(.system(size: 16))
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(item.color.opacity(item.isHighlighted ? 1.0 : 0.3))
        )
        .foregroundColor(.white)
        .onTapGesture {
            onTap(item)
        }
    }
}

#Preview {
    ContentView()
}
