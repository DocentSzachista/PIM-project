class Document {
  Document(
      {this.id,
      this.uuid,
      required this.name,
      required this.text,
      required this.imageURL});
  String? id;
  String? uuid;
  String name;
  String text;
  final String imageURL;

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
        id: json['id'],
        uuid: json['user_uuid'],
        text: json['text'],
        name: json['name'],
        imageURL: json['image_url']);
  }

  Map<String, dynamic> toJSON() => {
        "id": id,
        "user_uuid": uuid,
        "text": text,
        "name": name,
        "image_url": imageURL
      };
}
