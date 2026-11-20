final _urls = RegExp(r'(?:https?|socks5)://[^\s\u0022\u0027<>]+');
final _secrets = RegExp(
  r'\b(?:token|password|passwd|secret|key)=([^\s&]+)',
  caseSensitive: false,
);
final _credentials = RegExp(r'\b[^\s@:]+:[^\s@]+@');

String redactLogMessage(String value) {
  final text = value.replaceAllMapped(_urls, (match) {
    final uri = Uri.tryParse(match.group(0)!);
    if (uri == null || uri.host.isEmpty) return '[URL]';
    return '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}';
  });
  return text
      .replaceAll(_secrets, '[redacted]')
      .replaceAll(_credentials, '[credentials]@');
}
