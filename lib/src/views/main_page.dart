import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:smart_ix/src/utils/build_context_x.dart';
import 'package:smart_ix/src/viewmodels/devices_view_model.dart';
import 'package:smart_ix/src/viewmodels/main_page_view_model.dart';
import 'package:smart_ix/src/views/qr_code_scan_page.dart';
import 'package:smart_ix/src/views/widgets/home_widget.dart';
import 'package:smart_ix/src/views/widgets/profile_widget.dart';
import 'package:smart_ix/src/views/widgets/snack_bar.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => MainPageViewModel(),
        child: const _MainPage(),
      );
}

class _MainPage extends StatefulWidget {
  const _MainPage();

  @override
  State<_MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<_MainPage> with TickerProviderStateMixin {
  List<BottomNavigationBarItem> get bottomNavBarItems => [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_rounded),
          label: context.appLocalizations.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.account_circle_rounded),
          label: context.appLocalizations.profile,
        ),
      ];

  List<String> get titles =>
      bottomNavBarItems.map((e) => e.label ?? '').toList();

  MainPageViewModel get mainPageViewModel => context.watch<MainPageViewModel>();

  TabController get bottomNavBarController => TabController(
        length: bottomNavBarItems.length,
        initialIndex: mainPageViewModel.pageIndex,
        vsync: this,
      );

  Future<void> _scanQr() async {
    Barcode? barcode = await Navigator.push<Barcode?>(
      context,
      MaterialPageRoute(builder: (context) => const QRCodeScanPage()),
    );
    DevicesViewModel devicesViewModel = context.read();
    if (barcode != null) {
      final deviceAdded = await devicesViewModel.tryAddDevice(barcode.code);
      if (!deviceAdded) {
        AppSnackBar.show3Sec(
          context: context,
          message: context.appLocalizations.invalidBarcode,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    MainPageViewModel mainPageViewModel = context.watch<MainPageViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[mainPageViewModel.pageIndex]),
        centerTitle: true,
      ),
      body: TabBarView(
        controller: bottomNavBarController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomeWidget(),
          ProfileWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanQr,
        child: const Icon(Icons.qr_code_scanner),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavBarItems,
        onTap: mainPageViewModel.changePage,
        currentIndex: mainPageViewModel.pageIndex,
      ),
    );
  }
}
