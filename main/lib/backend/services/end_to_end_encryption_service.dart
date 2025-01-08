/// Abstract class to define the base structure for a service that handles
/// cryptographic operations, including key pair generation, encryption,
/// decryption, and public key sharing.
///
/// This class provides methods to generate key pairs, encrypt messages,
/// decrypt messages, and send public keys to the server. It is intended
/// to be extended by concrete implementations that provide the actual
/// logic for these operations.
abstract class EndToEndEncryptionService {
  /// Generates a key pair (public and private).
  ///
  /// The generated keys are used for encryption and decryption operations.
  /// This method also ensures that the keys are securely stored locally.
  ///
  /// @param password The user's password to generate key pair from.
  void generateKeyPair(String password, {bool shouldSendUpdateToServer = false});

  /// Encrypts a message using the recipient's public key.
  ///
  /// @param message The message to be encrypted.
  /// @param recipientPublicKey The public key of the recipient in Base64 format.
  String encrypt({required String message, required String recipientPublicKey});

  /// Decrypts an encrypted message using the user's private key.
  ///
  /// @param message The encrypted message in Base64 format.
  String decrypt(String message);

  /// Sends the user's public key to the server.
  void sendPublicKeyToServer(String key);
}