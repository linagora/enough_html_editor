import 'package:enough_html_editor/src/utils/webview_asset_base_url.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final baseUrl =
      Uri.parse('file:///var/mobile/Containers/Data/tmp/index.html');

  bool check({
    bool isForMainFrame = true,
    bool? hasGesture = false,
    String? requestScheme = 'file',
    required String? url,
    Uri? baseUrl,
  }) =>
      WebViewAssetBaseUrl.isProgrammaticDocumentLoad(
        isForMainFrame: isForMainFrame,
        hasGesture: hasGesture,
        requestScheme: requestScheme,
        url: url,
        baseUrl: baseUrl,
      );

  test('about:blank is always allowed on main frame', () {
    expect(
      check(url: 'about:blank', baseUrl: baseUrl),
      isTrue,
    );
  });

  test('about:blank on a sub-frame is not allowed', () {
    expect(
      check(isForMainFrame: false, url: 'about:blank', baseUrl: baseUrl),
      isFalse,
    );
  });

  test('exact match against base URL is allowed', () {
    expect(
      check(url: baseUrl.toString(), baseUrl: baseUrl),
      isTrue,
    );
  });

  test('a sub-path of a directory base URL is allowed', () {
    final dirBaseUrl = Uri.parse('file:///var/mobile/Containers/Data/tmp');
    expect(
      check(
        url: 'file:///var/mobile/Containers/Data/tmp/asset.png',
        baseUrl: dirBaseUrl,
      ),
      isTrue,
    );
  });

  test('/private/var/ vs /var/ mismatch is normalized and allowed', () {
    expect(
      check(
        url: 'file:///private/var/mobile/Containers/Data/tmp/index.html',
        baseUrl: baseUrl,
      ),
      isTrue,
    );
  });

  test('trailing slash mismatch is normalized and allowed', () {
    expect(
      check(
        url: '${baseUrl.toString()}/',
        baseUrl: baseUrl,
      ),
      isTrue,
    );
  });

  test('non-file scheme is not allowed even if path matches', () {
    expect(
      check(
        requestScheme: 'https',
        url: 'https:///var/mobile/Containers/Data/tmp/index.html',
        baseUrl: baseUrl,
      ),
      isFalse,
    );
  });

  test('user gesture on a matching path is not allowed', () {
    expect(
      check(
        hasGesture: true,
        url: baseUrl.toString(),
        baseUrl: baseUrl,
      ),
      isFalse,
    );
  });

  test('unrelated path is not allowed', () {
    expect(
      check(
        url: 'file:///var/mobile/Containers/Data/other/index.html',
        baseUrl: baseUrl,
      ),
      isFalse,
    );
  });

  test('non-main-frame navigation is not allowed', () {
    expect(
      check(
        isForMainFrame: false,
        url: baseUrl.toString(),
        baseUrl: baseUrl,
      ),
      isFalse,
    );
  });

  test('null base URL is not allowed', () {
    expect(
      check(url: baseUrl.toString(), baseUrl: null),
      isFalse,
    );
  });

  test('null url is not allowed', () {
    expect(
      check(url: null, baseUrl: baseUrl),
      isFalse,
    );
  });
}
