import Foundation

class VideoCacheManager {
    static let shared = VideoCacheManager()
    
    private let fileManager = FileManager.default
    private var activeDownloads: Set<String> = []
    private let lock = NSLock()
    
    private var cacheDirectory: URL? {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first?
            .appendingPathComponent("VideoCache")
    }
    
    private init() {
        createCacheDirectory()
    }
    
    private func createCacheDirectory() {
        guard let cacheDirectory = cacheDirectory else { return }
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }
    
    /// Returns the URL to use for playback - cached if available, otherwise remote
    func getURLToPlay(for remoteURL: URL) -> URL {
        if let cachedURL = getCachedURL(for: remoteURL) {
            DEBUGLOG("✓ Cache HIT: \(remoteURL.lastPathComponent)")
            return cachedURL
        } else {
            DEBUGLOG("✗ Cache MISS: \(remoteURL.lastPathComponent)")
            cacheVideo(from: remoteURL)
            return remoteURL
        }
    }
    
    private func getCachedURL(for url: URL) -> URL? {
        guard let cacheDirectory = cacheDirectory else { return nil }
        let fileName = cacheFileName(for: url)
        let fileURL = cacheDirectory.appendingPathComponent(fileName)
        
        guard fileManager.fileExists(atPath: fileURL.path) else { return nil }
        
        // Verify file is not empty (basic validation)
        if let attributes = try? fileManager.attributesOfItem(atPath: fileURL.path),
           let fileSize = attributes[.size] as? UInt64,
           fileSize > 0 {
            return fileURL
        }
        return nil
    }
    
    private func cacheVideo(from url: URL) {
        let fileName = cacheFileName(for: url)
        
        lock.lock()
        if activeDownloads.contains(fileName) {
            lock.unlock()
            return
        }
        activeDownloads.insert(fileName)
        lock.unlock()
        
        guard let cacheDirectory = cacheDirectory else {
            lock.lock()
            activeDownloads.remove(fileName)
            lock.unlock()
            return
        }
        
        let fileURL = cacheDirectory.appendingPathComponent(fileName)
        
        if fileManager.fileExists(atPath: fileURL.path) {
            lock.lock()
            activeDownloads.remove(fileName)
            lock.unlock()
            return
        }
        
        DEBUGLOG("⬇ Downloading: \(fileName)")
        
        let task = URLSession.shared.downloadTask(with: url) { [weak self] tempURL, response, error in
            guard let self = self else { return }
            
            defer {
                self.lock.lock()
                self.activeDownloads.remove(fileName)
                self.lock.unlock()
            }
            
            guard let tempURL = tempURL, error == nil else {
                DEBUGLOG("❌ Download failed: \(fileName) - \(error?.localizedDescription ?? "Unknown")")
                return
            }
            
            do {
                if self.fileManager.fileExists(atPath: fileURL.path) {
                    try self.fileManager.removeItem(at: fileURL)
                }
                try self.fileManager.moveItem(at: tempURL, to: fileURL)
                DEBUGLOG("✓ Cached: \(fileName)")
            } catch {
                DEBUGLOG("❌ Save failed: \(fileName) - \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    private func cacheFileName(for url: URL) -> String {
        // Use URL hash to create unique filename
        let urlString = url.absoluteString
        return "\(urlString.hash).mp4"
    }
    
    /// Clear all cached videos
    func clearCache() {
        guard let cacheDirectory = cacheDirectory else { return }
        try? fileManager.removeItem(at: cacheDirectory)
        createCacheDirectory()
        DEBUGLOG("🗑 Cache cleared")
    }
    
    /// Get total cache size in bytes
    func getCacheSize() -> UInt64 {
        guard let cacheDirectory = cacheDirectory,
              let enumerator = fileManager.enumerator(at: cacheDirectory, includingPropertiesForKeys: [.fileSizeKey]) else {
            return 0
        }
        
        var totalSize: UInt64 = 0
        for case let fileURL as URL in enumerator {
            if let attributes = try? fileManager.attributesOfItem(atPath: fileURL.path),
               let fileSize = attributes[.size] as? UInt64 {
                totalSize += fileSize
            }
        }
        return totalSize
    }
}
