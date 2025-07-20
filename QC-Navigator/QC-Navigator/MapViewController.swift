//
//  ViewController.swift
//  QC-Navigator
//
//  Created by HaseebJaved on 11/12/21.
//

import UIKit
import MapKit

class ViewController: UIViewController, UISearchBarDelegate {

    
    @IBAction func searchBtn(_ sender: Any) {
        let searchController = UISearchController(searchResultsController:  nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
  
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
      
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

