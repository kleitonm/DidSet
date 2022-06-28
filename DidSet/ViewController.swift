//
//  ViewController.swift
//  DidSet
//
//  Created by Kleiton Mendes on 28/06/22.
//

import UIKit

class Observer <T> {
    
    var value: T? {
        didSet {
            observerBlock?(value)
        }
    }
    
    init(value: T?) {
        self.value = value
    }
    
    private var observerBlock: ((T?) -> Void)?
    
    func add(_ observer: @escaping (T?) -> Void) {
        self.observerBlock = observer
    }
}

class ViewController: UIViewController {
    
    
    private var fruits = Observer(value: ["apple", "orange", "pineaple"])
    
    private let table: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(table)
        table.frame = view.bounds
        table.dataSource = self
        
        fruits.add { [weak self] fruits in
            print("Update fruits: \(fruits ?? [])\n\n")
            DispatchQueue.main.async {
                self?.table.reloadData()
            }
        }
        let more = ["Watermelon", "Cherry", "Peaches", "plum", "raspberry", "banana", "cashew", "cherry", "coconut", "guava", "lemon", "mango", "melon", "papaya", "passion fruit", "strawberry", "pear", "peach", "grape", ""]
        for x in 0..<30 {
        DispatchQueue.main.asyncAfter(deadline: .now()+(2 * TimeInterval(x))) {
            self.fruits.value?.append(more.randomElement() ?? "Something else")
        }
        }
        
//        let custom = CustomLabelView()
//        custom.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
//        custom.center = view.center
//        view.addSubview(custom)
//
//        DispatchQueue.main.asyncAfter(deadline: . now()+5) {
//            custom.score = "32"
//        }
    }


}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fruits.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = fruits.value?[indexPath.row]
        return cell
    }
    
    
}

