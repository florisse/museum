import 'package:gestion_musee/Dao/MomentDao.dart';
import 'package:gestion_musee/Models/Moment.dart';

class MomentRepository {
  final momentDao = MomentDao();

  Future<List<Moment>> getAllMoment() => momentDao.getMoment();
}
