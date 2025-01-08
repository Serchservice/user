import 'dart:async';

import 'package:user/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SpeakWithSerchTicketController extends GetxController {
  final SpeakWithSerch? message;
  SpeakWithSerchTicketController({this.message});

  final state = SpeakWithSerchTicketState();

  final ConnectService _connect = Connect();

  FocusNode focusNode = FocusNode();
  final ScrollController messageScrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();

  final _pageSize = 20;
  Timer? _debounceTimer;

  @override
  void onInit() {
    if(message != null) {
      state.message.value = message!;

      state.nextPage.value = 1;
    }

    super.onInit();
  }

  bool get hasMessage => state.message.value.ticket.isNotEmpty;

  @override
  void onReady() {
    if(hasMessage) {
      markRead();
    }

    messageScrollController.addListener(_onScrollListener);

    focusNode.addListener(() {
      if(focusNode.hasFocus) {
        _scrollToLastMessage();
      }
    });

    messageController.addListener(() {
      if(messageController.text.isNotEmpty) {
        state.showSendButton.value = true;
      }
    });

    super.onReady();
  }

  void _onScrollListener() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if(messageScrollController.position.pixels == messageScrollController.position.minScrollExtent) {
        state.showScrollButton.value = false;
      } else if(messageScrollController.position.extentBefore < 100) {
        state.showScrollButton.value = false;
      } else {
        state.showScrollButton.value = true;
      }
    });

    if (messageScrollController.position.atEdge && messageScrollController.position.pixels == messageScrollController.position.maxScrollExtent) {
      // Fetch older messages when scrolled to the top
      if(state.isLastPage.isFalse) {
        state.isLoadingMore.value = true;
        _fetchPage();
      }
    }
  }

  void _fetchPage() async {
    String endpoint = "/company/speak_with_serch/issues/${state.message.value.ticket}?page=${state.nextPage.value}&size=$_pageSize";
    final response = await _connect.get(endpoint: endpoint);

    if(response.isSuccessful) {
      List<dynamic> result = response.data;
      List<Issue> issues = result.map((r) => Issue.fromJson(r)).toList();
      _updateList(issues);

      state.isLastPage.value = issues.length < _pageSize;
      state.error.value = "";
      state.isLoadingMore.value = false;

      if (state.isLastPage.isFalse) {
        state.nextPage.value++;
      }
    } else {
      state.error.value = response.message;
      state.isLoadingMore.value = false;
    }
  }

  void _updateList(List<Issue> issues) {
    List<Issue> existing = List.from(state.message.value.issues);
    existing.addAll(issues);

    existing.sort((a, b) => a.sentAt.compareTo(b.sentAt));
    state.message.value = state.message.value.copyWith(issues: existing);
  }

  void _scrollToLastMessage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToEnd();
    });
  }

  void scrollToEnd() {
    if(messageScrollController.hasClients && messageScrollController.positions.isNotEmpty) {
      messageScrollController.animateTo(
        messageScrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInCubic,
      );
    }
  }

  void refreshPage() {
    state.nextPage.value = 0;
    _fetchPage();
  }

  void send(BuildContext context) async {
    if(messageController.text.isEmpty) {
      return;
    } else {
      String comment = messageController.text.trim();
      Issue issue = Issue.sending(message: comment);
      _add(issue);
      messageController.clear();

      CommonUtility.unfocus(context);
      state.isSending.value = true;
      var response = await _connect.post(
        endpoint: "/company/speak_with_serch",
        body: {"ticket": state.message.value.ticket, "comment": comment}
      );

      state.isSending.value = false;
      if(response.isOk) {
        SpeakWithSerch update = SpeakWithSerch.fromJson(response.data);
        state.message.value = update;
        SpeakWithSerchController.data.messageController.refresh();

        _scrollToLastMessage();
      } else {
        List<Issue> issues = List.from(state.message.value.issues);
        issues.remove(issue);
        state.message.value = state.message.value.copyWith(issues: issues);
        notify.tip(message: response.message, color: CommonColors.error);
      }
    }
  }

  void _add(Issue issue) {
    List<Issue> items = List.from(state.message.value.issues);
    items.insert(0, issue);

    items.sort((a, b) => a.sentAt.compareTo(b.sentAt));
    state.message.value = state.message.value.copyWith(issues: items);
  }

  void markRead() async {
    if(hasMessage) {
      var response = await _connect.patch(endpoint: "/company/speak_with_serch/${state.message.value.ticket}");
      if(response.isOk) {
        List<dynamic> result = response.data;
        List<SpeakWithSerch> list = result.map((e) => SpeakWithSerch.fromJson(e)).toList();

        SpeakWithSerchController.data.updateList(list);
        for (var i in list) {
          if(i.ticket == state.message.value.ticket) {
            state.message.value = i;
          }
        }
      }
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    focusNode.dispose();
    _debounceTimer?.cancel();
    messageScrollController.dispose();

    super.onClose();
  }
}