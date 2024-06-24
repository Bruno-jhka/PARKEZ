import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String searchQuery = '';

  void _navigateToEstablishmentInfo({DocumentSnapshot? doc}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EstablishmentInfoPage(doc: doc),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administração de Estabelecimentos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Pesquisar Estabelecimento',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => _navigateToEstablishmentInfo(),
                  child: Text('Criar Estabelecimento'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('estabelecimentos')
                    .where('nome', isGreaterThanOrEqualTo: searchQuery)
                    .where('nome', isLessThanOrEqualTo: '$searchQuery\uf8ff')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var docs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      var doc = docs[index];
                      var data = doc.data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(data['nome']),
                        subtitle: Text(data['endereco']),
                        onTap: () {
                          _navigateToEstablishmentInfo(doc: doc);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EstablishmentInfoPage extends StatefulWidget {
  final DocumentSnapshot? doc;

  EstablishmentInfoPage({this.doc});

  @override
  _EstablishmentInfoPageState createState() => _EstablishmentInfoPageState();
}

class _EstablishmentInfoPageState extends State<EstablishmentInfoPage> {
  final _formKey = GlobalKey<FormState>();
  String nome = '';
  String cep = '';
  String numero = '';
  TimeOfDay? _weekdayOpeningTime;
  TimeOfDay? _weekdayClosingTime;
  TimeOfDay? _saturdayOpeningTime;
  TimeOfDay? _saturdayClosingTime;
  TimeOfDay? _sundayOpeningTime;
  TimeOfDay? _sundayClosingTime;
  String telefone = '';
  String descricao = '';
  int vagas = 0;
  File? _image;
  bool _isLoading = false;
  String preco = "0.0";

  // Controladores de texto
  final TextEditingController enderecoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.doc != null) {
      var data = widget.doc!.data() as Map<String, dynamic>;
      nome = data['nome'];
      cep = data['cep'];
      enderecoController.text = data['endereco'];
      numero = data['numero'];
      telefone = data['telefone'];
      descricao = data['descricao'];
      vagas = data['vagas'];
      preco = data['preco'];
      _weekdayOpeningTime = _timeFromString(data['weekdayOpening']);
      _weekdayClosingTime = _timeFromString(data['weekdayClosing']);
      _saturdayOpeningTime = _timeFromString(data['saturdayOpening']);
      _saturdayClosingTime = _timeFromString(data['saturdayClosing']);
      _sundayOpeningTime = _timeFromString(data['sundayOpening']);
      _sundayClosingTime = _timeFromString(data['sundayClosing']);
    }
  }

  TimeOfDay _timeFromString(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String _timeToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _buscarEnderecoPorCEP() async {
    if (cep.length == 8) {
      final url = 'https://viacep.com.br/ws/$cep/json/';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['erro'] == null) {
          setState(() {
            enderecoController.text =
                '${data['logradouro']}, ${data['bairro']}, ${data['localidade']}, ${data['uf']}';
          });
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('CEP não encontrado')));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erro ao buscar endereço')));
      }
    }
  }

  Future<void> _selectTime(BuildContext context, TimeOfDay? initialTime,
      Function(TimeOfDay) onTimeSelected) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != initialTime) {
      onTimeSelected(picked);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String imageUrl = '';
      if (_image != null) {
        var storageRef = FirebaseStorage.instance
            .ref()
            .child('estabelecimentos')
            .child('$nome.jpg');
        await storageRef.putFile(_image!);
        imageUrl = await storageRef.getDownloadURL();
      }

      await FirebaseFirestore.instance
          .collection('estabelecimentos')
          .doc(nome)
          .set({
        'nome': nome,
        'cep': cep,
        'endereco': enderecoController.text,
        /*'${enderecoController.text},${numero}'*/
        'numero': numero,
        'weekdayOpening': _timeToString(_weekdayOpeningTime!),
        'weekdayClosing': _timeToString(_weekdayClosingTime!),
        'saturdayOpening': _timeToString(_saturdayOpeningTime!),
        'saturdayClosing': _timeToString(_saturdayClosingTime!),
        'sundayOpening': _timeToString(_sundayOpeningTime!),
        'sundayClosing': _timeToString(_sundayClosingTime!),
        'telefone': telefone,
        'descricao': descricao,
        'vagas': vagas,
        'preco': preco,
        'imageUrl': imageUrl,
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Dados salvos com sucesso!')));
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao salvar os dados: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.doc == null
            ? 'Novo Estabelecimento'
            : 'Editar Estabelecimento'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                initialValue: nome,
                decoration: InputDecoration(labelText: 'Nome'),
                onSaved: (value) => nome = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do estabelecimento';
                  }
                  return null;
                },
                enabled: widget.doc == null, // Nome não editável se já criado
              ),
              TextFormField(
                initialValue: cep,
                decoration: InputDecoration(labelText: 'CEP'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    cep = value;
                  });
                  if (value.length == 8) {
                    _buscarEnderecoPorCEP();
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o CEP';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: enderecoController,
                decoration: InputDecoration(labelText: 'Endereço'),
                onSaved: (value) => enderecoController.text = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o endereço';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: numero,
                decoration: InputDecoration(labelText: 'Número'),
                keyboardType: TextInputType.number,
                onSaved: (value) => numero = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o número';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: telefone,
                decoration: InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
                onSaved: (value) => telefone = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o telefone';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: descricao,
                decoration: InputDecoration(labelText: 'Descrição'),
                onSaved: (value) => descricao = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: vagas.toString(),
                decoration: InputDecoration(labelText: 'Vagas Disponíveis'),
                keyboardType: TextInputType.number,
                onSaved: (value) => vagas = int.parse(value!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o número de vagas';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: preco.toString(),
                decoration: InputDecoration(labelText: 'Preço da Vaga'),
                keyboardType: TextInputType.number,
                onSaved: (value) => preco = (value!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o preço da vaga';
                  }
                  return null;
                },
              ),
              _buildTimePicker(
                context,
                'Horário de Abertura (Seg-Sex)',
                _weekdayOpeningTime,
                (time) => setState(() => _weekdayOpeningTime = time),
              ),
              _buildTimePicker(
                context,
                'Horário de Fechamento (Seg-Sex)',
                _weekdayClosingTime,
                (time) => setState(() => _weekdayClosingTime = time),
              ),
              _buildTimePicker(
                context,
                'Horário de Abertura (Sábado)',
                _saturdayOpeningTime,
                (time) => setState(() => _saturdayOpeningTime = time),
              ),
              _buildTimePicker(
                context,
                'Horário de Fechamento (Sábado)',
                _saturdayClosingTime,
                (time) => setState(() => _saturdayClosingTime = time),
              ),
              _buildTimePicker(
                context,
                'Horário de Abertura (Domingo)',
                _sundayOpeningTime,
                (time) => setState(() => _sundayOpeningTime = time),
              ),
              _buildTimePicker(
                context,
                'Horário de Fechamento (Domingo)',
                _sundayClosingTime,
                (time) => setState(() => _sundayClosingTime = time),
              ),
              _image != null
                  ? Image.file(_image!)
                  : Text('Nenhuma imagem selecionada'),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Selecionar Imagem'),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _uploadData();
                        }
                      },
                      child: Text('Salvar'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context, String label,
      TimeOfDay? selectedTime, Function(TimeOfDay) onTimeSelected) {
    return Row(
      children: [
        Text(label),
        Spacer(),
        Text(selectedTime != null ? _timeToString(selectedTime) : 'Selecionar'),
        IconButton(
          icon: Icon(Icons.access_time),
          onPressed: () => _selectTime(context, selectedTime, onTimeSelected),
        ),
      ],
    );
  }
}
