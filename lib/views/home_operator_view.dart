import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:client/components/operator_navbar.dart';
import 'package:client/controllers/operator_home_controller.dart';
import 'package:client/models/home_operator_model.dart';
import 'package:client/utils/theme.dart';
import 'package:flutter/material.dart';

class HomeOperatorView extends StatefulWidget {
  const HomeOperatorView({super.key});

  @override
  State<HomeOperatorView> createState() => _HomeOperatorViewState();
}

class _HomeOperatorViewState extends State<HomeOperatorView> {
  bool isLoading = false;
  dynamic operatorAuth;
  late List<ApprovalRequest> approvalRequest;
  final _controller = OperatorHomeController();

  void operatorLogout() {
    _controller.pushLogout(context, 'operator_auth');
  }

  Future<void> getInitial() async {
    setState(() {
      isLoading = true;
    });
    final data = await _controller.getCurrentOperator();
    List<ApprovalRequest>? availableRequest =
        await _controller.getAvailableApproval(context);
    setState(() {
      operatorAuth = data;
      isLoading = false;
      approvalRequest = availableRequest ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    getInitial();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 60.0,
          leadingWidth: 60.0,
          backgroundColor: Colors.white,
          leading: Container(
            margin: const EdgeInsets.only(left: 24.0),
            child: CircleAvatar(
              child: Image.asset(
                'assets/images/global/avatar.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          actions: [
            IconButton(
              padding: const EdgeInsets.only(right: 24.0),
              icon: Icon(
                Icons.logout_outlined,
                color: AppColors.green[600],
              ),
              onPressed: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  animType: AnimType.bottomSlide,
                  title: 'Konfirmasi Logout',
                  desc: 'Apakah Anda yakin ingin logout?',
                  btnCancelOnPress: () {},
                  btnOkOnPress: () {
                    operatorLogout();
                  },
                  btnOkColor: AppColors.green[600],
                ).show();
              },
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                backgroundColor: AppColors.green[100],
                color: AppColors.green[600],
                onRefresh: () async {
                  Timer(const Duration(milliseconds: 400), () {
                    getInitial();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ListView(
                    children: [
                      greeting(),
                      const SizedBox(height: 24.0),
                      approvalReqestView(),
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: const OperatorNavbar(currentIndex: 0),
      ),
    );
  }

  Column approvalReqestView() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Permintaan Persetujuan',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      const SizedBox(height: 5.0),
      const Text('Data keluarga yang belum disetujui',
          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400)),
      const SizedBox(height: 15),
      if (approvalRequest.isNotEmpty)
        SingleChildScrollView(
          child: SizedBox(
            height: approvalRequest.length * 70.0,
            child: ListView.builder(
              itemCount: approvalRequest.length,
              itemBuilder: (context, index) {
                final approval = approvalRequest[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 15.0),
                  decoration: BoxDecoration(
                    color: AppColors.green[100],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    tileColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    leading:
                        const Icon(Icons.account_circle, color: Colors.red),
                    title: Text(approval.namaLengkap),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/operator-approval',
                        arguments: approval.id.toString(),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        )
      else
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.verified_user_rounded,
              color: AppColors.green[600],
            ),
            const SizedBox(
              width: 10.0,
            ),
            const Text(
              'Semua telah disetujui',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
    ]);
  }

  SizedBox greeting() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Halo,',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            '${operatorAuth?['user']?['nama_lengkap']}  👋',
            style: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
