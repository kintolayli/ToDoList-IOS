//
//  CustomCellViewController.swift
//  ToDoList
//
//  Created by Илья Лотник on 09.02.2024.
//

import UIKit

class CustomCellViewController: UIViewController {
    
    // MARK: - Variables
    
    private let labelIfTodoDoesNotExist: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.isHidden = false
        label.isEnabled = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.text = Constants.TodoDoesNotExistLiteral
        return label
    }()
    
    private var todoElements: [TodoItem] = []
    private let images: [UIImage] = []
    private let logoutImage = UIImage(systemName: "rectangle.portrait.and.arrow.right")
    private let addImage = UIImage(systemName: "plus")
    private var refreshControl: UIRefreshControl!
    
    private let feedbackGeneratorHeavy = UIImpactFeedbackGenerator(style: .heavy)
    private let feedbackGeneratorLight = UIImpactFeedbackGenerator(style: .light)
    
    
    // MARK: - UI Components
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.allowsSelection = true
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
        return tableView
    }()
        
    // MARK: - Lifecycle
    func loadData() {
        guard let request = Endpoint.getAllTodosFromUser().request else { return }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else { return }
            if let todoElement = try? JSONDecoder().decode(UserModel.self, from: data) {
                self.todoElements = todoElement.todos
                self.todoElements.sort(by: >)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("fail")
            }
        }
        task.resume()
    }
    
    func update() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.loadData()
        }
    }
    
    func checkTodoIsEmptyAndShowLabel() {
        if todoElements.isEmpty {
            labelIfTodoDoesNotExist.isHidden = false
            labelIfTodoDoesNotExist.isEnabled = true
        } else {
            labelIfTodoDoesNotExist.isHidden = true
            labelIfTodoDoesNotExist.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.setupRefreshControl()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.update()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
            
        self.view.addSubview(tableView)
        self.view.addSubview(labelIfTodoDoesNotExist)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        self.tableView.addGestureRecognizer(longPressGesture)
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: logoutImage, style: .plain, target: self, action: #selector(didTapLogout)),
            UIBarButtonItem(image: addImage, style: .plain, target: self, action: #selector(didTapAddItem)),
        ]
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        labelIfTodoDoesNotExist.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelIfTodoDoesNotExist.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            labelIfTodoDoesNotExist.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            labelIfTodoDoesNotExist.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            labelIfTodoDoesNotExist.heightAnchor.constraint(equalToConstant: 75),
            
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
}

extension CustomCellViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.checkTodoIsEmptyAndShowLabel()
        return todoElements.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let id = todoElements[indexPath.row].id
            todoElements.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            didTapRemoveItem(at: id)
            
        } else if editingStyle == .insert {
            print("DEBUG PRINT:", "editingStyle == .insert")

        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        DispatchQueue.main.async {
            print()
            let from = self.todoElements[fromIndexPath.row]
            self.todoElements.remove(at: fromIndexPath.row)
            self.todoElements.insert(from, at: to.row)
            
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell else {
            fatalError("The TableView could not dequeue a CustomCell in ViewController.")
        }
        
        let currentItem = todoElements[indexPath.row]
        cell.configure(with: currentItem)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentTodo = todoElements[indexPath.row]
        
        let id = todoElements[indexPath.row].id
        tableView.deselectRow(at: indexPath, animated: true)
        didTapChangeStateItem(at: id, state: !currentTodo.isCompleted)
        self.update()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

    @objc private func didTapLogout() {
        AlertManager.showLogoutConfirmation(on: self) { result in
            if result {
                if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                    TokenManager.shared.deleteDataFromUserDefaults()
                    User.shared.isAccessAllowed = false
                    
                    sceneDelegate.checkAuthentication()
                }
            }
        }
    }
    
    @objc private func didTapAddItem() {
        AlertManager.addNewItemAlert(on: self, titleButton1: Constants.cancelLiteral, titleButton2: Constants.addLiteral, titleAlert: Constants.newRecordLiteral, oldTodoName: "") { strings in
            let newItem = strings[0]
            if newItem != "" {
                let nameItem = AddNewTodoUserRequest(name: newItem)
                guard let request = Endpoint.addNewTodo(userRequest: nameItem).request else { return }
                AuthService.fetch(request: request) { _ in }
            }
            self.update()
        }
    }
    
    @objc private func didTapRemoveItem(at id: Int) {
        guard let request = Endpoint.removeTodo(id: id).request else { return }
        AuthService.fetch(request: request) { _ in }
        self.update()
    }
    
    @objc private func didTapChangeStateItem(at id: Int, state: Bool) {
        
        feedbackGeneratorLight.prepare()
        feedbackGeneratorLight.impactOccurred()
        
        let state = ChangeStateUserRequest(is_completed: state)
        guard let request = Endpoint.changeState(id: id, userRequest: state).request else { return }
        
        AuthService.fetch(request: request) { _ in }
        self.update()
    }
    
    @objc private func didTapEditItem(oldTodoName: String, id: Int) {

        feedbackGeneratorHeavy.prepare()
        feedbackGeneratorHeavy.impactOccurred()
        
        AlertManager.addNewItemAlert(on: self, titleButton1: Constants.cancelLiteral, titleButton2: Constants.saveLiteral, titleAlert: Constants.editRecordLiteral, oldTodoName: oldTodoName) { strings in
            let newItem = strings[0]
            if newItem != "" {
                let nameItem = AddNewTodoUserRequest(name: newItem)
                guard let request = Endpoint.editTodo(id: id, userRequest: nameItem).request else { return }
                AuthService.fetch(request: request) { _ in }
            }
            self.update()
        }
    }
    
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: p)
        if indexPath == nil {
            print("Long press on table view, not row.")
        } else if longPressGesture.state == UIGestureRecognizer.State.began {
            let currentTodo = todoElements[indexPath!.row]
            DispatchQueue.main.async {
                self.didTapEditItem(oldTodoName: currentTodo.name, id: currentTodo.id)
            }
        }
    }
    
    @objc private func handleRefresh(_ sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.loadData()
        }
        sender.endRefreshing()
    }
}
