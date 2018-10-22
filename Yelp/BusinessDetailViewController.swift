//
//  BusinessDetailViewController.swift
//  Yelp
//
//  Created by Vichet Meng on 10/21/18.
//  Copyright © 2018 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class BusinessDetailViewController: UIViewController {

    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var closedLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var isClosedLabel: UILabel!
    
    var business:Business!
    override func viewDidLoad() {
        super.viewDidLoad()
        businessImageView.setImageWith(business.imageURL!)
        nameLabel.text = business.name
        ratingImageView.image = business.ratingImage
        categoriesLabel.text = business.categories
        reviewCountLabel.text = "\(business.reviewCount!) Reviews"
        addAnnotationAtAddress(address: business.address!, title: business.name!)
        if let isClosed = business.isClosed {
            if isClosed {
                isClosedLabel.text = "Opens Today"
                isClosedLabel.textColor = UIColor.green
            }
        }
    }
    
    func goTo(location:CLLocation) {
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: false)
    }
    func addAnnotationAtAddress(address: String, title: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count != 0 {
                    let coordinate = placemarks.first!.location!
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate.coordinate
                    annotation.title = title
                    self.goTo(location: coordinate)
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
