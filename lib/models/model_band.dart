
class Model_Band{
  String id;
  String name;
  int votes;

  Model_Band({
    required this.id,
    required this.name,
    required this.votes
  });

  factory Model_Band.fromMap(Map<String, dynamic> json)
    => Model_Band(
        id: json.containsKey('id') ? json['id'] : 'no-id',
        name: json.containsKey('name') ? json['name'] : 'no-name',
        votes: json.containsKey('votes') ? json['votes'] : 'no-votes'
    );
}