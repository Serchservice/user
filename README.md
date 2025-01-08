# 📱 Serchservice User Mobile Application

Welcome to the **Serchservice User** mobile application! This Flutter-based project is designed for users to onboard themselves onto the Serchservice user platform, enabling seamless management and integration with Serchservice's user mobile applications.

## 🚀 Project Overview

This mobile application serves the **User** category of Serchservice, allowing users to register, manage, and onboard their accounts in the Serchservice ecosystem. The platform offers a convenient, streamlined interface, enabling users to connect directly with service providers, improving operational efficiency.

The project is built using **Flutter** 🐦 and relies on a variety of packages and plugins, including our custom-made `connectify_flutter` package developed by the Serchservice team.

## 🛠️ Key Features

- **Onboard User**: Easy onboarding of your user profile to use Serchservice's user mobile platforms.
- **User Management Tools**: Comprehensive features to manage user-related operations.
- **Custom Packages**: Integration with Serchservice's proprietary `connectify_flutter` package for seamless connectivity.
- **CI/CD Integration**: Automated builds using CI/CD for efficient deployment.

## 📦 Dependencies & Packages

This project relies on several essential Flutter packages and plugins to provide a rich, feature-complete experience:

- [`flutter`](https://flutter.dev/)
- [`get`](https://pub.dev/packages/get)
- [`firebase_core`](https://pub.dev/packages/firebase_core)
- [`connectify_flutter`](https://github.com/Serchservice/connectify_flutter) (Custom Serchservice package)
- [`logger_flutter`](https://github.com/Serchservice/connectify_flutter) (Custom Serchservice package)
- [`secure_flutter`](https://github.com/Serchservice/connectify_flutter) (Custom Serchservice package)

Make sure to check the `pubspec.yaml` for the full list of dependencies and their versions.

### Special Configuration for `connectify_flutter`

To access the `connectify_flutter` package, you need to set up authentication via a `.netrc` file. This file allows secure access to the private package hosted on GitHub.

Create a `.netrc` file in your home directory with the following content:

```bash
machine github.com
login your_username
password your_personal_access_token
```

Replace `your_username` and `your_personal_access_token` with your actual GitHub credentials and personal access token.

For more information on GitHub authentication tokens, refer to [GitHub Docs](https://docs.github.com/en/rest).

## 🚧 Development Setup

To set up the project locally, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/Serchservice/business.git
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Set up your `.netrc` file as described above.
4. Run the application:
   ```bash
   flutter run
   ```

### Versioning

For every update or release, make sure to **update the version** in the `pubspec.yaml` file. CI/CD workflows rely on version updates for automated build and deployment.

## 🔧 CI/CD Pipeline

This project uses CI/CD pipelines to automate the process of building and releasing the application. The CI/CD setup ensures that the app is always in sync and deploys the latest app bundle versions.

### KeyStore for CI/CD

Run this to get the `.jks` file:

```bash
base64 -w 0 <path_to_your_keystore_file> > keystore.base64
```

You can do this on mac:

```bash
base64 /path/upload-keystore.jks > keystore.base64
```

### Key CI/CD Features:
- Automated app bundle generation.
- Version control checks: make sure the `pubspec.yaml` version is updated for every new release.

This script will build the Flutter web files, switch to the `web` branch (or create it if it doesn't exist), deploy the web files, and then return to the `main` branch.

## 🙏 Contributing

We welcome contributions to the Serchservice User Mobile Application. To contribute, please fork the repository and submit a pull request with your changes. Make sure to update the relevant documentation and follow coding standards.

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

**Happy coding!** 🎉 If you encounter any issues, feel free to open an issue or reach out to the Serchservice team.