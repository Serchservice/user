import 'package:user/library.dart';

/// Abstract service for managing shared links in the home section.
abstract class HomeSharedLinkService {

  /// Fetches the shared links.
  ///
  /// @param showLoader Indicates if a loader should be shown while fetching the shared links. Defaults to true.
  void fetch({bool showLoader = true});

  /// Adds a shared link to the list.
  ///
  /// @param link The [SharedLink] to be added.
  void addToLinks(SharedLink link);

  /// Updates the shared links list with the given data.
  ///
  /// @param data List of Map<String, dynamic> to be converted to [SharedLink] model.
  void updateList(List<dynamic> data);
}