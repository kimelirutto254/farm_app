class Crop {
  final int id;
  final String crop;
  final String variety;
  final String age;
  final String population;

  Crop({
    required this.id,
    required this.crop,
    required this.variety,
    required this.age,
    required this.population,
  });

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      id: json['id'],
      crop: json['crop'],
      variety: json['variety'],
      age: json['age'],
      population: json['population'],
    );
  }
}
