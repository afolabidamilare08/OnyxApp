import 'package:contacts_service/contacts_service.dart';
//import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import 'package:onyxswap/core/constants/textstyle.dart';
import 'package:onyxswap/views/pay_bills/components/contact_scrren_widget.dart';
import 'package:onyxswap/views/pay_bills/viewmodels/buyAirtime_viewmodel.dart';

import '../../../utils/color.dart';
import '../../../utils/text.dart';

final _buyAirtimeViewmodel =
    ChangeNotifierProvider.autoDispose((ref) => BuyAirtimeViewmodel());

class ContactScreen extends ConsumerStatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContactScreenState();
}

TextEditingController searchController = TextEditingController();

class _ContactScreenState extends ConsumerState<ContactScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2),
        ref.read(_buyAirtimeViewmodel).getContactList);
    searchController.addListener(() {
      filteredContact();
    });
    super.initState();
  }

  filteredContact() {
    List<Contact> _contact = [];
    _contact.addAll(ref.watch(_buyAirtimeViewmodel).contacts);
    if (searchController.text.isNotEmpty) {
      _contact.retainWhere((contact) {
        String searchName = searchController.text.toLowerCase();
        String username = contact.displayName!.toLowerCase();
        return username.contains(searchName);
      });
      setState(() {
        ref.watch(_buyAirtimeViewmodel).filteredcontacts = _contact;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var model = ref.watch(_buyAirtimeViewmodel);
    bool isSearching = searchController.text.isNotEmpty;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 65, top: 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: kSecondaryColor,
                      )),
                  AppText.heading4N(
                    'Contacts',
                    color: kSecondaryColor,
                    centered: true,
                    //textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                ],
              ),
              const SizedBox(
                width: 40,
              ),
              model.contacts.isEmpty
                  ? Center(
                      child: SizedBox(
                          height: 50,
                          width: 50,
                          child: Center(
                              child:
                                  Lottie.asset("assets/lotties/loader.json"))),
                    )
                  : SizedBox(
                      height: 40,
                      child: TextField(
                        controller: searchController,
                        cursorColor: kSecondaryColor,
                        style: body3L,
                        decoration: InputDecoration(
                          // filled: true,
                          // fillColor: kPrimaryColor,

                          labelText: 'Search contacts',
                          labelStyle: body3L,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: kSecondaryColor,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kBorderColor),
                              borderRadius: BorderRadius.circular(8)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: kBorderColor),
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
              const SizedBox(
                width: 40,
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: ((context, index) {
                    var contacts = isSearching
                        ? model.filteredcontacts[index]
                        : model.contacts[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context, contacts.phones![0].value!);
                      },
                      child: ContactContainer(
                          contactName: contacts.displayName!,
                          mobileNumber: contacts.phones!.isEmpty
                              ? '---'
                              : contacts.phones![0].value!),
                    );
                  }),
                  itemCount: isSearching
                      ? model.filteredcontacts.length
                      : model.contacts.length,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
