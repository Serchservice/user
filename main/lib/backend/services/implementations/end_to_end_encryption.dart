import 'package:secure_flutter/secure_flutter.dart';
import 'package:user/library.dart';

class EndToEndEncryption implements EndToEndEncryptionService {
  final SecureMessagingService _service = SecureMessaging();

  @override
  void generateKeyPair(String password, {bool shouldSendUpdateToServer = false}) async {
    try {
      SecureKeyResponse response = _service.generate(password);
      Database.saveE2EE(Database.e2ee.copyWith(privateKey: response.privateKey, publicKey: response.publicKey));

      if(shouldSendUpdateToServer) {
        sendPublicKeyToServer(response.publicKey);
      }
    } catch (e) {
      Logger.log(e, from: "Key Pair Generation");
    }
  }

  @override
  String encrypt({required String message, required String recipientPublicKey}) {
    try {
      return _service.encrypt(message: message, publicKey: recipientPublicKey);
    } catch (e) {
      Logger.log(from: "Encrypt E2EE", e);
      return "";
    }
  }

  @override
  String decrypt(String message) {
    try {
      return _service.decrypt(message: message, privateKey: Database.e2ee.privateKey);
    } catch (e) {
      Logger.log(from: "Decrypt E2EE", e);
      return "";
    }
  }

  @override
  void sendPublicKeyToServer(String key) async {
    ConnectService connect = Connect();

    if(key.isNotEmpty) {
      await connect.patch(endpoint: "/account/update/e2ee", body: {"public_key": key});
    }
  }
}