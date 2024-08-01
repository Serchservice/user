/// Abstract service for managing home dashboard functionality, including loading categories and fetching dashboard data.
abstract class HomeDashboardService {

  /// Loads the categories for the dashboard.
  void loadCategories();

  /// Loads the popular categories for the dashboard.
  void loadPopularCategories();

  /// Fetches the dashboard data.
  /// 
  /// @param showLoader Indicates if a loader should be shown while fetching the dashboard data. Defaults to true.
  void fetchDashboard(bool showLoader);
}