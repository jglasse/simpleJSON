//
//  ViewController.swift
//  SimpleJSON
//
//  Created by Jeff Glasse on 8/22/19.
//  Copyright © 2019 Jeff Glasse. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    var employeeList = Employees() // create empty employees
    var vSpinner: UIView?
    
    func processResponse(data: Data?, response: URLResponse?, error: Error?) {
        if error == nil {
            if let jsonDataReceived = data
            {
                print("jsonDataReceived: \(jsonDataReceived)")
                let jasonDedcoder = JSONDecoder()
                jasonDedcoder.keyDecodingStrategy = .convertFromSnakeCase
                do  { self.employeeList = try jasonDedcoder.decode(Employees.self, from: jsonDataReceived)
                    print("decoded! \(self.employeeList)")
                }
                catch {
                    print(error)
                }
                print("success?")
                self.dumbTableView.reloadData()
                
            }
        }
        else {
            print("ERROR!")
            print(error?.localizedDescription)
        }
    }
    
   
    let dumbImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    let dumbTableView = UITableView()
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        
        }
    }
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dumbImageView.center.x = self.view.center.x
        dumbImageView.center.y = dumbImageView.bounds.height/2+14
        dumbImageView.contentMode = .scaleAspectFit
        dumbImageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 240)
        self.dumbImageView.backgroundColor = .black
        self.dumbTableView.frame = CGRect(x: 0, y: dumbImageView.bounds.height+24, width: self.view.bounds.width, height: self.view.bounds.height - dumbImageView.bounds.height+24)
        dumbTableView.dataSource = self
        dumbTableView.delegate = self
        
        showSpinner(onView: dumbTableView)

        self.view.addSubview(dumbImageView)
        self.view.addSubview(dumbTableView)
        if let jsonURL = URL(string: "http://dummy.restapiexample.com/api/v1/employees")
        {
            let jsonTask = URLSession.shared.dataTask(with: jsonURL) {(data, respose, error) in
            if error == nil {
                if let jsonDataReceived = data
                {
                    print("jsonDataReceived: \(jsonDataReceived)")
                    let jasonDedcoder = JSONDecoder()
                    do  { self.employeeList = try jasonDedcoder.decode(Employees.self, from: jsonDataReceived)
                        print("decoded! \(self.employeeList)")
                    }
                    catch {
                        print(error)
                    }
                    print("success?")
                    self.dumbTableView.reloadData()
                    self.removeSpinner()
   
                }
            }
            else {
                print("ERROR!")
                
                }
            }
            jsonTask.resume()

        }
        
        
        if let imageURL = URL(string: "https://solarsystem.nasa.gov/system/stellar_items/image_files/38_saturn_1600x900.jpg")
        { let nTask = URLSession.shared.dataTask(with: imageURL) {(data, respose, error) in
            if error == nil {
                if let dt = data
                {
                    let loadedImage = UIImage(data: dt)
                    DispatchQueue.main.async {
                        self.dumbImageView.image = loadedImage
                    }
                }
            }
            }
            nTask.resume()
        }
   
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  UITableViewCell()
        cell.textLabel?.text = employeeList[indexPath.row].employee_name
        return cell
    }
    
}
