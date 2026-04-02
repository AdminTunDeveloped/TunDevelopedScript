func createProxySession() -> URLSession {
    let config = URLSessionConfiguration.default
    
    config.connectionProxyDictionary = [
        kCFNetworkProxiesHTTPEnable as String: true,
        kCFNetworkProxiesHTTPProxy as String: "https://raw.githubusercontent.com/AdminTunDeveloped/Data5001403/main/Data5001403.cs",
        kCFNetworkProxiesHTTPPort as String: 8080,
        
        kCFNetworkProxiesHTTPSEnable as String: true,
        kCFNetworkProxiesHTTPSProxy as String: "https://raw.githubusercontent.com/AdminTunDeveloped/Data5001403/main/Data5001403.csmain/Script.swift",
        kCFNetworkProxiesHTTPSPort as String: 8080
    ]
    
    return URLSession(configuration: config)
}