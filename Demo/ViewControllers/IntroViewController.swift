//
//  IntroViewController.swift
//  Demo
//
//  Created by Sun hee Bae on 2021/01/22.
//

import UIKit
import SwiftyGif

class IntroViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
        let gif = try UIImage(gifName: "guruphoneintro_edit.gif")
            self.logoImageView.setGifImage(gif, loopCount: 1)
        } catch {
            print(error)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let timer = Timer.scheduledTimer(withTimeInterval: 9, repeats: false) { (timer) in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false, completion: nil)
            }
        }
    }

}
