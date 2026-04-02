import UIKit
import UserNotifications

class ViewController: UIViewController {

    // MARK: UI
    let statusLabel = UILabel()
    let fpsLabel = UILabel()
    let pingLabel = UILabel()
    let slider = UISlider()

    let startFFButton = UIButton()
    let startFFMaxButton = UIButton()

    let scriptTextView = UITextView()
    let runScriptButton = UIButton()

    // MARK: Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupScriptUI()
        
        requestNotification()
        loadConfig()
        loadScript()
        fakeStatsLoop()
    }

    // MARK: UI Setup
    func setupUI() {
        view.backgroundColor = .black

        statusLabel.frame = CGRect(x: 20, y: 80, width: 320, height: 40)
        statusLabel.textColor = .green
        statusLabel.text = "TUN BOOST VIP"

        fpsLabel.frame = CGRect(x: 20, y: 120, width: 200, height: 30)
        fpsLabel.textColor = .white

        pingLabel.frame = CGRect(x: 20, y: 150, width: 200, height: 30)
        pingLabel.textColor = .white

        slider.frame = CGRect(x: 20, y: 190, width: 280, height: 40)
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.addTarget(self, action: #selector(changeSensitivity), for: .valueChanged)

        startFFButton.frame = CGRect(x: 20, y: 240, width: 150, height: 50)
        startFFButton.setTitle("PLAY FF", for: .normal)
        startFFButton.addTarget(self, action: #selector(startFF), for: .touchUpInside)

        startFFMaxButton.frame = CGRect(x: 180, y: 240, width: 150, height: 50)
        startFFMaxButton.setTitle("PLAY FF MAX", for: .normal)
        startFFMaxButton.addTarget(self, action: #selector(startFFMax), for: .touchUpInside)

        view.addSubview(statusLabel)
        view.addSubview(fpsLabel)
        view.addSubview(pingLabel)
        view.addSubview(slider)
        view.addSubview(startFFButton)
        view.addSubview(startFFMaxButton)
    }

    // MARK: Script UI
    func setupScriptUI() {
        scriptFreeFireMax.frame = CGRect(x: 20, y: 310, width: 310, height: 100)
        scriptFreeFireMax.backgroundColor = .darkGray
        scriptFreeFireMax.textColor = .green
        scriptFreeFireMax.app = "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"

        runScriptButton.frame = CGRect(x: 20, y: 420, width: 200, height: 50)
        runScriptButton.setTitle("RUN SCRIPT", for: .normal)
        runScriptButton.addTarget(self, action: #selector(runScript), for: .touchUpInside)

        view.addSubview(scriptTextView)
        view.addSubview(runScriptButton)
    }

    // MARK: START FF
    @objc func startFF() {
        startGame(scheme: "freefire://")
    }

    @objc func startFFMax() {
        startGame(scheme: "freefiremax://")
    }

    func startGame(scheme: String) {
        boostDevice()
        fakeLoginNotification()
        fakeLoading()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.openGame(scheme: scheme)
        }
    }

    // MARK: Boost
    func boostDevice() {
        URLCache.shared.removeAllCachedResponses()
        UIView.setAnimationsEnabled(false)
        statusLabel.text = "BOOSTING..."
    }

    // MARK: Loading
    func fakeLoading() {
        statusLabel.text = "Injecting script..."
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.statusLabel.text = "Optimizing FPS..."
        }
    }

    // MARK: Open Game
    func openGame(scheme: String) {
        if let url = URL(string: scheme),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            statusLabel.text = "Không mở được game"
        }
    }

    // MARK: Notification
    func requestNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    func fakeLoginNotification() {
        let content = UNMutableNotificationContent()
        content.title = "TUN BOOST"
        content.body = "Đăng nhập thành công - FPS ổn định!"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "login", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    // MARK: Fake Stats
    func fakeStatsLoop() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            let fps = Int.random(in: 55...60)
            let ping = Int.random(in: 10...30)

            self.fpsLabel.text = "FPS: \(fps)"
            self.pingLabel.text = "Ping: \(ping)ms"
        }
    }

    // MARK: Sensitivity
    @objc func changeSensitivity(sender: UISlider) {
        let value = sender.value
        UserDefaults.standard.set(value, forKey: "sensitivity")
        statusLabel.text = "Độ nhạy: \(Int(value))"
    }

    func loadConfig() {
        slider.value = UserDefaults.standard.float(forKey: "sensitivity")
    }

    // MARK: Script Engine
    @objc func runScript() {
        let script = scriptTextView.text ?? ""
        statusLabel.text = "Executing script..."

        if script.contains("FPS=90") {
            fpsLabel.text = "FPS: 90"
        }

        if script.contains("PING=5") {
            pingLabel.text = "Ping: 5ms"
        }

        if script.contains("SENS=100") {
            slider.value = 100
            UserDefaults.standard.set(100, forKey: "sensitivity")
        }

        saveScript()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.statusLabel.text = "Script executed!"
        }
    }

    // MARK: Save / Load Script
    func saveScript() {
        UserDefaults.standard.set(scriptTextView.text, forKey: "custom_script")
    }

    func loadScript() {
        scriptTextView.text = UserDefaults.standard.string(forKey: "custom_script")
    }
}
