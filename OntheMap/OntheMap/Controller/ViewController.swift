//
//  ViewController.swift
//  OntheMap
//
//  Created by Tony Mackay on 27/04/2020.
//  Copyright © 2020 ViewModel Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        _ = OTMClient.getStudentLocations() { locations, error in
            if let error = error {
                print(error)
            }
            
            OTMModel.studentLocations = locations
            //self.tableView.reloadData()
        }
    }


}

