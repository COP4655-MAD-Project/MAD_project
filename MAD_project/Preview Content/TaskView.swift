//
//  TaskView.swift
//  MAD_project
//
//  Created by Christian LeMay on 11/15/24.
//

import SwiftUI
import FirebaseFirestore

struct TaskItem: Identifiable {
    let id = UUID()
    var name: String
    var isCompleted: Bool = false
}

struct TasksView: View {
    @State private var taskList: [TaskItem] = []
    @State private var isAddingTask: Bool = false
    @State private var newTaskName: String = ""
    
    let currentEventId: String
    @ObservedObject var authManager: AuthManager
    private let db = Firestore.firestore()

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
                            TextField("New Task", text: $newTaskName)
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
                                Button(action: addTask) {
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
                        ForEach($taskList) { $taskItem in
                            VStack {
                                HStack {
                                    Text(taskItem.name)
                                        .font(.system(size: 20, weight: .bold))
                                        .strikethrough(taskItem.isCompleted, color: .gray)
                                        .foregroundColor(taskItem.isCompleted ? .gray : .black)

                                    Spacer()

                                    Button(action: {
                                        taskItem.isCompleted.toggle()
                                        updateTaskCompletion(taskItem)
                                    }) {
                                        ZStack {
                                            Circle()
                                                .frame(width: 30, height: 30)
                                                .foregroundColor(taskItem.isCompleted ? .green : .white)
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.black, lineWidth: 2)
                                                )

                                            if taskItem.isCompleted {
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
        .onAppear(perform: fetchTaskItems)
    }

    // Add a new task
    private func addTask() {
        guard !newTaskName.isEmpty else { return }
        let newTaskItem = TaskItem(name: newTaskName)
        saveTaskToFirestore(newTaskItem)
        newTaskName = ""
        withAnimation {
            isAddingTask = false
        }
    }

    // Save new task to Firestore
    private func saveTaskToFirestore(_ taskItem: TaskItem) {
        let taskRef = db.collection("tasks").document(taskItem.id.uuidString)
        let taskData: [String: Any] = [
            "taskName": taskItem.name,
            "completedBool": taskItem.isCompleted,
            "eventId": currentEventId // Use the passed event ID
        ]
        taskRef.setData(taskData) { error in
            if let error = error {
                print("Error saving task to Firestore: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    taskList.append(taskItem)
                }
            }
        }
    }

    // Fetch task items from Firestore
    private func fetchTaskItems() {
        db.collection("tasks")
            .whereField("eventId", isEqualTo: currentEventId) // Filter by the passed event ID
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching task items: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else { return }
                DispatchQueue.main.async {
                    taskList = documents.compactMap { doc in
                        let data = doc.data()
                        guard
                            let taskName = data["taskName"] as? String,
                            let completedBool = data["completedBool"] as? Bool
                        else {
                            return nil
                        }
                        return TaskItem(name: taskName, isCompleted: completedBool)
                    }
                }
            }
    }


    // Update task completion status
    private func updateTaskCompletion(_ taskItem: TaskItem) {
        let taskRef = db.collection("tasks").document(taskItem.id.uuidString)
        taskRef.updateData(["completedBool": taskItem.isCompleted]) { error in
            if let error = error {
                print("Error updating task completion status: \(error.localizedDescription)")
            }
        }
    }

    // Delete a task item
    private func deleteTask(at offsets: IndexSet) {
        offsets.forEach { index in
            let taskItem = taskList[index]
            let taskRef = db.collection("tasks").document(taskItem.id.uuidString)
            taskRef.delete { error in
                if let error = error {
                    print("Error deleting task item: \(error.localizedDescription)")
                }
            }
        }
        taskList.remove(atOffsets: offsets)
    }
}

#Preview {
    TasksView(currentEventId: "123", authManager: AuthManager())
}

