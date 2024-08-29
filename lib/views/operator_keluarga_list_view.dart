import 'dart:async';
import 'dart:convert';

import 'package:client/components/operator_navbar.dart';
import 'package:client/models/screening_test_result_model.dart';
import 'package:client/utils/constant.dart';
import 'package:client/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OperatorKeluargaListView extends StatefulWidget {
  const OperatorKeluargaListView({super.key});

  @override
  State<OperatorKeluargaListView> createState() => _OperatorKeluargaListState();
}

class _OperatorKeluargaListState extends State<OperatorKeluargaListView> {
  late List<Keluarga> _keluargaList = [];
  bool onLoading = false;
  @override
  void initState() {
    super.initState();
    getInitial();
  }

  void getInitial() async {
    setState(() {
      onLoading = true;
    });
    await getKeluargaList();
    setState(() {
      onLoading = false;
    });
  }

  Future<void> _refreshPage() async {
    setState(() {
      _keluargaList.clear();
    });

    await Future.delayed(const Duration(seconds: 2));
    await getKeluargaList();
  }

  Future<void> getKeluargaList() async {
    final token = await Constants.getApiToken();
    var response = await http.get(
        Uri.parse("${Constants.apiBaseUrl}/operator/keluarga/list"),
        headers: {
          'Content-Type': "application/json",
          'Authorization': "Bearer $token",
        });
    if (response.statusCode == 200) {
      final data = await jsonDecode(response.body)['data'];
      setState(() {
        _keluargaList =
            List<Keluarga>.from(data.map((x) => Keluarga.fromJson(x)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: onLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  margin: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.family_restroom_rounded,
                        size: 84.0,
                        color: AppColors.green[500],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Text(
                        "Data Keluarga",
                        style: TextStyle(
                            fontSize: 32.0, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      const Text(
                        "Pantau hasil tes screening keluarga",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      _buildKeluargaView()
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: const OperatorNavbar(
        currentIndex: 1,
      ),
    );
  }

  Flexible _buildKeluargaView() => Flexible(
        child: RefreshIndicator(
          backgroundColor: AppColors.green[100],
          color: AppColors.green[600],
          onRefresh: _refreshPage,
          child: ListView.builder(
            itemCount: _keluargaList.length,
            itemBuilder: (context, index) {
              return _eachKeluarga(context, _keluargaList[index].id,
                  _keluargaList[index].nik, _keluargaList[index].namaLengkap);
            },
          ),
        ),
      );

  Card _eachKeluarga(
      BuildContext context, int id, String nik, String namaLengkap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15.0),
      borderOnForeground: false,
      shadowColor: Colors.transparent,
      child: ListTile(
        tileColor: AppColors.green[200]?.withOpacity(0.7),
        splashColor: AppColors.green[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        leading: Icon(
          Icons.person_2_rounded,
          color: AppColors.green[600],
          size: 32.0,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nik,
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 3.0),
            Text(
              namaLengkap,
              style: const TextStyle(fontSize: 14.0),
            ),
          ],
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: AppColors.green[700],
          size: 25.0,
        ),
        onTap: () {
          Timer(const Duration(milliseconds: 750), () {
            Navigator.pushNamed(context, '/operator-keluarga-detail',
                arguments: id);
          });
        },
      ),
    );
  }
}
