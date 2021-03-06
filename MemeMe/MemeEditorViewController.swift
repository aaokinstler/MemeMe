import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var scrollView: UIScrollView!
        
    let memeTextAttributes: [NSAttributedString.Key: Any]  = [
        .strokeColor: UIColor.black,
        .font: UIFont(name: "Impact", size: 25)!,
        .strokeWidth: -5,
        .foregroundColor: UIColor.white
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextAttributes([topTextField, bottomTextField])
        shareButton.isEnabled = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unsubscribeKeyboardNotifications()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
            shareButton.isEnabled = true
        }
    }
    
    @IBAction func pickImage(_ sender: UIBarItem) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        if sender.tag == 1 {
            pickerController.sourceType = .photoLibrary
        } else {
            pickerController.sourceType = .camera
        }
        present(pickerController, animated: true, completion: nil)
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillDisappear(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func generateMemedImage() -> UIImage {
        changeVisibilityOfToolbars(true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        changeVisibilityOfToolbars(false)
        return memedImage
    }
    
    func changeVisibilityOfToolbars(_ hide: Bool) {
        topToolbar.isHidden = hide
        bottomToolbar.isHidden = hide
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func setTextAttributes(_ textFields: [UITextField]) {
        for textField in textFields {
            textField.defaultTextAttributes = memeTextAttributes
            textField.textAlignment = .center
            textField.delegate = self
        }
        setTextToTextFields()
    }
    
    func setTextToTextFields() {
        bottomTextField.text = "BOTTOM"
        topTextField.text = "TOP"
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imagePickerView
    }
    
    @IBAction func showShareController(_ sender: Any) {
        let memedImage = generateMemedImage()
        let shareController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        shareController.completionWithItemsHandler = {
            _, completed, _, _ in
            if completed {
                let meme = Meme(topText: self.topTextField.text, bottomText: self.bottomTextField.text, originalImage: self.imagePickerView.image,memedImage: memedImage)
                let object = UIApplication.shared.delegate
                let appDelegate = object as! AppDelegate
                appDelegate.memes.append(meme)
                // send post to update views
                NotificationCenter.default.post(name: Notification.Name("AddedImage"), object: nil)
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(shareController, animated: true, completion: nil)
    }
    
    @IBAction func CancellChanges(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

