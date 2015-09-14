import UIKit
import SwiftyDropbox
import Koloda
import pop

private let frameAnimationSpringBounciness:CGFloat = 9
private let frameAnimationSpringSpeed:CGFloat = 16

class HomeViewController: UIViewController, KolodaViewDataSource, KolodaViewDelegate {
    
    @IBOutlet weak var kolodaView: TrailView!
    @IBOutlet weak var toggleDropboxLink: UIBarButtonItem!
    
    var image: UIImage!

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if verifyDropboxAuthorization() {
            downloadFile()
        }
    }
        
    func showTrails() {
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.alphaValueSemiTransparent = 0.1
        kolodaView.countOfVisibleCards = 2
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        kolodaView.reloadData()
    }
    
    func downloadFile() {
        
        Dropbox.authorizedClient?.filesGetThumbnail(path: "/Camera Uploads/2013-02-22 23.56.21.jpg").response { response, error in
            if let (metadata, data) = response {
                print("Download files name: \(metadata.name)")
                self.image = UIImage(data: data)
                self.showTrails()
            } else {
                print(error!)
            }
        }
        
//        Dropbox.authorizedClient?.filesDownload(path: "/Camera Uploads/2013-02-22 23.56.21.jpg").response{ response, error in
//            if let (metadata, data) = response {
//                print("Dowloaded file name: \(metadata.name)")
//                
//                self.image = UIImage(data: data)
//                self.showTrails()
//            } else {
//                print(error!)
//            }
//        }
    }
    
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.Left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.Right)
    }
    
    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
    }
    
    //MARK: KolodaViewDataSource
    func kolodaNumberOfCards(koloda: KolodaView) -> UInt {
        return 5
    }
    
    func kolodaViewForCardAtIndex(koloda: KolodaView, index: UInt) -> UIView {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .ScaleAspectFit
        return imageView
//        return UIImageView(image: UIImage(named: "cards_\(index + 1)"))
    }
    func kolodaViewForCardOverlayAtIndex(koloda: KolodaView, index: UInt) -> OverlayView? {
        return NSBundle.mainBundle().loadNibNamed("CustomOverlayView",
            owner: self, options: nil)[0] as? OverlayView
    }
    
    //MARK: KolodaViewDelegate
    
    func kolodaDidSwipedCardAtIndex(koloda: KolodaView, index: UInt, direction: SwipeResultDirection) {
    }
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        //Example: reloading
        kolodaView.resetCurrentCardNumber()
    }
    
    func kolodaDidSelectCardAtIndex(koloda: KolodaView, index: UInt) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://yalantis.com/")!)
    }
    
    func kolodaShouldApplyAppearAnimation(koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaShouldTransparentizeNextCard(koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaBackgroundCardAnimation(koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation.springBounciness = frameAnimationSpringBounciness
        animation.springSpeed = frameAnimationSpringSpeed
        return animation
    }
    
    func verifyDropboxAuthorization() ->  Bool {
        if let authorizedClient = Dropbox.authorizedClient {
            
            let dropboxAccessTokens = DropboxAuthManager.sharedAuthManager.getAllAccessTokens().keys

            if dropboxAccessTokens.count > 0 {
                toggleDropboxLink.title = "Unlink from Dropbox"
                
                let userId = dropboxAccessTokens.reverse().first!
                let authToken = DropboxAuthManager.sharedAuthManager.getAccessToken(userId)
                
                Account.instance.registerDropbox(userId, accessToken: authToken!.description)
                authorizedClient.usersGetCurrentAccount().response { response, error in
                    if let account = response {
                        Account.instance.update(account)
                    } else {
                        print(error!)
                    }
                }
                
                return true
            } else {
                Dropbox.unlinkClient()
                sleep(1)
                return verifyDropboxAuthorization()
            }
        }
        toggleDropboxLink.title = "Link with Dropbox"
        return false
    }
    
    @IBAction func didTapDropboxLink(sender: AnyObject) {
        if let _ = Dropbox.authorizedClient {
            Dropbox.unlinkClient()
            verifyDropboxAuthorization()
        } else {
           Dropbox.authorizeFromController(self)
        }
    }
    
    @IBAction func linkButtonPressed(sender: AnyObject) {
        if (Dropbox.authorizedClient == nil) {
            Dropbox.authorizeFromController(self)
        } else {
            print("User is already authorized!")
        }
    }
}