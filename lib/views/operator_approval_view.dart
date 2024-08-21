
import 'package:client/controllers/operator_approval_controller.dart';
import 'package:client/models/home_operator_model.dart';
import 'package:client/utils/theme.dart';
import 'package:flutter/material.dart';

class OperatorApprovalView extends StatefulWidget {
  const OperatorApprovalView({super.key});

  @override
  State<OperatorApprovalView> createState() => _OperatorApprovalViewState();
}

class _OperatorApprovalViewState extends State<OperatorApprovalView> {
  bool isFirst = true;
  bool isLoading = false;
  bool isSubmitting = false;
  late ApprovalRequest approvalRequest;
  final _controller = OperatorApprovalController();

  void getInitial(String id) async {
    setState(() {
      isLoading = true;
    });
    ApprovalRequest data = await _controller.getDetailApproval(id);
    setState(() {
      approvalRequest = data;
      isLoading = false;
    });
  }

  void confirmApproval(String id, BuildContext context) async {
    setState(() {
      isSubmitting = true;
    });
    _controller.approveKeluarga(id, context).whenComplete(() {
      setState(() {
        isSubmitting = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context)!.settings.arguments as String;

    if (isFirst) {
      getInitial(id);
      setState(() {
        isFirst = false;
      });
    }

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              margin: const EdgeInsets.only(top: 60.0),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.verified_user_rounded,
                      size: 65.0,
                      color: AppColors.green[500],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    confirmTitle(),
                    const SizedBox(
                      height: 25.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildData('NIK', approvalRequest.nik),
                        const SizedBox(
                          height: 10.0,
                        ),
                        buildData('Nama Lengkap', approvalRequest.namaLengkap),
                        const SizedBox(
                          height: 10.0,
                        ),
                        buildData('No. Telepon', approvalRequest.noTelp),
                        const SizedBox(
                          height: 10.0,
                        ),
                        buildData('Desa',
                            "${approvalRequest.desa} - RT ${approvalRequest.rt} / RW ${approvalRequest.rw}"),
                        const SizedBox(
                          height: 10.0,
                        ),
                        buildData('Alamat Lengkap', approvalRequest.alamat),
                        const SizedBox(
                          height: 10.0,
                        ),
                        buildData('Puskesmas Pengampu',
                            approvalRequest.puskesmas.namaPuskesmas),
                        const SizedBox(
                          height: 10.0,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
      bottomNavigationBar: isLoading ? null : confirmButton(id),
    );
  }

  Container confirmButton(String id) {
    return Container(
      height: 60,
      margin: const EdgeInsets.all(40.0),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSubmitting
              ? const Color(0xFF12d516).withOpacity(0.2)
              : const Color(0xFF12d516),
        ),
        onPressed: () => isSubmitting ? null : confirmApproval(id, context),
        child: isSubmitting
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : const Text(
                "Konfirmasi Data",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  Column buildData(String fieldName, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldName,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Text(
          content,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Column confirmTitle() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Konfirmasi Persetujuan',
          style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 5.0,
        ),
        Text(
          'Pastikan kebenaran data yang diberikan keluarga',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
        )
      ],
    );
  }
}
