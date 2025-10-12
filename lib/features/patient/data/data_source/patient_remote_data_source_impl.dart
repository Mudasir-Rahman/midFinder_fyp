import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exception.dart';
import '../patient_model/patient_model.dart';
import 'patient_remote_data_source.dart';

class PatientRemoteDataSourceImpl implements PatientRemoteDataSource {
  final SupabaseClient supabaseClient;

  PatientRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<PatientModel> registerPatient(PatientModel patient) async {
    try {
      final response = await supabaseClient
          .from('patients')
          .insert(patient.toJson())
          .select()
          .single();

      return PatientModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to register patient: $e');
    }
  }

  @override
  Future<PatientModel> updatePatientLocation({
    required String userId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await supabaseClient
          .from('patients')
          .update({
        'latitude': latitude,
        'longitude': longitude,
      })
          .eq('user_id', userId)
          .select()
          .single();

      return PatientModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to update patient location: $e');
    }
  }

  @override
  Future<PatientModel> getPatientProfile(String userId) async {
    try {
      final response = await supabaseClient
          .from('patients')
          .select()
          .eq('user_id', userId)
          .single();

      return PatientModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get patient profile: $e');
    }
  }
}