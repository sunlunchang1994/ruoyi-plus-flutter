import 'package:flutter/material.dart';
import '../../../base/ui/app_mvvm.dart';
import '../../../base/ui/utils/bar_utils.dart';
import 'workbench_page.dart';
import '../../user/ui/mine_page.dart';
import 'package:provider/provider.dart';

import '../../../../generated/l10n.dart';

class MainPage extends AppBaseStatelessWidget<_MainVm> {
  MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    BarUtils.showEnabledSystemUI(true);
    return ChangeNotifierProvider(create: (context) {
      return _MainVm();
    }, builder: (context, child) {
      ThemeData themeData = Theme.of(context);
      registerEvent(context);
      var mainVm = Provider.of<_MainVm>(context, listen: false);

      List<Widget> pageList = [const WorkbenchPage(), const MinePage()];

      var pageController = PageController();

      List<BottomNavigationBarItem> bottomNavigationBarItem = <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Consumer<_MainVm>(
              builder: (context, vm, child) {
                return const Icon(Icons.text_snippet);
              },
            ),
            label: mainVm.titleArray[0]),
        BottomNavigationBarItem(
            icon: Consumer<_MainVm>(
              builder: (context, value, child) {
                return const Icon(Icons.account_box);
              },
            ),
            label: mainVm.titleArray[1])
      ];
      return Scaffold(
          body: PageView.builder(
              //要点1
              //禁止页面左右滑动切换
              //physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              //回调函数
              itemCount: pageList.length,
              itemBuilder: (context, index) => pageList[index]),
          bottomNavigationBar: Consumer<_MainVm>(builder: (context, vm, child) {
            return BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: vm.currentPageIndex,
                onTap: (value) {
                  //跳转
                  pageController.jumpToPage(value);
                  vm.updateTabIndex(value);
                },
                selectedFontSize: 12,
                items: bottomNavigationBarItem);
          }));
    });
  }
}

class _MainVm extends AppBaseVm {
  int currentPageIndex = 0;

  final List<String> titleArray = [S.current.main_label_workbench, S.current.main_label_mine];

  void updateTabIndex(int index) {
    currentPageIndex = index;
    notifyListeners();
  }
}
