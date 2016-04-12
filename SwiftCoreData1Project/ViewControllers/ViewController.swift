//
//  ViewController.swift
//  SwiftTemplateProject
//
//  Created by Alessandro Perna on 21/03/16.
//  Copyright © 2016 Alessandro Perna. All rights reserved.
//
import UIKit
import SwiftLoader
import Alamofire
import ReachabilitySwift

class ViewController: UIViewController,UIPopoverPresentationControllerDelegate {
    
    
    
    @IBOutlet weak var progressViewCustomers: UIProgressView!
    @IBOutlet weak var progressViewVeichles: UIProgressView!
    @IBOutlet weak var progressViewDownload: UIProgressView!

    @IBOutlet weak var lblCustomers: UILabel!
    @IBOutlet weak var lblVeichles: UILabel!
    @IBOutlet weak var lblDownload: UILabel!

    private var isSync: Bool = false
    private var reachability: Reachability?
    
    var cdn: CoreDataNotification?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        cdn = CoreDataNotification()
    
        //Progress
        
        cdn?.didProgressNotification({ (entities) in
            
            switch entities {
            case .Customers:
                dispatch_async(GlobalQueueAsyncDispatcher.MainQueue, {
                    [unowned self] in
                    
                    let percentage: Float = Float(CoreDataController.sharedInstance.counters.Customers.actual)/Float(CoreDataController.sharedInstance.counters.Customers.total)
                    
                    self.lblCustomers.text = "Customers \(Float(percentage * 100).cleanValue)%"
                    self.progressViewCustomers.progress = percentage
                    
                    })
                break
            case .Veichles:
                dispatch_async(GlobalQueueAsyncDispatcher.MainQueue, {
                    [unowned self] in
                    let percentage: Float = Float(CoreDataController.sharedInstance.counters.Veichles.actual)/Float(CoreDataController.sharedInstance.counters.Veichles.total)
                    
                    self.lblVeichles.text = "Veichles \(Float(percentage * 100).cleanValue)%"
                    self.progressViewVeichles.progress = percentage
                    
                    })
                break
            }
            
        })
        
        NetworkServices.sharedIstance.didProgressNotification("D682B491-1F8C-404D-87D9-3CB9146728E0.MOV", progress: { (percentage) in
            
            dispatch_async(GlobalQueueAsyncDispatcher.MainQueue, {
                [unowned self] in
                
                self.lblDownload.text = "Download \(Float(percentage * 100).cleanValue)%"
                self.progressViewDownload.progress = percentage
                
                })
            
        })
        
        //Fetch
        
        cdn?.didFetchNotification({ (objects) in
            
            if let customers = objects as? [Customers]{
                ColorLog.lightgreen("RESULT >>> Customers count \(customers.count)\n")
            }
            if let veichles = objects as? [Veichles]{
                ColorLog.lightgreen("RESULT >>> Veichles count \(veichles.count)\n")
            }
        })
    

        

        executeConcurrenciesFuncition(2.0)

        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        loaderResume()
    

    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
//        loaderPause()
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {

        coordinator.animateAlongsideTransition({ (context) in
            if self.isSync { SwiftLoader.hide() }
            }) { (context) in
                if self.isSync { SwiftLoader.show(title: "Syncronize...", animated: true) }
        }
        
    }
    

    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                ColorLog.orange("Reachable via WiFi")
            } else {
                ColorLog.orange("Reachable via Cellular")
            }
        } else {
            ColorLog.orange("Network not reachable")
            //loaderEnd()
        }
    }
    
    //MARK: - Popover
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    //MARK: - Private methods
    
    private func setup(){
        
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 150
        config.spinnerLineWidth = 2
        config.titleTextColor = .whiteColor()
        config.spinnerColor = .whiteColor()
        config.foregroundColor = .blackColor()
        config.backgroundColor = .clearColor()
        config.foregroundAlpha = 0.5
        SwiftLoader.setConfig(config)
        

    }
    
    private func loaderBegin(){
        
        dispatch_async(GlobalQueueAsyncDispatcher.MainQueue) {
            
            self.isSync = true
            SwiftLoader.show(title: "Syncronize...", animated: true)
        }
    }
    
    private func loaderEnd(){
        
        dispatch_async(GlobalQueueAsyncDispatcher.MainQueue) {
            
            self.isSync = false
            SwiftLoader.hide()
        }
        
    }
    
    private func loaderPause(){
        if self.isSync {
            dispatch_async(GlobalQueueAsyncDispatcher.MainQueue, {
                SwiftLoader.hide()
            })
        }
    }
    private func loaderResume(){
        
        if self.isSync {
            dispatch_async(GlobalQueueAsyncDispatcher.MainQueue, {
                SwiftLoader.show(title: "Syncronize...", animated: true)
            })
        }
    }
    
    private func executeConcurrenciesFuncition(intervalInSeconds: Double){
    
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(intervalInSeconds * Double(NSEC_PER_SEC)))
        
        dispatch_after(popTime, GlobalQueueAsyncDispatcher.PriorityDefault ) {
            SyncronizeManager.sharedInstance.syncornizedAllServices()
        }
    }

    

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
