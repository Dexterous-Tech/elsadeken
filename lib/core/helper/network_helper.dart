import 'dart:io';
import 'dart:developer';

/// Network connectivity helper utility
class NetworkHelper {
  /// Check if device has internet connectivity
  static Future<bool> hasInternetConnection() async {
    try {
      // Try to connect to a reliable host
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// Check if specific hostname is resolvable
  static Future<bool> canResolveHostname(String hostname) async {
    try {
      final result = await InternetAddress.lookup(hostname);
      return result.isNotEmpty;
    } on SocketException catch (e) {
      log('❌ Cannot resolve hostname $hostname: $e');
      return false;
    }
  }

  /// Test connection to a specific host and port
  static Future<bool> testConnection(String host, int port) async {
    try {
      final socket = await Socket.connect(host, port, timeout: Duration(seconds: 5));
      await socket.close();
      return true;
    } on SocketException catch (e) {
      log('❌ Connection test failed to $host:$port: $e');
      return false;
    }
  }

  /// Get detailed network diagnostics
  static Future<Map<String, dynamic>> getNetworkDiagnostics() async {
    final diagnostics = <String, dynamic>{};
    
    try {
      // Check general internet connectivity
      diagnostics['hasInternet'] = await hasInternetConnection();
      
      // Check Pusher hostname resolution
      diagnostics['canResolvePusher'] = await canResolveHostname('ws-eu.pusherapp.com');
      
      // Check if we can reach Pusher servers
      diagnostics['canReachPusher'] = await testConnection('ws-eu.pusherapp.com', 443);
      
      // Check DNS servers
      try {
        final dnsResult = await InternetAddress.lookup('8.8.8.8');
        diagnostics['dnsWorking'] = dnsResult.isNotEmpty;
      } catch (e) {
        diagnostics['dnsWorking'] = false;
        diagnostics['dnsError'] = e.toString();
      }
      
    } catch (e) {
      diagnostics['error'] = e.toString();
    }
    
    return diagnostics;
  }

  /// Check if the issue is likely DNS-related
  static bool isDNSError(String errorMessage) {
    final dnsErrorPatterns = [
      'Failed host lookup',
      'No address associated with hostname',
      'Name or service not known',
      'nodename nor servname provided',
      'Temporary failure in name resolution'
    ];
    
    return dnsErrorPatterns.any((pattern) => 
      errorMessage.toLowerCase().contains(pattern.toLowerCase())
    );
  }

  /// Get user-friendly error message based on error type
  static String getUserFriendlyErrorMessage(String errorMessage) {
    if (isDNSError(errorMessage)) {
      return 'DNS resolution failed. This usually means:\n'
             '• Your internet connection is down\n'
             '• Your DNS servers are not responding\n'
             '• There\'s a network configuration issue\n\n'
             'Please check your internet connection and try again.';
    } else if (errorMessage.contains('timeout')) {
      return 'Connection timeout. The server is taking too long to respond.\n'
             'This might be due to:\n'
             '• Slow internet connection\n'
             '• Server overload\n'
             '• Network congestion\n\n'
             'Please try again in a moment.';
    } else if (errorMessage.contains('connection refused')) {
      return 'Connection refused. The server is not accepting connections.\n'
             'This might be due to:\n'
             '• Server maintenance\n'
             '• Firewall blocking the connection\n'
             '• Service temporarily unavailable\n\n'
             'Please try again later.';
    } else {
      return 'Network error: $errorMessage\n\n'
             'Please check your internet connection and try again.';
    }
  }
}


