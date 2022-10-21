class Document {
  Document({this.id, this.uuid, required this.name, required this.text});
  String? id;
  String? uuid;
  String name;
  final String text;

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
        id: json['id'],
        uuid: json['user_uuid'],
        text: json['text'],
        name: json['name']);
  }

  Map<String, dynamic> toJSON() =>
      {"id": id, "user_uuid": uuid, "text": text, "name": name};
}
