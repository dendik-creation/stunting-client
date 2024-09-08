import 'package:client/components/custom_navbar.dart';
import 'package:client/controllers/buku_saku_controller.dart';
import 'package:client/models/buku_saku_model.dart';
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
                          slug: dataList[index].slug),
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

  Card buildTile({String? title, String? slug}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15.0),
      borderOnForeground: false,
      shadowColor: Colors.transparent,
      child: ListTile(
        tileColor: Colors.blue[600]?.withOpacity(0.9),
        splashColor: Colors.blue[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        leading: const Icon(
          Icons.abc_rounded,
          color: Colors.white,
          size: 32.0,
        ),
        title: Text(
          title!,
          style: const TextStyle(fontSize: 14.0, color: Colors.white),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Colors.white,
          size: 25.0,
        ),
        onTap: () {
          Navigator.pushNamed(context, "/buku-saku-detail", arguments: slug);
        },
      ),
    );
  }
}
