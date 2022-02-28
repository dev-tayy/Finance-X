import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:finance_x/components/snackbar.dart';
import 'package:finance_x/core/models/user.dart';
import 'package:finance_x/core/services/database/firestore_db.dart';
import 'package:finance_x/features/transactions/widgets/contacts_list_tile.dart';
import 'package:finance_x/features/transactions/widgets/dashboard_tc.dart';
import 'package:finance_x/features/transactions/widgets/debtors_list_tile.dart';
import 'package:finance_x/features/transactions/widgets/expenses_list_tile.dart';
import 'package:finance_x/features/transactions/widgets/transaction_floating_button.dart';
import 'package:finance_x/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:finance_x/utils/extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class HomeScreen extends HookConsumerWidget {
  static const String id = 'home_screen';
  final User user;
  HomeScreen({Key? key, required this.user}) : super(key: key);

  TabBar get _tabBar => const TabBar(
        isScrollable: true,
        indicatorWeight: 1.5,
        indicator: UnderlineTabIndicator(
          insets: EdgeInsets.symmetric(horizontal: 80.0),
          borderSide: BorderSide(
            width: 2.0,
            color: AppColors.tertiaryColor,
          ),
        ),
        indicatorColor: AppColors.tertiaryColor,
        unselectedLabelColor: AppColors.greyShade4,
        labelColor: AppColors.black,
        labelStyle: TextStyle(
          fontSize: 15,
          fontFamily: 'Karla',
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 15,
          fontFamily: 'Karla',
          fontWeight: FontWeight.w400,
        ),
        tabs: [
          Tab(child: Text('Expenses')),
          Tab(child: Text('Debtors')),
          Tab(child: Text('Contacts')),
        ],
      );

  DBService dbService = DBService();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    ValueNotifier<List<Contact>> _contacts = useState([]);

    Future<void> getContacts() async {
      final List<Contact> contacts = await ContactsService.getContacts();
      _contacts.value = contacts;
    }

    void _handleInvalidPermissions(PermissionStatus permissionStatus) {
      if (permissionStatus == PermissionStatus.denied) {
        FXSnackbar.showErrorSnackBar(context,
            message: 'Access to contact data denied');
      } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
        FXSnackbar.showErrorSnackBar(context,
            message: 'Contact data not available on device');
      }
    }

    Future<PermissionStatus> _getContactPermission() async {
      PermissionStatus permission = await Permission.contacts.status;
      if (permission != PermissionStatus.granted &&
          permission != PermissionStatus.permanentlyDenied) {
        PermissionStatus permissionStatus = await Permission.contacts.request();
        return permissionStatus;
      } else {
        return permission;
      }
    }

    Future<void> _askPermissions() async {
      PermissionStatus permissionStatus = await _getContactPermission();
      if (permissionStatus == PermissionStatus.granted) {
      } else {
        _handleInvalidPermissions(permissionStatus);
      }
    }

    useMemoized(() {
      _askPermissions().then((value) => getContacts());
    });
    return Scaffold(
      floatingActionButton: const TransactionFloatingButton(),
      body: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: dbService.getUserCredentialsStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    FXSnackbar.showErrorSnackBar(context,
                        message: snapshot.error.toString(), milliseconds: 3000);
                  });
                }

                //LOADING STATE
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: [
                      DashboardTopContainer(size: size, user: user),
                      const SizedBox(height: 70),
                      _tabBar,
                      Expanded(
                          child: TabBarView(children: [
                        //EXPENSES TAB
                        ListView.builder(
                          itemCount: user.expenses.length,
                          itemBuilder: ((context, index) {
                            return ExpensesListTile(
                              amount: user.expenses[index].amount,
                              category: user.expenses[index].category,
                              description: user.expenses[index].description,
                              timeStamp: user.expenses[index].dateTime,
                            ).paddingSymmetric(v: 3);
                          }),
                        ).paddingSymmetric(h: 20),

                        //DEBTORS TAB
                        ListView.builder(
                          itemCount: user.debtors.length,
                          itemBuilder: ((context, index) {
                            return DebtorsListTile(
                              amount: user.debtors[index].amount,
                              debtorName: user.debtors[index].debtorName,
                              debtorPhone: user.debtors[index].phoneNumber,
                              debtorEmail: user.debtors[index].emailAddress,
                              description: user.debtors[index].description,
                              borrowedDate:
                                  user.debtors[index].borrowedDateTime,
                              dueDate: user.debtors[index].dueDateTime,
                            ).paddingSymmetric(v: 3);
                          }),
                        ).paddingSymmetric(h: 20),

                        //CONTACTS TAB
                        ListView.builder(
                          itemCount: _contacts.value.length,
                          itemBuilder: ((context, index) {
                            return ContactsListTile(
                              displayName: _contacts.value[index].displayName,
                              givenName: _contacts.value[index].givenName,
                              email: _contacts.value[index].emails!.isEmpty
                                  ? ''
                                  : _contacts.value[index].emails![0].value,
                              phoneNumber:
                                  _contacts.value[index].phones!.isEmpty
                                      ? ''
                                      : _contacts.value[index].phones![0].value,
                            ).paddingSymmetric(v: 3);
                          }),
                        ).paddingSymmetric(h: 20),
                      ]))
                    ],
                  );
                }

                //DATA STATE
                final userData = User.fromJson(snapshot.data!.data() ?? {});
                return Column(
                  children: [
                    DashboardTopContainer(size: size, user: userData),
                    const SizedBox(height: 70),
                    _tabBar,
                    Expanded(
                        child: TabBarView(children: [
                      //EXPENSES TAB
                      ListView.builder(
                        itemCount: userData.expenses.length,
                        itemBuilder: ((context, index) {
                          return ExpensesListTile(
                            amount: userData.expenses[index].amount,
                            category: userData.expenses[index].category,
                            description: userData.expenses[index].description,
                            timeStamp: userData.expenses[index].dateTime,
                          ).paddingSymmetric(v: 3);
                        }),
                      ).paddingSymmetric(h: 20),

                      //DEBTOR TAB
                      ListView.builder(
                        itemCount: userData.debtors.length,
                        itemBuilder: ((context, index) {
                          return DebtorsListTile(
                            amount: userData.debtors[index].amount,
                            debtorName: userData.debtors[index].debtorName,
                            debtorPhone: userData.debtors[index].phoneNumber,
                            debtorEmail: userData.debtors[index].emailAddress,
                            description: userData.debtors[index].description,
                            borrowedDate:
                                userData.debtors[index].borrowedDateTime,
                            dueDate: userData.debtors[index].dueDateTime,
                          ).paddingSymmetric(v: 3);
                        }),
                      ).paddingSymmetric(h: 20),

                      //CONTACTS TAB
                      ListView.builder(
                        itemCount: _contacts.value.length,
                        itemBuilder: ((context, index) {
                          return ContactsListTile(
                            displayName: _contacts.value[index].displayName,
                            givenName: _contacts.value[index].givenName,
                            email: _contacts.value[index].emails!.isEmpty
                                ? ''
                                : _contacts.value[index].emails![0].value,
                            phoneNumber: _contacts.value[index].phones!.isEmpty
                                ? ''
                                : _contacts.value[index].phones![0].value,
                          ).paddingSymmetric(v: 3);
                        }),
                      ).paddingSymmetric(h: 20),
                    ]))
                  ],
                );
              }),
        ),
      ),
    );
  }
}
