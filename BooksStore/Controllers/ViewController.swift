//
//  ViewController.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 17/10/2021.
//

import UIKit

class ViewController: UIViewController {

    
    //MARK:- Set Variables and Properties
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    var array :[BookModel]?
    
    lazy var fictionViewController:FictionViewController = {
        let storyboard = UIStoryboard(name: "FictionCategory", bundle: Bundle.main)
        let fictionVC = storyboard.instantiateViewController(identifier: "FictionVC") as! FictionViewController
//        self.addChild(fictionVC)
        return fictionVC
       
    }()
    
    lazy var romanceViewController:RomanceViewController = {
        let storyboard = UIStoryboard(name: "RomanceCategory", bundle: Bundle.main)
        let romanceVC = storyboard.instantiateViewController(identifier: Constants.romanceCategoryID) as! RomanceViewController
//        self.addChild(romanceVC)
        return romanceVC
    }()
    
    lazy var sci_Fi_ViewController:Sci_FiViewController = {
        let storyboard = UIStoryboard(name: "Sci-FiCategory", bundle: Bundle.main)
        let sci_Fi_VC = storyboard.instantiateViewController(identifier: Constants.sci_FiCategoryID) as! Sci_FiViewController
//        self.addChild(sci_Fi_VC)
        return sci_Fi_VC
    }()
    
    lazy var crimeViewController:CrimeViewController = {
        let storyboard = UIStoryboard(name: "CrimeCategory", bundle: Bundle.main)
        let crimeVC = storyboard.instantiateViewController(identifier: Constants.crimeCategoryID) as! CrimeViewController
//        self.addChild(crimeVC)
        return crimeVC
    }()
    
    
    //MARK:- View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // just for test networking layer
        NetworkService.shared.fetchBooks(route: .FictionBooks, method: .get) { result in
         
            switch result {
            
            case .success(let data):
                self.array = data
                print(self.array)
            case .failure(let error):
                print(error)
            }
        }
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        didSegmentChanged(self.segmentedControl)
    }
    
    
    
    //MARK:- Methods
    @IBAction func didSegmentChanged(_ sender: UISegmentedControl) {
        
        
        switch sender.selectedSegmentIndex {
        
        case 0:
            
            switchChildViewControllers(fictionViewController)
            
        case 1:
           
            switchChildViewControllers(romanceViewController)
            
        case 2:
            
            switchChildViewControllers(sci_Fi_ViewController)
            
        case 3:
            
            switchChildViewControllers(crimeViewController)
            
        default:
            
            switchChildViewControllers(fictionViewController)
        }
    }
    
    
    
    
    func switchChildViewControllers(_ childVC : UIViewController) {
        
        // Add it as a child view controller of this one
        addChild(childVC)
        
        // Add it's view as a subview of container view
        containerView.addSubview(childVC.view)
        
        // Set it's frame and sizing
        childVC.view.frame = containerView.bounds
        childVC.view.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        
        // Indicate that it's now a child view controller
        childVC.didMove(toParent: self)
    }
        
    }


//AIzaSyAnPJB32xH9U1CKylidXNPfj0s3Ge-UGos
//https://www.googleapis.com/books/v1/volumes?q=technology+subject&key=AIzaSyAnPJB32xH9U1CKylidXNPfj0s3Ge-UGos&filter=free-ebooks&printType=books
//https://www.googleapis.com/books/v1/volumes/zyTCAlFPjgYC?key=AIzaSyAnPJB32xH9U1CKylidXNPfj0s3Ge-UGos

