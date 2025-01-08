import 'package:user/library.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class WalletTransactionsController extends GetxController {
  WalletTransactionsController();
  final state = WalletTransactionsState();

  final ConnectService _connect = Connect();

  final _pageSize = 20;
  final PagingController<int, TransactionGroup> transactionController = PagingController(firstPageKey: 0);

  @override
  void onInit() {
    transactionController.addPageRequestListener((pageKey) {
      _fetchTransactions(pageKey);
    });

    super.onInit();
  }

  void _fetchTransactions(int pageKey) async {
    var response = await _connect.get(endpoint: "/wallet/transactions?page=$pageKey&size=$_pageSize");
    if(response.isOk) {
      List<dynamic> result = response.data;
      List<TransactionGroup> list = result.map((e) => TransactionGroup.fromJson(e)).toList();

      if(transactionController.itemList != null) {
        List<TransactionGroup> existingList = transactionController.itemList!;
        for (var group in existingList) {
          int index = list.indexWhere((group) => group.label == group.label);
          if (index != -1) {
            int groupIndex = existingList.indexOf(group);
            if(groupIndex != -1) {
              group.transactions.addAll(list[index].transactions);
              transactionController.itemList![groupIndex] = group;

              list.removeAt(index);
            }
          }
        }
      }

      bool isLastPage = list.length <= _pageSize;
      if(isLastPage) {
        transactionController.appendLastPage(list);
      } else {
        transactionController.appendPage(list, CommonUtility.increment(pageKey));
      }
    } else {
      transactionController.error = response.message;
    }
  }
}