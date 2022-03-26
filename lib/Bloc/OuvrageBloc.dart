import 'dart:async';

import '../Models/Ouvrage.dart';
import '../Repository/OuvrageRepository.dart';

class OuvrageBloc {
  //Get instance of the Repository
  final _ouvrageRepository = OuvrageRepository();

  final _ouvrageController = StreamController<List<Ouvrage>>.broadcast();

  get ouvrage => _ouvrageController.stream;

  OuvrageBloc() {
    getOuvrage();
  }

  Future<List<Ouvrage>> getOuvrage() async {
    _ouvrageController.sink.add(await _ouvrageRepository.getAllOuvrage());
    return _ouvrageRepository.getAllOuvrage();
  }

  addOuvrage(Ouvrage ouvrage) async {
    await _ouvrageRepository.insertOuvrage(ouvrage);
    getOuvrage();
  }

  updateOuvrage(Ouvrage ouvrage) async {
    await _ouvrageRepository.updateOuvrage(ouvrage);
    getOuvrage();
  }

  deleteOuvrage(Ouvrage ouvrage) async {
    _ouvrageRepository.deleteOuvrage(ouvrage);
    getOuvrage();
  }

  Future<bool> getOuvrageFromOtherTables(String code) async {
    return _ouvrageRepository.getOuvrageFromOtherTables(code);
  }

  dispose() {
    _ouvrageController.close();
  }
}
