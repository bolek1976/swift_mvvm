//
//  ViewController.swift
//  MVVM
//
//  Created by Boris Chirino Fernandez on 06/02/2018.
//  Copyright © 2018 SmartSeed. All rights reserved.
//

import UIKit

@objc class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var viewModel : ViewModel!
    var progressBinding : UIBinding!
    
    var _progressVisible : Bool!
    @objc dynamic var progressVisible : Bool  {
        set{
            _progressVisible = newValue
            if (newValue == false) {
                activityIndicator.stopAnimating()
            }else {
                activityIndicator.startAnimating()
            }
        }
        get { return _progressVisible }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        viewModel = ViewModel(restAPI: ItunesAPI())
        viewModel.bind(observedProperty: "isBusy", toProperty: "progressVisible", ofObject: self)
        /*
        progressBinding = UIBinding(observedObject: viewModel,
                                  observedProperty: "isBusy",
                                    observerObject: self,
                                  observerProperty: "progressVisible")
        
        Bindings.add(binding: progressBinding)
        */
        
        viewModel.getApps {
            self.tableView.reloadData()
            let unbindResult = self.viewModel.unbindAll(fromObject: self)
            print("unbind successfully ? ... \(unbindResult)")
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    //MARK: UITableViewDataSource -

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.apps.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "apps_cell", for: indexPath)
        cell.textLabel?.text = viewModel.appTitle(indexPath: indexPath)
        cell.detailTextLabel?.text = viewModel.appCopyright(indexPath: indexPath)
        return cell
    }
}




