//
//  TaskView.swift
//  MAD_project
//
//  Created by Christian LeMay on 11/15/24.
//

import SwiftUI

struct TodoTask: Identifiable {
    let id = UUID()
    var name: String
    var isCompleted: Bool = false // Default value
}

struct TasksView: View {
    @State private var tasks: [TodoTask] = [
        TodoTask(name: "Buy plates"),
        TodoTask(name: "Pick DJ", isCompleted: true),
        TodoTask(name: "Send Invites")
    ]
    @State private var newTaskName: String = ""
    @State private var isAddingTask: Bool = false
    @State private var newEventName: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.96, green: 0.87, blue: 0.68), Color.brown]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                VStack {
                    HStack {
                        // For text allignment
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        // Title
                        Text("To Do")
                            .font(.system(size: 50, weight: .regular, design: .serif))
                            .italic()
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Button(action: {
                            withAnimation {
                                isAddingTask.toggle()
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.black)
                                .font(.system(size: 35, weight: .bold))
                        }
                    }
                    .padding(.trailing, 10)

                    // If adding a task, show a text box
                    if isAddingTask {
                        VStack {
                            TextField("New Event", text: $newEventName)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                                .foregroundColor(.black)
                                .padding()

                            HStack {
                                Button(action: addEvent) {
                                    Text("Submit")
                                        .font(.headline)
                                        .padding()
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }

                                Button(action: {
                                    withAnimation {
                                        isAddingTask = false
                                    }
                                }) {
                                    Text("Cancel")
                                        .font(.headline)
                                        .padding()
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                            .padding()
                        }
                    }

                    // List of tasks
                    List {
                        ForEach($tasks) { $task in
                            VStack {
                                HStack {
                                    // Task name
                                    Text(task.name)
                                        .font(.system(size: 20, weight: .bold))
                                        .font(.headline)
                                        .strikethrough(task.isCompleted, color: .gray)
                                        .foregroundColor(task.isCompleted ? .gray : .black)

                                    Spacer()

                                    Button(action: {
                                        task.isCompleted.toggle()
                                    }) {
                                        ZStack {
                                            Circle()
                                                .frame(width: 30, height: 30)
                                                .foregroundColor(task.isCompleted ? .green : .white)
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.black, lineWidth: 2)
                                                )

                                            if task.isCompleted {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 18))
                                            }
                                        }
                                    }
                                }

                                Divider()
                                    .background(Color.black)
                                    .frame(height: 1)
                                    .padding(.top, 5)
                            }
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteTask)
                    }
                    .listStyle(.plain)

                    Spacer()
                }
                .padding()
            }
        }
    }

    // Add a new task (event)
    private func addEvent() {
        guard !newEventName.isEmpty else { return }
        let newTask = TodoTask(name: newEventName)
        tasks.append(newTask)
        newEventName = ""
        withAnimation {
            isAddingTask = false
        }
    }

    // Delete a task
    private func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
}

#Preview {
    TasksView()
}
