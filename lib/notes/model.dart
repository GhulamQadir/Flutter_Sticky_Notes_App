class Note {
  String? title;
  String? description;
  String? date;

  Note(this.title, this.description, this.date);

  Note.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = title;
    data['description'] = description;
    data['date'] = date;
    return data;
  }
}
