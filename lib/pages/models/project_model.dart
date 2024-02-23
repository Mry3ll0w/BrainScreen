class Project {
  //Atributos
  String _name; //Nombre del Project
  String _ownerUID; //UID del usuario que lo creo
  String _creationDate;
  String _deletionDate;
  List<String> _members = []; //UID de los usuarios que pertenecen al Project
  //La clave primaria vendra dada por el nombre del Project y el UID del usuario

  Project(String owner, String name)
      : _name = '',
        _ownerUID = '',
        _creationDate = '',
        _deletionDate = '',
        _members = [] {
    //Non empty string checkings
    if (owner.isEmpty) {
      throw Exception('Owner cannot be empty');
    }
    if (name.isEmpty) {
      throw Exception('Name cannot be empty');
    }
    //Set the values
    _name = name;
    _ownerUID = owner;
    _creationDate = DateTime.now().toString();
    _deletionDate = '';
    _members.add(owner);
  }

  //Getters and setters
  String get name => _name;
  String get ownerUID => _ownerUID;
  String get creationDate => _creationDate;
  String get deletionDate => _deletionDate;

  set name(String name) {
    if (name.isEmpty) {
      throw Exception('Name cannot be empty');
    }
    _name = name;
  }

  set ownerUID(String owner) {
    if (owner.isEmpty) {
      throw Exception('Owner cannot be empty');
    }
    _ownerUID = owner;
  }

  set creationDate(String date) {
    if (date.isEmpty) {
      throw Exception('Date cannot be empty');
    }
    _creationDate = date;
  }

  set deletionDate(String date) {
    if (date.isEmpty) {
      throw Exception('Date cannot be empty');
    }
    _deletionDate = date;
  }
}
