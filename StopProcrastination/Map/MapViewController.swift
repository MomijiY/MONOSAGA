//
//  MapViewController.swift
//  StopProcrastination
//
//  Created by 吉川椛 on 2020/12/05.
//

//  Copyright © 2016年 Misato Morino. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import HCKalmanFilter
 
class MapViewController: UIViewController ,MKMapViewDelegate, CLLocationManagerDelegate{
    
    var locationManager = CLLocationManager()
    var resetKalmanFilter: Bool = false
    var hcKalmanFilter: HCKalmanAlgorithm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        // 画面背景色を設定
        self.view.backgroundColor = UIColor(red:0.7,green:0.7,blue:0.7,alpha:1.0)
    }
    
    // 画面回転にも対応する
    override func viewDidAppear(_ animated: Bool) {
        var topPadding: CGFloat = 0
        var bottomPadding: CGFloat = 0
        var leftPadding: CGFloat = 0
        var rightPadding: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            // 'keyWindow' was deprecated in iOS 13.0: Should not be used for applications
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            topPadding = window!.safeAreaInsets.top
            bottomPadding = window!.safeAreaInsets.bottom
            leftPadding = window!.safeAreaInsets.left
            rightPadding = window!.safeAreaInsets.right
        }
 
        //位置情報サービスの確認
        CLLocationManager.locationServicesEnabled()
 
        // セキュリティ認証のステータス
        let status = CLLocationManager.authorizationStatus()
        
        if(status == CLAuthorizationStatus.notDetermined) {
            print("NotDetermined")
            // 許可をリクエスト
            locationManager.requestWhenInUseAuthorization()
 
        }
        else if(status == CLAuthorizationStatus.restricted){
            print("Restricted")
        }
        else if(status == CLAuthorizationStatus.authorizedWhenInUse){
            print("authorizedWhenInUse")
        }
        else if(status == CLAuthorizationStatus.authorizedAlways){
            print("authorizedAlways")
        }
        else{
            print("not allowed")
        }
 
        // 位置情報の更新
        locationManager.startUpdatingLocation()
        
        // MapViewのインスタンス生成.
        let mapView = MKMapView()
        
        // MapViewをSafeAreaに収める（Portraitのケース）
        // 以降、Landscape のみを想定
        let screenWidth = view.frame.size.width
        let screenHeight = view.frame.size.height
        
        let rect = CGRect(x: leftPadding,
                          y: topPadding,
                          width: screenWidth - leftPadding - rightPadding,
                          height: screenHeight - topPadding - bottomPadding )
        
        mapView.frame = rect
 
        // Delegateを設定.
        mapView.delegate = self
 
        // 縮尺を設定
        var region:MKCoordinateRegion = mapView.region
        region.center = mapView.userLocation.coordinate
        
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        
        mapView.setRegion(region,animated:true)
        // MapViewをViewに追加.
        self.view.addSubview(mapView)
 
        mapView.mapType = MKMapType.hybrid
        
        mapView.userTrackingMode = MKUserTrackingMode.follow
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
 
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("region changed")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let myLocation: CLLocation = locations.first!
        
        if hcKalmanFilter == nil {
           self.hcKalmanFilter = HCKalmanAlgorithm(initialLocation: myLocation)
        }
        else {
            if let hcKalmanFilter = self.hcKalmanFilter {
                if resetKalmanFilter == true {
                    hcKalmanFilter.resetKalman(newStartLocation: myLocation)
                    resetKalmanFilter = false
                }
                else {
                    let kalmanLocation = hcKalmanFilter.processState(currentLocation: myLocation)
                    print(kalmanLocation.coordinate)
                }
            }
        }
    }
}
