/// Checks whether a WebView navigation is the WebView's own navigation to
/// its programmatically loaded document, as opposed to a navigation
/// triggered by content inside the loaded document (e.g. a link tap).
class WebViewAssetBaseUrl {
  const WebViewAssetBaseUrl._();

  /// Returns `true` when [url] is the `about:blank` placeholder or the
  /// `loadData` call using [baseUrl], for a main-frame navigation without a
  /// user gesture.
  ///
  /// iOS / WKWebKit can report the navigated `file://` URL with
  /// `/private/var/` instead of `/var/` (symlink resolution differs from how
  /// [baseUrl] was built) or with a mismatched trailing slash, so an exact
  /// string comparison against [baseUrl] is unreliable there. The
  /// [hasGesture] check keeps a user-tapped `file://` link that happens to
  /// share the base URL's path from being auto-allowed.
  static bool isProgrammaticDocumentLoad({
    required bool isForMainFrame,
    required bool? hasGesture,
    required String? requestScheme,
    required String? url,
    required Uri? baseUrl,
  }) {
    if (!isForMainFrame) {
      return false;
    }
    if (url == 'about:blank') {
      return true;
    }

    if (baseUrl == null ||
        url == null ||
        requestScheme != 'file' ||
        hasGesture == true) {
      return false;
    }

    final navigatedUrl = _normalize(url);
    final cachedBaseUrl = _normalize(baseUrl.toString());
    return navigatedUrl == cachedBaseUrl ||
        navigatedUrl.startsWith('$cachedBaseUrl/');
  }

  static String _normalize(String path) => path
      .replaceFirst('file:///private/var/', 'file:///var/')
      .replaceFirst(RegExp(r'/+$'), '');
}
