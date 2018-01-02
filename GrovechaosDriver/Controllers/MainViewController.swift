//
//  MainViewController.swift
//  GrovechaosDriver
//
//  Created by Hayne Park on 12/12/17.
//  Copyright © 2017 Alexander Bui. All rights reserved.
//

import UIKit
import GoogleMaps

class MainViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet var deliverButton: UIButton!
    
    @IBAction func didPressDeliverButton(_ sender: Any) {
    }
    
    // Timer for Active Drivers
    
    var timer: Timer?
    
    func startTimer() {
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.loop), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func loop() {
        let liveInfoUrl = URL(string: "http://192.168.1.66/api/cloud/app/liveInfo/7777")
        let task = URLSession.shared.dataTask(with: liveInfoUrl! as URL) {data, response, error in
            guard let data = data, error == nil else { return }
            print(String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) ?? "aaaa")
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.bringSubview(toFront: deliverButton)
       
        //Your map initiation code
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:14)
        mapView.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
