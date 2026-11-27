import 'package:flutter_test/flutter_test.dart';
import 'package:lekra/data/models/body/address_model.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/models/user_model.dart';

void main() {
  group('Saithya Smart Flutter App Unit Tests', () {
    test('UserModel.fromJson parses user profile payload with referral links', () {
      final jsonPayload = {
        'id': 3,
        'first_name': 'Sudhansu',
        'last_name': 'Maharana',
        'name': 'Sudhansu Maharana',
        'email': 'dugun.sudha@gmail.com',
        'mobile': '7008504247',
        'referral_code': 'SSEUPRFF',
        'referred_by_id': 'SSOPRNQM',
        'referred_by_code': 'SSOPRNQM',
        'referralLink': 'https://test.sathiyasmart.com/vendor/register?ref=SSEUPRFF',
        'referral_links': {
          'app': 'https://test.sathiyasmart.com/vendor/register?ref=SSEUPRFF',
          'web': 'https://test.sathiyasmart.com/vendor/register?ref=SSEUPRFF',
          'vendor': 'https://test.sathiyasmart.com/vendor/register?ref=SSEUPRFF',
          'customer': 'https://test.sathiyasmart.com/register?ref=SSEUPRFF',
        },
        'referrer': {
          'id': 1,
          'name': 'Company Root',
          'referral_code': 'SSOPRNQM',
        },
        'dob': '2026-10-28',
        'gender': 'Male',
        'wallet_pin_set': true,
        'wallet_balance': 250.50,
        'current_wallet': 250.50,
        'reward_points': 500,
        'is_verified': 1,
        'is_phone_verified': 1,
      };

      final user = UserModel.fromJson(jsonPayload);

      expect(user.id, 3);
      expect(user.fullName, 'Sudhansu Maharana');
      expect(user.email, 'dugun.sudha@gmail.com');
      expect(user.mobile, '7008504247');
      expect(user.referralCode, 'SSEUPRFF');
      expect(user.referralLink, 'https://test.sathiyasmart.com/vendor/register?ref=SSEUPRFF');
      expect(user.referralLinks?.vendor, 'https://test.sathiyasmart.com/vendor/register?ref=SSEUPRFF');
      expect(user.referralLinks?.customer, 'https://test.sathiyasmart.com/register?ref=SSEUPRFF');
      expect(user.gender, 'Male');
      expect(user.currentWallet, 250.50);
    });

    test('AddressModel parses correctly and formats fullAddress', () {
      final addressJson = {
        'id': 10,
        'user_id': 3,
        'street': 'Flat 402, Royal Residency, MG Road',
        'city': 'Bhubaneswar',
        'state': 'Odisha',
        'pincode': '751001',
      };

      final address = AddressModel.fromJson(addressJson);

      expect(address.id, 10);
      expect(address.street, 'Flat 402, Royal Residency, MG Road');
      expect(address.city, 'Bhubaneswar');
      expect(address.state, 'Odisha');
      expect(address.pincode, '751001');
      expect(
        address.fullAddress,
        'Flat 402, Royal Residency, MG Road Bhubaneswar Odisha, 751001',
      );
    });

    test('ResponseModel encapsulates status and message correctly', () {
      final successResp = ResponseModel(true, 'Profile updated successfully');
      expect(successResp.isSuccess, true);
      expect(successResp.message, 'Profile updated successfully');

      final errResp = ResponseModel(false, 'The email has already been taken.');
      expect(errResp.isSuccess, false);
      expect(errResp.message, 'The email has already been taken.');
    });
  });
}
