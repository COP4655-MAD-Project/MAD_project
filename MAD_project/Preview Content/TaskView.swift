//
//  TaskView.swift
//  MAD_project
//
//  Created by Christian LeMay on 11/15/24.
//

import SwiftUI
import FirebaseFirestore

struct TodoTask: Identifiable {
    let id: String
    var name: String
    var isCompleted: Bool = false
}

struct TasksView: View {
    @State private var tasks: [TodoTask] = []
    @State private var newTaskName: String = ""
    @State private var isAddingTask: Bool = false
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
                        ForEach($tasks) { $task in
                            VStack {
                                HStack {
                                    Text(task.name)
                                        .font(.system(size: 20, weight: .bold))
                                        .strikethrough(task.isCompleted, color: .gray)
                                        .foregroundColor(task.isCompleted ? .gray : .black)

                                    Spacer()

                                    Button(action: {
                                        task.isCompleted.toggle()
                                        updateTask(task)
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
        .onAppear(perform: fetchTasks)
    }

    // Add a new task
    private func addTask() {
        guard !newTaskName.isEmpty else { return }
        let newTaskID = UUID().uuidString
        let newTask = TodoTask(id: newTaskID, name: newTaskName)
        
        tasks.append(newTask)
        saveTask(newTask)
        newTaskName = ""
        withAnimation {
            isAddingTask = false
        }
    }

    // Save a task to Firestore
    private func saveTask(_ task: TodoTask) {
        db.collection("tasks").document(task.id).setData([
            "name": task.name,
            "isCompleted": task.isCompleted
        ]) { error in
            if let error = error {
                print("Error saving task: \(error.localizedDescription)")
            }
        }
    }

    // Update a task in Firestore
    private func updateTask(_ task: TodoTask) {
        db.collection("tasks").document(task.id).updateData([
            "isCompleted": task.isCompleted
        ]) { error in
            if let error = error {
                print("Error updating task: \(error.localizedDescription)")
            }
        }
    }

    // Fetch tasks from Firestore
    private func fetchTasks() {
        db.collection("tasks").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching tasks: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }
            tasks = documents.map { doc in
                let data = doc.data()
                return TodoTask(
                    id: doc.documentID,
                    name: data["name"] as? String ?? "",
                    isCompleted: data["isCompleted"] as? Bool ?? false
                )
            }
        }
    }

    // Delete a task
    private func deleteTask(at offsets: IndexSet) {
        let idsToDelete = offsets.map { tasks[$0].id }
        idsToDelete.forEach { id in
            db.collection("tasks").document(id).delete { error in
                if let error = error {
                    print("Error deleting task: \(error.localizedDescription)")
                }
            }
        }
        tasks.remove(atOffsets: offsets)
    }
}

#Preview {
    TasksView()
}

