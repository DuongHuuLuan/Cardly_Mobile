class CardDetectionResult {
  final bool detected;
  final double cx;
  final double cy;
  final double width;
  final double height;
  final double angle;
  final double score;

  const CardDetectionResult({
    required this.detected,
    required this.cx,
    required this.cy,
    required this.width,
    required this.height,
    required this.angle,
    required this.score,
  });

  factory CardDetectionResult.fromMap(Map<dynamic, dynamic> map) {
    return CardDetectionResult(
      detected: map['detected'] == true,
      cx: (map['cx'] ?? 0).toDouble(),
      cy: (map['cy'] ?? 0).toDouble(),
      width: (map['width'] ?? 0).toDouble(),
      height: (map['height'] ?? 0).toDouble(),
      angle: (map['angle'] ?? 0).toDouble(),
      score: (map['score'] ?? 0).toDouble(),
    );
  }

  static const empty = CardDetectionResult(
    detected: false,
    cx: 0,
    cy: 0,
    width: 0,
    height: 0,
    angle: 0,
    score: 0,
  );
}