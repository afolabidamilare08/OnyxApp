import 'package:flutter/material.dart';
import 'package:onyxswap/core/constants/custom_icons.dart';
import 'package:onyxswap/core/constants/textstyle.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/views/account/account_view.dart';
import 'package:onyxswap/views/pay_bills/pay_bills_view.dart';
import 'package:onyxswap/views/support/components/contact_us.dart';
import 'package:onyxswap/views/support/support_view.dart';
import 'package:onyxswap/views/virtual_cards/virtual_card_view.dart';
import 'package:onyxswap/views/wallet/wallet_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

int _selectedPage = 0;
PageController _pageController = PageController();
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    onPageChange(int index) {
      setState(() {
        _selectedPage = index;
      });
      _pageController.jumpToPage(index);
    }

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        key: _scaffoldKey,
        body: PageView(
          onPageChanged: onPageChange,
          controller: _pageController,
          children: const [
            WalletView(),
            VirtualCardView(),
            AccountView(),
            PayBillsView(),
            ContactUs(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 25,
          enableFeedback: true,
          // enableFeedback: true,
          type: BottomNavigationBarType.fixed,
          unselectedLabelStyle: button4L,
          selectedLabelStyle: button4L,
          backgroundColor: Color(0xff1E1F1E),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              backgroundColor: kSecondaryColor.withOpacity(0.12),
              icon: const Icon(
                NyxIcons.wallet,
                size: 20,
              ),
              label: "Wallet",
              activeIcon: const Icon(
                NyxIcons.wallet,
                size: 24,
              ),
            ),
            BottomNavigationBarItem(
              backgroundColor: kSecondaryColor.withOpacity(0.12),
              icon: const Icon(
                NyxIcons.virtualcards,
                size: 20,
              ),
              activeIcon: const Icon(
                NyxIcons.virtualcards,
                size: 24,
              ),
              label:
                  MediaQuery.of(context).size.width < 400 ? "Cards" : "Cards",
            ),
            BottomNavigationBarItem(
              backgroundColor: kSecondaryColor.withOpacity(0.12),
              icon: const Icon(
                NyxIcons.account,
                size: 20,
              ),
              activeIcon: const Icon(
                NyxIcons.account,
                size: 24,
              ),
              label: "Account",
            ),
            BottomNavigationBarItem(
              backgroundColor: kSecondaryColor.withOpacity(0.12),
              icon: const Icon(
                NyxIcons.paybills,
                size: 20,
              ),
              activeIcon: const Icon(
                NyxIcons.paybills,
                size: 24,
              ),
              label: "Pay Bills",
            ),
            const BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(
                NyxIcons.messages,
                size: 20,
              ),
              activeIcon: Icon(
                NyxIcons.messages,
                size: 24,
              ),
              label: "Support",
            ),
          ],
          currentIndex: _selectedPage,
          selectedItemColor: kSecondaryColor,
          unselectedItemColor: kSecondaryColor.withOpacity(0.72),
          onTap: onPageChange,
        ),
      ),
    );
  }
}
