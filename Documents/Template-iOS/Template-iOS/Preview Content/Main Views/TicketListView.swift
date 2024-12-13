//
//  TasksView.swift
//  Template-iOS
//
//  Created by TEST on 13.12.2024.
//
import SwiftUI

struct TicketListView: View {
    @State private var tasks: [Task] = []
    @State private var showAddTask = false
    @State private var taskToEdit: Task? = nil
    @State private var errorMessage: String = ""
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color(red: 248/255, green: 247/255, blue: 245/255) // Background color
                    .edgesIgnoringSafeArea(.all) // Fill the screen
                
                // Empty state UI
                if tasks.isEmpty {
                    VStack {
                        Image("emptyState")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .foregroundColor(.white)
                        
                        Text("No Tasks Yet")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(.top, 10)
                        
                        Text("Add your first task to start managing.")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                            .padding(.top, 5)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // List of tasks
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(tasks) { task in
                                VStack {
                                    HStack {
                                        Menu {
                                            Button("Edit") {
                                                taskToEdit = task
                                                showAddTask.toggle()
                                            }
                                            Button(role: .destructive) {
                                                if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                                                    deleteTask(at: IndexSet(integer: index))
                                                }
                                            } label: {
                                                Text("Delete")
                                            }
                                        } label: {
                                            Image(systemName: "ellipsis")
                                                .font(.title2)
                                                .foregroundColor(.white)
                                                .padding(12)
                                                .background(Color.black.opacity(0.6))
                                                .clipShape(Circle())
                                        }

                                        Text(task.title.prefix(20) + (task.title.count > 20 ? "..." : ""))
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .lineLimit(1)

                                        Spacer()

                                        Text("User: \(task.user)")
                                            .font(.subheadline)
                                            .foregroundColor(.black.opacity(0.7))
                                            .fontWeight(.bold)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 75)
                                    .background(Color.blue) // Task card color
                                    .cornerRadius(12)
                                    .shadow(radius: 5)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }

                // Add Task Button
                Button(action: {
                    taskToEdit = nil // Reset for adding a new task
                    showAddTask.toggle()
                }) {
                    Text("Add Task")
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                }
                .shadow(radius: 5)
            }
            .navigationTitle("Tasks")
            .navigationBarTitleDisplayMode(.inline)
            
            .sheet(isPresented: $showAddTask) {
                if let selectedTask = taskToEdit {
                    AddTaskView(onAddTask: { updatedTask in
                        updateTask(task: updatedTask)
                    }, task: selectedTask)
                } else {
                    AddTaskView(onAddTask: { newTask in
                        addTask(task: newTask)
                    })
                }
            }

            .onAppear {
                fetchTasks()
            }
            .alert(isPresented: Binding<Bool>(
                get: { !errorMessage.isEmpty },
                set: { if !$0 { errorMessage = "" }}
            )) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    /* Add & Edit Task Modal */
    struct AddTaskView: View {
        @Environment(\.presentationMode) var presentationMode
        @State private var title: String = ""
        @State private var description: String = ""
        @State private var user: Int = 1
        var onAddTask: (Task) -> Void
        var task: Task?

        var body: some View {
            ZStack {
                Color.blue.edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    Text(task == nil ? "Add Task" : "Edit Task")
                        .font(.largeTitle)
                        .foregroundColor(.white)

                    TextField("Task Title", text: $title)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .foregroundColor(.black)

                    TextField("Task Description", text: $description)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .foregroundColor(.black)


                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss() // Dismiss modal
                        }) {
                            Text("Cancel")
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .shadow(radius: 5)
                        .padding(.trailing)

                        Button(action: {
                            let newTask = Task(id: task?.id ?? 0, title: title, description: description, user: user)
                            onAddTask(newTask) // Trigger the callback
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text(task == nil ? "Add Task" : "Update Task")
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .shadow(radius: 5)
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding()
            }
            .onAppear {
                if let task = task {
                    title = task.title
                    description = task.description
                    user = task.user
                }
            }
        }
    }

    /* Functions for CRUD operations */
    func fetchTasks() {
        guard let token = UserDefaults.standard.string(forKey: "authToken"),
              let url = URL(string: "https://backend-django-9c363a145383.herokuapp.com/api/tasks/") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = error.localizedDescription
                }
                return
            }

            guard let data = data else { return }

            do {
                let fetchedTasks = try JSONDecoder().decode([Task].self, from: data)
                DispatchQueue.main.async {
                    self.tasks = fetchedTasks
                }
            } catch {
                DispatchQueue.main.async {
                    errorMessage = "Failed to decode data."
                }
            }
        }.resume()
    }

    func addTask(task: Task) {
        guard let token = UserDefaults.standard.string(forKey: "authToken"),
              let url = URL(string: "https://backend-django-9c363a145383.herokuapp.com/api/tasks/") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "title": task.title,
            "description": task.description,
            "user": task.user
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = error.localizedDescription
                }
                return
            }

            DispatchQueue.main.async {
                fetchTasks() // Refresh the list after adding
            }
        }.resume()
    }

    func updateTask(task: Task) {
        guard let token = UserDefaults.standard.string(forKey: "authToken"),
              let url = URL(string: "https://backend-django-9c363a145383.herokuapp.com/api/tasks/\(task.id)/") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "title": task.title,
            "description": task.description,
            "user": task.user
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = error.localizedDescription
                }
                return
            }

            DispatchQueue.main.async {
                fetchTasks() // Refresh the list after updating
            }
        }.resume()
    }

    func deleteTask(at indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let task = tasks[index]
        
        guard let token = UserDefaults.standard.string(forKey: "authToken"),
              let url = URL(string: "https://backend-django-9c363a145383.herokuapp.com/api/tasks/\(task.id)/") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = error.localizedDescription
                }
                return
            }

            DispatchQueue.main.async {
                tasks.remove(at: index) // Remove task from list after deletion
            }
        }.resume()
    }
}

struct Task: Identifiable, Codable {
    var id: Int
    var title: String
    var description: String
    var user: Int
}

struct TicketListView_Previews: PreviewProvider {
    static var previews: some View {
        TicketListView()
    }
}
