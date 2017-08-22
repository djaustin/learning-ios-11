//
//  AddTodoViewController.swift
//  todo-list
//
//  Created by Dan Austin on 22/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit

class AddTodoViewController: UIViewController {

    var todosToAdd = [String]()
    
    @IBOutlet weak var txtTodo: UITextField!
    @IBAction func btnAddWasClicked(_ sender: Any) {
        if let todo = txtTodo.text{
            if !todo.isEmpty{
                todosToAdd.append(todo)
            }
        }
        txtTodo.text = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Requires implementing the UITextFieldDelegate protocol
    // Requires textfield to have this view as its assigned delegate
    // Is called whenever the return key is pressed on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Hide keyboard
        textField.resignFirstResponder()
        // Tell text field to process return with default behaviour
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Preparing for segue")
       saveTodos()
    }
    
    func saveTodos()
    {
        if var savedTodos = UserDefaults.standard.stringArray(forKey: "user_todos"){
            savedTodos.append(contentsOf: todosToAdd)
            UserDefaults.standard.set(savedTodos, forKey: "user_todos")
        } else {
            UserDefaults.standard.set(todosToAdd, forKey: "user_todos")
        }
    }}
