import 'package:base/base/ui/app_mvvm.dart';
import 'package:biz_main/biz_main/ui/analyse_page.dart';
import 'package:fast/fast/utils/bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:user/user/ui/user/info/mine_page.dart';
import 'workbench_page.dart';
import 'package:provider/provider.dart';
import '../../gen/app_l10n.dart';

class MainPage extends StatefulWidget {
  static const String routeName = '/index';

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends AppBaseState<MainPage, _MainVm> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BarUtils.showEnabledSystemUI(true);
    return ChangeNotifierProvider(create: (context) {
      return _MainVm();
    }, builder: (context, child) {
      ThemeData themeData = Theme.of(context);
      registerEvent(context);

      List<Widget> pageList = [const AnalysePage(), const WorkbenchPage(), const MinePage()];

      List<BottomNavigationBarItem> bottomNavigationBarItem = <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Consumer<_MainVm>(
              builder: (context, vm, child) {
                return const Icon(Icons.analytics);
              },
            ),
            label: getVm().titleArray[0]),
        BottomNavigationBarItem(
            icon: Consumer<_MainVm>(
              builder: (context, vm, child) {
                return const Icon(Icons.text_snippet);
              },
            ),
            label: getVm().titleArray[1]),
        BottomNavigationBarItem(
            icon: Consumer<_MainVm>(
              builder: (context, value, child) {
                return const Icon(Icons.account_box);
              },
            ),
            label: getVm().titleArray[2])
      ];
      return Scaffold(
          body: PageView.builder(
              //要点1
              //禁止页面左右滑动切换
              //physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              //回调函数
              itemCount: pageList.length,
              itemBuilder: (context, index) => pageList[index]),
          bottomNavigationBar: Consumer<_MainVm>(builder: (context, vm, child) {
            return BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: vm.currentPageIndex,
                onTap: (value) {
                  //跳转
                  _pageController.jumpToPage(value);
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

  final List<String> titleArray = [
    S.current.app_label_analyse,
    S.current.app_label_workbench,
    S.current.app_label_mine
  ];

  void updateTabIndex(int index) {
    currentPageIndex = index;
    notifyListeners();
  }
}
