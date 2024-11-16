import 'package:client/components/custom_navbar.dart';
import 'package:client/controllers/buku_saku_controller.dart';
import 'package:client/models/buku_saku_model.dart';
import 'package:client/utils/theme.dart';
import 'package:flutter/material.dart';

class BukuSakuListView extends StatefulWidget {
  const BukuSakuListView({super.key});

  @override
  State<BukuSakuListView> createState() => _BukuSakuListViewState();
}

class _BukuSakuListViewState extends State<BukuSakuListView> {
  final BukuSakuController _controller = BukuSakuController();
  late List<BukuSakuModel> dataList = _controller.dataList;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              margin: const EdgeInsets.only(top: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    size: 84.0,
                    color: Colors.blue[500],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text(
                    "Buku Saku",
                    style:
                        TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  const Text(
                    "Menyediakan puluhan informasi mengenai stunting dan cara penanganannya",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Flexible(
                    child: ListView.builder(
                      itemBuilder: (context, index) => buildTile(
                          title: dataList[index].title,
                          slug: dataList[index].slug,
                          index: index),
                      itemCount: dataList.length,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const CustomNavigationBar(currentIndex: 3),
      ),
    );
  }

  Card buildTile({String? title, String? slug, int? index}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15.0),
      borderOnForeground: false,
      shadowColor: Colors.transparent,
      child: ListTile(
        tileColor: index! % 2 == 0
            ? Colors.blue[300]?.withOpacity(0.15)
            : AppColors.green[300]?.withOpacity(0.15),
        splashColor: index % 2 == 0 ? Colors.blue[300] : AppColors.green[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        leading: Icon(
          Icons.book_rounded,
          color: index % 2 == 0 ? Colors.blue[700] : AppColors.green[700],
          size: 32.0,
        ),
        title: Text(
          title!,
          style: TextStyle(
              fontSize: 14.0,
              color: index % 2 == 0 ? Colors.blue[700] : AppColors.green[700]),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: index % 2 == 0 ? Colors.blue[700] : AppColors.green[700],
          size: 25.0,
        ),
        onTap: () async {
          await Future.delayed(const Duration(milliseconds: 400));
          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, "/buku-saku-detail", arguments: slug);
        },
      ),
    );
  }
}
