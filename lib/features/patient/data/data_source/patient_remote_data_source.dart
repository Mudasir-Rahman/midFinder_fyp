
import '../patient_model/patient_model.dart';

abstract class PatientRemoteDataSource {
  Future<PatientModel> registerPatient(PatientModel patient);
  Future<PatientModel> updatePatientLocation({
    required String userId,
    required double latitude,
    required double longitude,
  });
  Future<PatientModel> getPatientProfile(String userId);
}