// A simple model class to hold pet data.
class Pet {
  final String name;
  final String? type;
  final String? breed;
  final String? age;
  final String? imagePath; // Path to the temporary image file.

  Pet({
    required this.name,
    this.type,
    this.breed,
    this.age,
    this.imagePath,
  });
}