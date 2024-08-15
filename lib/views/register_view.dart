import 'package:client/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:client/controllers/register_controller.dart';
import 'package:client/models/register_model.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _controller = RegisterController();

  late String _nik, _namaLengkap, _desa, _rt, _rw, _noTelepon, _alamatLengkap;
  PuskesmasModel? _selectedPuskesmas;
  bool _isLoading = false;
  bool _isSubmitLoading = false;

  List<PuskesmasModel> _puskesmasList = [];

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _controller.getPuskesmas().then((data) {
      setState(() {
        _puskesmasList = data;
      });
    }).whenComplete(() {
      _isLoading = false;
    });
  }

  _register() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      RegisterModel user = RegisterModel(
        nik: _nik.toString(),
        namaLengkap: _namaLengkap,
        desa: _desa,
        rt: _rt.toString(),
        rw: _rw.toString(),
        noTelepon: _noTelepon.toString(),
        alamatLengkap: _alamatLengkap,
        puskesmasTerdekat: _selectedPuskesmas!.id.toString(),
      );

      setState(() {
        _isSubmitLoading = true;
      });
      _controller.register(user, context).whenComplete(() {
        setState(() {
          _isSubmitLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.person_2_rounded,
                        size: 82.0, color: AppColors.green[500]),
                    const SizedBox(height: 15),
                    const Text(
                      'Registrasi Keluarga',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Bergabung bersama untuk keluarga Indonesia bebas stunting',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(
                              "NIK", Icons.credit_card, TextInputType.number,
                              (value) {
                            _nik = value!;
                          }, maxLength: 16),
                          const SizedBox(height: 10),
                          _buildTextField(
                              "Nama Lengkap", Icons.person, TextInputType.text,
                              (value) {
                            _namaLengkap = value!;
                          }),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: _buildTextField(
                                      "Desa", Icons.home, TextInputType.text,
                                      (value) {
                                    _desa = value!;
                                  })),
                              const SizedBox(width: 10),
                              Expanded(
                                  flex: 1,
                                  child: _buildTextField(
                                      "RT", Icons.place, TextInputType.number,
                                      (value) {
                                    _rt = value!;
                                  })),
                              const SizedBox(width: 10),
                              Expanded(
                                  flex: 1,
                                  child: _buildTextField(
                                      "RW", Icons.place, TextInputType.number,
                                      (value) {
                                    _rw = value!;
                                  })),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(
                              "No Telepon", Icons.phone, TextInputType.number,
                              (value) {
                            _noTelepon = value!;
                          }),
                          const SizedBox(height: 10),
                          _buildTextField("Alamat Lengkap", Icons.location_on,
                              TextInputType.text, (value) {
                            _alamatLengkap = value!;
                          }),
                          const SizedBox(height: 10),
                          _buildDropdown(),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isSubmitLoading ? null : _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF12d516),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: _isSubmitLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Registrasi',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Divider(
                          indent: 40,
                          endIndent: 40,
                          height: 2,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed('/login-keluarga');
                          },
                          child: Text(
                            "Saya sudah mendaftar",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue[300],
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextInputType type,
      FormFieldSetter<String> onSaved,
      {int maxLength = 100}) {
    return TextFormField(
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 14.0),
        suffixIcon: Icon(
          icon,
          color: const Color(0xFF08b10b),
        ),
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF12d516), width: 2.0),
        ),
      ),
      onSaved: onSaved,
      maxLength: maxLength == 16 ? maxLength : null,
      validator: (value) => value == "" ? 'Wajib terisi' : null,
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<PuskesmasModel>(
      decoration: InputDecoration(
        labelText: "Puskesmas Terdekat",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF12d516), width: 2.0),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
      items: _puskesmasList.isEmpty
          ? []
          : _puskesmasList.map((PuskesmasModel puskesmas) {
              return DropdownMenuItem<PuskesmasModel>(
                value: puskesmas,
                child: Text(puskesmas.namaPuskesmas),
              );
            }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedPuskesmas = newValue;
        });
      },
      validator: (value) => value == null ? 'Puskesmas harus dipilih' : null,
    );
  }
}
