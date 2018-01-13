
import UIKit

class CameraViewController: UIViewController {
    
    var nametodisplay = ""
    @IBOutlet weak var myWeb: UIWebView!
    var minPort = 7900
    var maxPort = 8200
    
 
    @IBAction func saveCamera(_ sender: UIBarButtonItem) {
         performSegue(withIdentifier: "gosaved" , sender: self)
    }
    
    var ip_forsave = ""
    var port_forsave : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
 
        var host = nametodisplay
    
        var client: TCPClient?
        
        func sendButtonAction(port: Int) -> String {
            client = TCPClient(address: host, port: Int32(port))
            guard let client = client else { return "Error with client" }
            
            switch client.connect(timeout: 10) {
            case .success:
                print("\(port)-Connected to host \(client.address)")
                if let response = sendRequest(string: "GET / HTTP/1.0\n\n", using: client) {
                    print("Response: \(response)")
                }
                return "Status-Ok"
            case .failure(let error):
                return String(describing: error)
            }
        }
        func sendRequest(string: String, using client: TCPClient) -> String? {
            print("Sending data ... ")
            switch client.send(string: string) {
                case .success:
                    return readResponse(from: client)
                case .failure(let error):
                    print("-\(error)")
                    return nil
            }
        }
        
        func readResponse(from client: TCPClient) -> String? {
            guard let response = client.read(1024*10) else { return nil }
            
            return String(bytes: response, encoding: .utf8)
        }
        
        var min_port = minPort
        let max_port = maxPort
        
        while min_port <= max_port
        {
            if sendButtonAction(port: min_port) == "Status-Ok" {
                    let url = URL(string: "http://\(host):\(min_port)")
                    myWeb.loadRequest(URLRequest(url: url!))
                    ip_forsave = host
                    port_forsave = min_port
                    break
                }
            else if sendButtonAction(port: min_port) == "connectionTimeout" {
                let alert = UIAlertController(title: "Warning", message: "Connection Timeout", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

                self.present(alert, animated: true)
                ip_forsave = host
                port_forsave = min_port
                break
            }
            print(min_port)
            min_port += 1
        }
        if min_port == max_port + 1 {
            let alert = UIAlertController(title: "Warning", message: "Current device has not open ports", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destVC = segue.destination as! SavedCameras
        let port_str : String = "\(port_forsave)"

        destVC.saveCamera(Name: "Saved camera", IP: ip_forsave, Port: port_str)
        
    }


}


